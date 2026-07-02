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
        title: const Text('Transaction History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pos'),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Sales', 'sale'),
                const SizedBox(width: 8),
                _buildFilterChip('Purchases', 'purchase'),
                const SizedBox(width: 8),
                _buildFilterChip('Waste', 'waste'),
                const Spacer(),
                // Summary
                FutureBuilder<List<TransactionEntity>>(
                  future: _txnFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    final total = snapshot.data!
                        .fold<double>(0, (s, t) => s + t.totalAmount);
                    return Chip(
                      avatar: Icon(Icons.summarize,
                          size: 16, color: colorScheme.primary),
                      label: Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary),
                      ),
                    );
                  },
                ),
              ],
            ),
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
                  return const Center(child: Text('No transactions yet.'));
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
                          '\$${txn.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: txn.isSale
                                ? Colors.green
                                : txn.isWaste
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
              Text('Date: ${DateFormat('MMM dd, yyyy HH:mm').format(txn.createdAt)}'),
              if (txn.notes != null) Text('Notes: ${txn.notes}'),
              const SizedBox(height: 12),
              const Divider(),
              ...items.map((item) => ListTile(
                    dense: true,
                    title: _TransactionItemTitle(item: item),
                    subtitle: Text('Qty: ${item.quantity.toStringAsFixed(1)}'),
                    trailing:
                        Text('\$${item.lineTotal.toStringAsFixed(2)}'),
                  )),
              const Divider(),
              ListTile(
                dense: true,
                title: const Text('Total',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text('\$${txn.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close')),
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
      case 'inventoryCheck':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'sale':
        return 'Sale';
      case 'purchase':
        return 'Purchase';
      case 'waste':
        return 'Waste';
      case 'inventoryCheck':
        return 'Inventory Check';
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
    if (item.isMealItem) {
      return FutureBuilder<MealEntity>(
        future: getIt<MealRepository>().getMealById(item.mealId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.name);
          }
          return Text('Meal #${item.mealId}');
        },
      );
    } else {
      return FutureBuilder<IngredientEntity>(
        future: getIt<InventoryRepository>().getIngredientById(item.ingredientId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.name);
          }
          return Text('Ingredient #${item.ingredientId}');
        },
      );
    }
  }
}
