import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../bloc/treasury_bloc.dart';
import '../../../shifts/presentation/bloc/shift_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/session_manager.dart';

class TreasuryPage extends StatelessWidget {
  const TreasuryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<TreasuryBloc>()..add(const LoadTreasury()),
        ),
        BlocProvider(
          create: (_) => getIt<ShiftBloc>()..add(CheckActiveShift(session.currentUserId)),
        ),
      ],
      child: const _TreasuryView(),
    );
  }
}

class _TreasuryView extends StatefulWidget {
  const _TreasuryView();

  @override
  State<_TreasuryView> createState() => _TreasuryViewState();
}

class _TreasuryViewState extends State<_TreasuryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<TreasuryBloc>().add(const LoadMoreTreasury());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الخزينة', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          tooltip: 'العودة للمبيعات',
          onPressed: () => context.go('/pos'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث البيانات',
            onPressed: () => context.read<TreasuryBloc>().add(const LoadTreasury(isRefresh: true)),
          )
        ],
      ),
      body: BlocConsumer<TreasuryBloc, TreasuryState>(
        listener: (context, state) {
          if (state is TreasuryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
              ),
            );
          } else if (state is TreasurySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('✓ تم حفظ حركة الخزينة بنجاح!'),
                backgroundColor: colorScheme.primary,
              ),
            );
            context.read<TreasuryBloc>().add(const LoadTreasury(isRefresh: true));
          }
        },
        builder: (context, state) {
          if (state is TreasuryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TreasuryLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Card: Balance
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    color: colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Text(
                            'رصيد الخزينة الحالي',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${state.balance.toStringAsFixed(2)} ج.م',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _showAdjustmentDialog(context, 'cash_in'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  icon: const Icon(Icons.add, color: Colors.white),
                                  label: const Text(
                                    'إيداع',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _showAdjustmentDialog(context, 'cash_out'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEF4444),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  icon: const Icon(Icons.remove, color: Colors.white),
                                  label: const Text(
                                    'سحب',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Transactions Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'العمليات الأخيرة بالخزينة',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                // Transactions List
                Expanded(
                  child: state.transactions.isEmpty
                      ? const Center(child: Text('لا توجد عمليات مسجلة في الخزينة حتى الآن.'))
                      : ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: state.transactions.length + (state.hasMore ? 1 : 0),
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            if (index >= state.transactions.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final tx = state.transactions[index];
                            final isNeutral = tx.type == 'shift_close';
                            final isIncome = !isNeutral && (tx.type == 'sale_income' || tx.type == 'cash_in' || tx.type == 'shift_open');

                            Color iconBgColor;
                            IconData iconData;
                            Color iconColor;
                            String amountPrefix;
                            Color amountColor;

                            if (isNeutral) {
                              iconBgColor = Colors.blue.withValues(alpha: 0.1);
                              iconData = Icons.lock_outline;
                              iconColor = Colors.blue;
                              amountPrefix = '';
                              amountColor = Colors.blue.shade800;
                            } else {
                              iconBgColor = isIncome
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1);
                              iconData = isIncome ? Icons.trending_up : Icons.trending_down;
                              iconColor = isIncome ? Colors.green : Colors.red;
                              amountPrefix = isIncome ? "+" : "-";
                              amountColor = isIncome ? Colors.green : Colors.red;
                            }

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: iconBgColor,
                                child: Icon(
                                  iconData,
                                  color: iconColor,
                                ),
                              ),
                              title: Text(_getArabicDescription(tx.description, tx.type), style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                '${DateFormat('yyyy-MM-dd HH:mm').format(tx.createdAt)} • الوردية: #${tx.shiftId ?? "غير محدد"}',
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '$amountPrefix${tx.amount.toStringAsFixed(2)} ج.م',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: amountColor,
                                    ),
                                  ),
                                  Text(
                                    'Bal: ${tx.balanceAfter.toStringAsFixed(2)} ج.m',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAdjustmentDialog(BuildContext context, String type) {
    final amountController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(
          type == 'cash_in' ? 'إيداع نقدي بالخزينة' : 'سحب نقدي من الخزينة',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'المبلغ المراد إدخاله (ج.م) *',
                    hintText: 'أدخل قيمة المبلغ...',
                    prefixIcon: Icon(Icons.calculate_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'السبب / البيان *',
                    hintText: 'توضيح سبب حركة الإيداع/السحب...',
                    prefixIcon: Icon(Icons.note_alt_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0.0;
              final desc = descController.text.trim();
              if (amount > 0) {
                final shiftState = context.read<ShiftBloc>().state;
                int? shiftId;
                if (shiftState.activeShift != null) {
                  shiftId = shiftState.activeShift!.id;
                }

                context.read<TreasuryBloc>().add(
                      AddManualAdjustmentRequested(
                        userId: SessionManager.instance.currentUserId,
                        shiftId: shiftId,
                        type: type,
                        amount: amount,
                        description: desc.isNotEmpty ? desc : null,
                      ),
                    );
                Navigator.pop(dialogCtx);
              }
            },
            child: const Text('تأكيد الحركة'),
          ),
        ],
      ),
    );
  }

  String _getArabicDescription(String? description, String type) {
    if (description == null || description.isEmpty) {
      switch (type) {
        case 'sale_income':
          return 'إيراد مبيعات';
        case 'cash_in':
          return 'إيداع نقدي يدوي';
        case 'cash_out':
          return 'سحب نقدي يدوي';
        case 'shift_open':
          return 'رأس مال افتتاح الوردية';
        case 'expense':
          return 'تسجيل مصروف';
        case 'purchase':
          return 'مشتريات';
        default:
          return type.toUpperCase();
      }
    }
    
    final desc = description.trim();
    if (desc.startsWith('Sale income from Transaction #')) {
      final id = desc.replaceAll('Sale income from Transaction #', '');
      return 'إيراد مبيعات فاتورة رقم #$id';
    }
    if (desc.startsWith('Shift starting cash - Shift #')) {
      final id = desc.replaceAll('Shift starting cash - Shift #', '');
      return 'عهدة افتتاح الوردية رقم #$id';
    }
    if (desc.startsWith('Expense: ')) {
      final cat = desc.replaceAll('Expense: ', '');
      return 'تسجيل مصروف: $cat';
    }
    if (desc.startsWith('Purchase: Bill #')) {
      final id = desc.replaceAll('Purchase: Bill #', '');
      return 'شراء سلع - فاتورة رقم #$id';
    }
    
    if (desc.startsWith('Closing cash count for shift #')) {
      final parts = desc.split('. Reconciled variance: ');
      final shiftPart = parts[0].replaceAll('Closing cash count for shift #', '');
      final variancePart = parts.length > 1 ? parts[1] : '0.0';
      final double? varVal = double.tryParse(variancePart);
      final varStr = varVal != null ? varVal.toStringAsFixed(2) : variancePart;
      return 'جرد وإغلاق الوردية رقم #$shiftPart (الفارق: $varStr ج.م)';
    }
    
    if (desc.toLowerCase() == 'manual cash in') return 'إيداع نقدي يدوي';
    if (desc.toLowerCase() == 'manual cash out') return 'سحب نقدي يدوي';
    
    return desc;
  }
}
