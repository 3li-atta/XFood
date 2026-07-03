import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../bloc/profit_loss_bloc.dart';
import '../bloc/profit_loss_event.dart';
import '../bloc/profit_loss_state.dart';

/// تقرير الأرباح والخسائر (Profit & Loss Report) - مخصص باللغة العربية بالكامل وبدون تداخل.
class ProfitLossPage extends StatelessWidget {
  const ProfitLossPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfitLossBloc>()
        ..add(LoadProfitLossReport(
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now(),
        )),
      child: const _ProfitLossView(),
    );
  }
}

class _ProfitLossView extends StatefulWidget {
  const _ProfitLossView();

  @override
  State<_ProfitLossView> createState() => _ProfitLossViewState();
}

class _ProfitLossViewState extends State<_ProfitLossView> {
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  void _onSelectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      locale: const Locale('ar'), // عرض التقويم باللغة العربية
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF1E3A8A),
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black87,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
      if (mounted) {
        context.read<ProfitLossBloc>().add(LoadProfitLossReport(
              startDate: picked.start,
              endDate: picked.end,
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: const Text('تقرير الأرباح والخسائر'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pos'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // كارت اختيار الفترة (مؤمن ضد التداخل والـ Overflow)
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 500;
                      final dateRangeWidget = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'فترة التقرير',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${dateFormat.format(_selectedDateRange.start)}  ➔  ${dateFormat.format(_selectedDateRange.end)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E3A8A),
                              ),
                            ),
                          ),
                        ],
                      );

                      final changeDateButton = FilledButton.icon(
                        onPressed: _onSelectDateRange,
                        icon: const Icon(Icons.date_range, size: 18),
                        label: const Text('تغيير التاريخ'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );

                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            dateRangeWidget,
                            const SizedBox(height: 12),
                            changeDateButton,
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: dateRangeWidget),
                          const SizedBox(width: 16),
                          changeDateButton,
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // محتوى التقرير المالي
              Expanded(
                child: BlocBuilder<ProfitLossBloc, ProfitLossState>(
                  builder: (context, state) {
                    if (state is ProfitLossLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ProfitLossError) {
                      return Center(
                        child: Text(
                          'خطأ: ${state.errorMessage}',
                          style: TextStyle(color: colorScheme.error),
                        ),
                      );
                    }
                    if (state is ProfitLossLoaded) {
                      final r = state.report;
                      final isNetProfit = r.netProfit >= 0;

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // كارت صافي الربح / الخسارة الرئيسي
                            Card(
                              color: isNetProfit
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isNetProfit
                                      ? Colors.green.shade300
                                      : Colors.red.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final isNarrow = constraints.maxWidth < 450;
                                    
                                    final avatar = CircleAvatar(
                                      radius: 36,
                                      backgroundColor: isNetProfit
                                          ? Colors.green.shade200
                                          : Colors.red.shade200,
                                      child: Icon(
                                        isNetProfit
                                            ? Icons.trending_up_rounded
                                            : Icons.trending_down_rounded,
                                        size: 40,
                                        color: isNetProfit
                                            ? Colors.green.shade900
                                            : Colors.red.shade900,
                                      ),
                                    );

                                    final textColumn = Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isNetProfit ? 'صافي الربح' : 'صافي الخسارة',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isNetProfit
                                                ? Colors.green.shade900
                                                : Colors.red.shade900,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '(المبيعات - تكلفة المبيعات - الهالك - المصروفات)',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: isNetProfit
                                                ? Colors.green.shade700
                                                : Colors.red.shade700,
                                          ),
                                        ),
                                      ],
                                    );

                                    final valueWidget = FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${r.netProfit.toStringAsFixed(2)} ج.م',
                                        style: theme.textTheme.headlineLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isNetProfit
                                              ? Colors.green.shade900
                                              : Colors.red.shade900,
                                        ),
                                      ),
                                    );

                                    if (isNarrow) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              avatar,
                                              const SizedBox(width: 16),
                                              Expanded(child: textColumn),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: valueWidget,
                                          ),
                                        ],
                                      );
                                    }

                                    return Row(
                                      children: [
                                        avatar,
                                        const SizedBox(width: 24),
                                        Expanded(child: textColumn),
                                        const SizedBox(width: 12),
                                        valueWidget,
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // شبكة كروت المقاييس المالية
                            GridView.count(
                              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 5 : 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.4,
                              children: [
                                _buildMetricCard(
                                  title: 'إجمالي المبيعات',
                                  value: r.totalRevenue,
                                  color: Colors.green,
                                  icon: Icons.attach_money_rounded,
                                ),
                                _buildMetricCard(
                                  title: 'تكلفة المبيعات',
                                  value: r.totalCOGS,
                                  color: Colors.orange,
                                  icon: Icons.restaurant_menu_rounded,
                                ),
                                _buildMetricCard(
                                  title: 'تكلفة الهالك',
                                  value: r.totalWasteCost,
                                  color: Colors.red,
                                  icon: Icons.delete_forever_rounded,
                                ),
                                _buildMetricCard(
                                  title: 'المصروفات التشغيلية',
                                  value: r.totalExpenses,
                                  color: Colors.redAccent,
                                  icon: Icons.money_off_rounded,
                                ),
                                _buildMetricCard(
                                  title: 'المشتريات',
                                  value: r.totalPurchases,
                                  color: Colors.blue,
                                  icon: Icons.shopping_cart_rounded,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(
                      child: Text('اختر فترة التقرير لعرض البيانات.'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required double value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.1),
                  child: Icon(icon, color: color),
                ),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${value.toStringAsFixed(2)} ج.م',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
