import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/treasury_bloc.dart';
import '../../domain/entities/treasury_transaction_entity.dart';
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

class _TreasuryView extends StatelessWidget {
  const _TreasuryView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Treasury Dashboard (الخزينة)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pos'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<TreasuryBloc>().add(const LoadTreasury()),
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
                content: const Text('✓ Treasury adjustment saved successfully!'),
                backgroundColor: colorScheme.primary,
              ),
            );
            context.read<TreasuryBloc>().add(const LoadTreasury());
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
                            'Current Treasury Balance',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${state.balance.toStringAsFixed(2)}',
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
                    'Recent Transactions (العمليات الأخيرة)',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                // Transactions List
                Expanded(
                  child: state.transactions.isEmpty
                      ? const Center(child: Text('No transactions recorded yet.'))
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.transactions.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final tx = state.transactions[index];
                            final isIncome = tx.type == 'sale_income' || tx.type == 'cash_in' || tx.type == 'shift_open';
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isIncome
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.red.withValues(alpha: 0.1),
                                child: Icon(
                                  isIncome ? Icons.trending_up : Icons.trending_down,
                                  color: isIncome ? Colors.green : Colors.red,
                                ),
                              ),
                              title: Text(tx.description ?? tx.type.toUpperCase()),
                              subtitle: Text(
                                '${DateFormat.yMd().add_jm().format(tx.createdAt)} • Shift: #${tx.shiftId ?? "N/A"}',
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${isIncome ? "+" : "-"}\$${tx.amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isIncome ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  Text(
                                    'Bal: \$${tx.balanceAfter.toStringAsFixed(2)}',
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
        title: Text(type == 'cash_in' ? 'Deposit Cash (إيداع نقدي)' : 'Withdraw Cash (سحب نقدي)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: r'Amount ($)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Reason/Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0.0;
              final desc = descController.text;
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
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
