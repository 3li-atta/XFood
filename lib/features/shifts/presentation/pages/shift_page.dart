import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '../bloc/shift_bloc.dart';
import '../../domain/entities/shift_entity.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/session_manager.dart';
import '../../../expenses/presentation/bloc/expense_bloc.dart';
import '../../../expenses/presentation/bloc/expense_event.dart';
import '../../../expenses/presentation/bloc/expense_state.dart';

class ShiftPage extends StatelessWidget {
  const ShiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.instance;
    return BlocProvider(
      create: (_) => getIt<ShiftBloc>()
        ..add(CheckActiveShift(session.currentUserId))
        ..add(const LoadShiftHistory()),
      child: const _ShiftView(),
    );
  }
}

class _ShiftView extends StatelessWidget {
  const _ShiftView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final session = SessionManager.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Management (إدارة الوردية)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pos'),
        ),
      ),
      body: BlocConsumer<ShiftBloc, ShiftState>(
        listener: (context, state) {
          if (state.status == ShiftStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: colorScheme.error,
              ),
            );
          } else if (state.status == ShiftStatus.closed && state.closedShiftId != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('✓ Shift closed successfully!'),
                backgroundColor: colorScheme.primary,
              ),
            );
            context.read<ShiftBloc>().add(const LoadShiftHistory());
          }
        },
        builder: (context, state) {
          final isMobile = MediaQuery.of(context).size.width < 800;

          if (isMobile) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Active Shift Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: _buildActiveShiftSection(context, state, isMobile: true),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Shift History Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shift History (سجل الورديات)',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Divider(height: 24),
                          _buildHistorySection(
                            context,
                            state,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Desktop Row Layout
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Active Shift Actions
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: _buildActiveShiftSection(context, state, isMobile: false),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Right side: Shift History List
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shift History (سجل الورديات)',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Divider(height: 24),
                          Expanded(
                            child: _buildHistorySection(context, state),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActiveShiftSection(BuildContext context, ShiftState state, {required bool isMobile}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final session = SessionManager.instance;

    if (state.status == ShiftStatus.loading && state.activeShift == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.activeShift != null) {
      final shift = state.activeShift!;
      final expectedCash = shift.startingCash +
          shift.totalSales -
          shift.totalPurchases +
          shift.totalCashIn -
          shift.totalCashOut;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: colorScheme.primary, size: 32),
              const SizedBox(width: 8),
              Text(
                'Active Shift Open',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Shift ID', '#${shift.id}'),
          _buildInfoRow('Cashier Name', shift.cashierName),
          _buildInfoRow('Opened At', DateFormat.yMd().add_jm().format(shift.openedAt)),
          const Divider(height: 32),
          _buildInfoRow('Starting Cash (العهدة)', '${shift.startingCash.toStringAsFixed(2)} ج.م'),
          _buildInfoRow('Total Sales (المبيعات)', '${shift.totalSales.toStringAsFixed(2)} ج.م', color: colorScheme.primary),
          _buildInfoRow('Total Purchases (المشتريات)', '-${shift.totalPurchases.toStringAsFixed(2)} ج.م', color: colorScheme.error),
          _buildInfoRow('Manual Cash In', '${shift.totalCashIn.toStringAsFixed(2)} ج.م'),
          _buildInfoRow('Manual Cash Out', '-${shift.totalCashOut.toStringAsFixed(2)} ج.م'),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expected Closing Cash:',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${expectedCash.toStringAsFixed(2)} ج.م',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => _showAddExpenseDialog(context, shift.id),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.primary, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(Icons.money_off, color: colorScheme.primary),
              label: Text(
                'تسجيل مصروف (إضافة مصروف)',
                style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
            ),
          ),
          if (isMobile) const SizedBox(height: 32) else const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: () => _showCloseShiftDialog(context, shift, expectedCash),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.lock),
              label: const Text('Close Shift (غلق الوردية)'),
            ),
          ),
        ],
      );
    }

    // No Active Shift Open
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_open_outlined, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3), size: 80),
        const SizedBox(height: 16),
        Text(
          'No Active Shift Open',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'You must open a shift (enter starting cash) before processing transactions.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: () => _showOpenShiftDialog(context),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Open New Shift (فتح وردية جديدة)'),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(BuildContext context, ShiftState state, {bool shrinkWrap = false, ScrollPhysics? physics}) {
    if (state.status == ShiftStatus.loading && state.history.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final shifts = state.history;
    if (shifts.isEmpty) {
      return const Center(child: Text('No previous shifts found.'));
    }
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: shifts.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final s = shifts[index];
        final isOpen = s.status == 'open';
        return ListTile(
          title: Text('Shift #${s.id} - ${s.cashierName}'),
          subtitle: Text(
            isOpen
                ? 'Opened: ${DateFormat.yMd().add_jm().format(s.openedAt)}'
                : 'Closed: ${s.closedAt != null ? DateFormat.yMd().add_jm().format(s.closedAt!) : "-"}',
          ),
          trailing: SizedBox(
            width: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOpen ? Colors.green.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isOpen ? 'OPEN' : 'CLOSED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isOpen ? Colors.green : Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                if (!isOpen && s.variance != null)
                  Text(
                    'Variance: ${s.variance!.toStringAsFixed(2)} ج.م',
                    style: TextStyle(
                      fontSize: 11,
                      color: s.variance! < 0 ? Colors.red : (s.variance! > 0 ? Colors.blue : Colors.green),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          onTap: () => _showShiftDetailDialog(context, s),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, int shiftId) {
    final session = SessionManager.instance;
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String selectedCategory = 'نثريات';

    final categories = ['رواتب', 'إيجار', 'فواتير', 'صيانة', 'نثريات'];

    showDialog(
      context: context,
      builder: (ctx) {
        return BlocProvider(
          create: (_) => getIt<ExpenseBloc>(),
          child: BlocConsumer<ExpenseBloc, ExpenseState>(
            listener: (context, state) {
              if (state is ExpenseSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(ctx);
                context.read<ShiftBloc>().add(CheckActiveShift(session.currentUserId));
              } else if (state is ExpenseFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is ExpenseLoading;

              return AlertDialog(
                title: const Text(
                  'إضافة مصروف تشغيلي',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: StatefulBuilder(
                  builder: (context, setState) {
                    return Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'فئة المصروف',
                            ),
                            items: categories.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat,
                                child: Text(cat),
                              );
                            }).toList(),
                            onChanged: isLoading
                                ? null
                                : (val) {
                                    if (val != null) {
                                      setState(() {
                                        selectedCategory = val;
                                      });
                                    }
                                  },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'القيمة (ج.م)',
                              hintText: '0.00',
                            ),
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: noteController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'ملاحظات',
                              hintText: 'تفاصيل المصروف...',
                            ),
                            enabled: !isLoading,
                          ),
                        ],
                      ),
                    );
                  }
                ),
                actions: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.pop(ctx),
                    child: const Text('إلغاء'),
                  ),
                  FilledButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            final amountText = amountController.text.trim();
                            final amount = double.tryParse(amountText);
                            if (amount == null || amount <= 0) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                const SnackBar(
                                  content: Text('الرجاء إدخال قيمة صالحة للمصروف'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            context.read<ExpenseBloc>().add(
                                  AddExpense(
                                    amount: amount,
                                    category: selectedCategory,
                                    note: noteController.text.trim(),
                                    userId: session.currentUserId ?? 0,
                                    activeShiftId: shiftId,
                                  ),
                                );
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('حفظ المصروف'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showOpenShiftDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dlgContext) => AlertDialog(
        title: const Text('Open Shift (فتح الوردية)'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Starting Cash / العهدة (ج.م)',
            hintText: 'e.g. 100.00',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text) ?? 0.0;
              context.read<ShiftBloc>().add(
                    OpenShiftRequested(
                      cashierId: SessionManager.instance.currentUserId,
                      startingCash: val,
                    ),
                  );
              Navigator.pop(dlgContext);
            },
            child: const Text('Open Shift'),
          ),
        ],
      ),
    );
  }

  void _showCloseShiftDialog(BuildContext context, ShiftEntity shift, double expectedCash) {
    final controller = TextEditingController();
    final notesController = TextEditingController();
    showDialog(
      context: context,
      builder: (dlgContext) => AlertDialog(
        title: const Text('Close Shift (غلق الوردية)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Expected cash in drawer: ${expectedCash.toStringAsFixed(2)} ج.م'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Actual Cash Counted / العد الفعلي (ج.م)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text) ?? 0.0;
              context.read<ShiftBloc>().add(
                    CloseShiftRequested(
                      shiftId: shift.id,
                      actualClosingCash: val,
                      notes: notesController.text.isNotEmpty ? notesController.text : null,
                    ),
                  );
              Navigator.pop(dlgContext);
            },
            child: const Text('Confirm & Close'),
          ),
        ],
      ),
    );
  }

  void _showShiftDetailDialog(BuildContext context, ShiftEntity s) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Shift Report Summary - Shift #${s.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Cashier Name', s.cashierName),
            _buildInfoRow('Status', s.status.toUpperCase()),
            _buildInfoRow('Opened At', DateFormat.yMd().add_jm().format(s.openedAt)),
            if (s.closedAt != null)
              _buildInfoRow('Closed At', DateFormat.yMd().add_jm().format(s.closedAt!)),
            const Divider(),
            _buildInfoRow('Starting Cash', '${s.startingCash.toStringAsFixed(2)} ج.م'),
            _buildInfoRow('Total Sales', '${s.totalSales.toStringAsFixed(2)} ج.م'),
            _buildInfoRow('Total Purchases', '-${s.totalPurchases.toStringAsFixed(2)} ج.م'),
            _buildInfoRow('Total Cash In', '${s.totalCashIn.toStringAsFixed(2)} ج.م'),
            _buildInfoRow('Total Cash Out', '-${s.totalCashOut.toStringAsFixed(2)} ج.م'),
            if (s.expectedClosingCash != null) ...[
              const Divider(),
              _buildInfoRow('Expected Closing Cash', '${s.expectedClosingCash!.toStringAsFixed(2)} ج.م'),
              _buildInfoRow('Actual Closing Cash', '${s.actualClosingCash!.toStringAsFixed(2)} ج.م'),
              _buildInfoRow(
                'Variance (العجز/الزيادة)',
                '${s.variance!.toStringAsFixed(2)} ج.م',
                color: s.variance! < 0 ? Colors.red : (s.variance! > 0 ? Colors.blue : Colors.green),
              ),
            ],
            if (s.notes != null) ...[
              const Divider(),
              Text('Notes:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text(s.notes!, style: const TextStyle(fontStyle: FontStyle.italic)),
            ]
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
