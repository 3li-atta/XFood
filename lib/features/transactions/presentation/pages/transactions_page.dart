import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_item_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../../meals/domain/repositories/meal_repository.dart';
import '../../../meals/domain/entities/meal_entity.dart';
import '../../../inventory/domain/repositories/inventory_repository.dart';
import '../../../../core/entities/ingredient_entity.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/session_manager.dart';

/// Transaction history page — view all past transactions with filtering.
class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late Future<List<TransactionEntity>> _txnFuture;
  final _repo = getIt<TransactionRepository>();
  String _filterType = 'all';

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    setState(() {
      _txnFuture = _filterType == 'all'
          ? _repo.getAllTransactions()
          : _repo.getTransactionsByType(_filterType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('MMM dd, yyyy – HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل المعاملات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pos'),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('الكل', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('المبيعات', 'sale'),
                  const SizedBox(width: 8),
                  _buildFilterChip('المشتريات', 'purchase'),
                  const SizedBox(width: 8),
                  _buildFilterChip('الهالك', 'waste'),
                  const SizedBox(width: 8),
                  _buildFilterChip('المصروفات', 'expense'),
                ],
              ),
            ),
          ),

          // Total Summary Card
          FutureBuilder<List<TransactionEntity>>(
            future: _txnFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox.shrink();
              }
              final total = snapshot.data!
                  .fold<double>(0, (s, t) => s + t.totalAmount);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.primaryContainer.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.summarize, size: 20, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'إجمالي المبلغ للمعاملات المفلترة:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${total.toStringAsFixed(2)} ج.م',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Transaction list
          Expanded(
            child: FutureBuilder<List<TransactionEntity>>(
              future: _txnFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('لا توجد معاملات بعد.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final txn = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor:
                              _getTypeColor(txn.type).withValues(alpha: 0.15),
                          child: Icon(_getTypeIcon(txn.type),
                              color: _getTypeColor(txn.type)),
                        ),
                        title: Row(
                          children: [
                            Text(
                              _getTypeLabel(txn.type),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '#${txn.id}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                        subtitle: Text(dateFormat.format(txn.createdAt)),
                        trailing: Text(
                          '${txn.totalAmount.toStringAsFixed(2)} ج.م',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: txn.isSale
                                ? Colors.green
                                : txn.isWaste || txn.type == 'expense' || txn.type == 'purchase'
                                    ? Colors.red
                                    : colorScheme.primary,
                          ),
                        ),
                        onTap: () => _showTransactionDetails(context, txn),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String type) {
    final isSelected = _filterType == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        _filterType = type;
        _loadTransactions();
      },
      showCheckmark: false,
      selectedColor: const Color(0xFF1E3A8A),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF1E3A8A),
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: isSelected ? Colors.transparent : const Color(0xFFD1D5DB),
        width: 1,
      ),
    );
  }

  void _showTransactionDetails(
      BuildContext context, TransactionEntity txn) async {
    final items = await _repo.getTransactionItems(txn.id, type: txn.type);
    final isRefunded = txn.type == 'sale' ? await _repo.isTransactionRefunded(txn.id) : false;

    // Parse discount tag
    final discountRegExp = RegExp(r'\[Discount:\s*([\d\.]+)%\]');
    final match = discountRegExp.firstMatch(txn.notes ?? '');
    final discountPercentage = match != null ? double.tryParse(match.group(1) ?? '0.0') ?? 0.0 : 0.0;
    final cleanNotes = txn.notes?.replaceAll(discountRegExp, '').trim();

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${_getTypeLabel(txn.type)} #${txn.id}'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('التاريخ: ${DateFormat('yyyy-MM-dd HH:mm').format(txn.createdAt)}'),
              if (cleanNotes != null && cleanNotes.isNotEmpty) Text('ملاحظات: $cleanNotes'),
              const SizedBox(height: 12),
              const Divider(),
              ...items.map((item) => ListTile(
                    dense: true,
                    title: _TransactionItemTitle(item: item),
                    subtitle: Text(item.itemType == 'expense' ? 'حالة المصروف' : 'الكمية: ${item.quantity.toStringAsFixed(1)}'),
                    trailing:
                        Text('${item.lineTotal.toStringAsFixed(2)} ج.م'),
                  )),
              if (discountPercentage > 0) ...[
                const Divider(),
                ListTile(
                  dense: true,
                  title: const Text('الإجمالي قبل الخصم (Subtotal)'),
                  trailing: Text('${(txn.totalAmount / (1 - discountPercentage / 100)).toStringAsFixed(2)} ج.م'),
                ),
                ListTile(
                  dense: true,
                  title: Text('خصم (Discount) ($discountPercentage%)'),
                  trailing: Text(
                    '- ${( (txn.totalAmount / (1 - discountPercentage / 100)) - txn.totalAmount ).toStringAsFixed(2)} ج.م',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
              const Divider(),
              ListTile(
                dense: true,
                title: const Text('الإجمالي (Total)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text('${txn.totalAmount.toStringAsFixed(2)} ج.م',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              if (txn.type == 'sale' && isRefunded) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'تم إرجاع هذا الطلب',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (txn.type == 'sale' && !isRefunded)
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(ctx);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (confirmCtx) => AlertDialog(
                    title: const Text('عمل مرتجع للطلب؟'),
                    content: const Text(
                        'هل أنت متأكد من رغبتك في عمل مرتجع لهذا الطلب بالكامل؟ سيتم إرجاع المكونات إلى المخزن وخصم المبلغ من درج الكاشير والخزينة.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(confirmCtx, false),
                        child: const Text('إلغاء'),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () => Navigator.pop(confirmCtx, true),
                        child: const Text('نعم، مرتجع'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  try {
                    final userId = SessionManager.instance.currentUserId;
                    await _repo.refundSaleTransaction(txn.id, userId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✓ تم إرجاع الطلب بنجاح!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _loadTransactions();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('خطأ: ${e.toString().replaceAll('Exception:', '')}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('عمل مرتجع'),
            ),
          FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إغلاق')),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'sale':
        return Icons.point_of_sale;
      case 'purchase':
        return Icons.shopping_bag;
      case 'waste':
        return Icons.delete_forever;
      case 'expense':
        return Icons.money_off;
      case 'inventoryCheck':
        return Icons.checklist;
      default:
        return Icons.receipt;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'sale':
        return Colors.green;
      case 'purchase':
        return Colors.blue;
      case 'waste':
        return Colors.red;
      case 'expense':
        return Colors.purple;
      case 'inventoryCheck':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'sale':
        return 'مبيعات';
      case 'purchase':
        return 'مشتريات';
      case 'waste':
        return 'هالك';
      case 'expense':
        return 'مصروفات';
      case 'inventoryCheck':
        return 'جرد مخزون';
      default:
        return type;
    }
  }
}

class _TransactionItemTitle extends StatelessWidget {
  final TransactionItemEntity item;
  const _TransactionItemTitle({required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.itemType == 'expense') {
      return const Text('مصروف تشغيلي');
    }
    if (item.isMealItem) {
      return FutureBuilder<MealEntity>(
        future: getIt<MealRepository>().getMealById(item.mealId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.name);
          }
          return Text('وجبة #${item.mealId}');
        },
      );
    } else {
      return FutureBuilder<IngredientEntity>(
        future: getIt<InventoryRepository>().getIngredientById(item.ingredientId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.name);
          }
          return Text('صنف #${item.ingredientId}');
        },
      );
    }
  }
}
