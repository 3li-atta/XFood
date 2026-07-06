import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '../bloc/shift_bloc.dart';
import '../../domain/entities/shift_entity.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/session_manager.dart';
import '../../../../core/services/device_config_service.dart';
import '../../../../database/app_database.dart';
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
        title: const Text('إدارة الورديات', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          tooltip: 'العودة للمبيعات',
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
                content: const Text('✓ تم إغلاق الوردية بنجاح!'),
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
                            'سجل الورديات',
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
                            'سجل الورديات',
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
    final isMaster = getIt<DeviceConfigService>().isMaster;

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
                'الوردية النشطة مفتوحة',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('رقم الوردية', '#${shift.id}'),
          _buildInfoRow('اسم الكاشير', shift.cashierName),
          _buildInfoRow('تاريخ ووقت الفتح', DateFormat('yyyy-MM-dd HH:mm').format(shift.openedAt)),
          const Divider(height: 32),
          _buildInfoRow('العهدة الافتتاحية', '${shift.startingCash.toStringAsFixed(2)} ج.م'),
          _buildInfoRow('إجمالي المبيعات', '${shift.totalSales.toStringAsFixed(2)} ج.م', color: colorScheme.primary),
          _buildInfoRow('إجمالي المشتريات (المصروفات)', '-${shift.totalPurchases.toStringAsFixed(2)} ج.م', color: colorScheme.error),
          _buildInfoRow('الإدخال النقدي اليدوي', '${shift.totalCashIn.toStringAsFixed(2)} ج.م'),
          _buildInfoRow('الصرف النقدي اليدوي', '-${shift.totalCashOut.toStringAsFixed(2)} ج.م'),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'النقد المتوقع في الدرج:',
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
          if (isMaster) ...[
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
                  'تسجيل مصروف تشغيلي',
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
                label: const Text('إغلاق الوردية وتصدير التقرير'),
              ),
            ),
          ] else ...[
            if (isMobile) const SizedBox(height: 32) else const Spacer(),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'تسجيل المصروفات وإغلاق الوردية متاح فقط من الكاشير الرئيسي.',
                      style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          'لا توجد وردية نشطة مفتوحة',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'يجب فتح وردية جديدة وتحديد عهدة البداية قبل البدء في معالجة المعاملات والمبيعات.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        if (isMaster)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: () => _showOpenShiftDialog(context),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add),
              label: const Text('فتح وردية جديدة'),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'يرجى فتح وردية جديدة من جهاز الكاشير الرئيسي لبدء المبيعات.',
                    style: TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
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
      return const Center(child: Text('لم يتم العثور على ورديات سابقة.'));
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
          title: Text('وردية رقم #${s.id} - الكاشير: ${s.cashierName}'),
          subtitle: Text(
            isOpen
                ? 'تم الفتح: ${DateFormat('yyyy-MM-dd HH:mm').format(s.openedAt)}'
                : 'تم الإغلاق: ${s.closedAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(s.closedAt!) : "-"}',
            style: const TextStyle(fontSize: 12),
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
                    isOpen ? 'مفتوحة' : 'مغلقة',
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
                    'الفارق: ${s.variance!.toStringAsFixed(2)} ج.م',
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
        title: const Text('فتح وردية جديدة', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'مبلغ عهدة البداية (ج.م) *',
                    hintText: 'مثال: 100.00',
                    prefixIcon: Icon(Icons.wallet_giftcard_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgContext),
            child: const Text('إلغاء'),
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
            child: const Text('فتح الوردية'),
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
        title: const Text('إغلاق الوردية وتقرير Z', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 450,
          child: FutureBuilder<Map<String, dynamic>>(
            future: getIt<AppDatabase>().transactionDao.getZReportData(shift.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final data = snapshot.data ?? {};
              final cashSales = data['cashSales'] as double? ?? 0.0;
              final cardSales = data['cardSales'] as double? ?? 0.0;
              final onlineSales = data['onlineSales'] as double? ?? 0.0;
              final totalDiscounts = data['totalDiscounts'] as double? ?? 0.0;
              final totalTax = data['totalTax'] as double? ?? 0.0;
              final refundsCount = data['refundsCount'] as int? ?? 0;
              final refundAmount = data['refundAmount'] as double? ?? 0.0;

              return Directionality(
                textDirection: ui.TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Z-Report Summary Box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF1E3A8A).withValues(alpha: 0.15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.analytics_rounded, color: Color(0xFF1E3A8A), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'تفاصيل المبيعات حسب طريقة الدفع:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E3A8A)),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            _buildInfoRow('مبيعات نقداً', '${cashSales.toStringAsFixed(2)} ج.م'),
                            _buildInfoRow('مبيعات شبكة / بطاقة', '${cardSales.toStringAsFixed(2)} ج.م'),
                            _buildInfoRow('مبيعات أونلاين', '${onlineSales.toStringAsFixed(2)} ج.م'),
                            const Divider(height: 20),
                            _buildInfoRow('إجمالي الخصومات', '${totalDiscounts.toStringAsFixed(2)} ج.م'),
                            _buildInfoRow('إجمالي الضريبة (14%)', '${totalTax.toStringAsFixed(2)} ج.م'),
                            _buildInfoRow('عدد المرتجعات', '$refundsCount'),
                            _buildInfoRow('إجمالي المرتجعات', '${refundAmount.toStringAsFixed(2)} ج.م', color: Colors.red),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Expected Cash Box
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.payments_outlined, color: Color(0xFF10B981), size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'النقد المتوقع في الدرج',
                                    style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${expectedCash.toStringAsFixed(2)} ج.م',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'المبلغ الفعلي المقبوض في الدرج (ج.م) *',
                          hintText: 'أدخل المبلغ المحسوب فعلياً في الصندوق...',
                          prefixIcon: Icon(Icons.calculate_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: notesController,
                        decoration: const InputDecoration(
                          labelText: 'ملاحظات إضافية (اختياري)',
                          hintText: 'توضيح أي عجز أو زيادة إن وجد...',
                          prefixIcon: Icon(Icons.note_alt_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgContext),
            child: const Text('إلغاء'),
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
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
            ),
            child: const Text('تأكيد وإغلاق الوردية'),
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
        title: Text('ملخص تقرير الوردية - وردية رقم #${s.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('اسم الكاشير', s.cashierName),
              _buildInfoRow('حالة الوردية', s.status == 'open' ? 'مفتوحة' : 'مغلقة', color: s.status == 'open' ? Colors.green : Colors.grey),
              _buildInfoRow('تاريخ ووقت الفتح', DateFormat('yyyy-MM-dd HH:mm').format(s.openedAt)),
              if (s.closedAt != null)
                _buildInfoRow('تاريخ ووقت الإغلاق', DateFormat('yyyy-MM-dd HH:mm').format(s.closedAt!)),
              const Divider(),
              _buildInfoRow('عهدة البداية', '${s.startingCash.toStringAsFixed(2)} ج.م'),
              _buildInfoRow('إجمالي المبيعات', '${s.totalSales.toStringAsFixed(2)} ج.م'),
              _buildInfoRow('إجمالي المشتريات (المصروفات)', '-${s.totalPurchases.toStringAsFixed(2)} ج.م', color: Colors.red),
              _buildInfoRow('المقبوضات النقدية (الإدخال)', '${s.totalCashIn.toStringAsFixed(2)} ج.م'),
              _buildInfoRow('المدفوعات النقدية (الصرف)', '-${s.totalCashOut.toStringAsFixed(2)} ج.م'),
              if (s.expectedClosingCash != null) ...[
                const Divider(),
                _buildInfoRow('النقد المتوقع عند الإغلاق', '${s.expectedClosingCash!.toStringAsFixed(2)} ج.م'),
                _buildInfoRow('النقد الفعلي عند الإغلاق', '${s.actualClosingCash!.toStringAsFixed(2)} ج.م'),
                _buildInfoRow(
                  'الفارق (العجز/الزيادة)',
                  '${s.variance!.toStringAsFixed(2)} ج.م',
                  color: s.variance! < 0 ? Colors.red : (s.variance! > 0 ? Colors.blue : Colors.green),
                ),
              ],
              if (s.notes != null) ...[
                const Divider(),
                Text('ملاحظات إضافية:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(s.notes!, style: const TextStyle(fontStyle: FontStyle.italic)),
              ]
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
