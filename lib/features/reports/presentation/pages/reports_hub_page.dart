import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../core/di/injection.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';
import '../bloc/reports_state.dart';
import '../widgets/product_mix_tab.dart';
import '../widgets/expense_breakdown_tab.dart';
import '../widgets/consumption_tab.dart';
import '../widgets/peak_hours_tab.dart';
import '../widgets/cashier_performance_tab.dart';
import '../widgets/profit_loss_tab.dart';
import '../widgets/date_range_header.dart';

class ReportsHubPage extends StatelessWidget {
  const ReportsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReportsBloc>()
        ..add(LoadAllReportsEvent(
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now(),
        )),
      child: const _ReportsHubView(),
    );
  }
}

class _ReportsHubView extends StatefulWidget {
  const _ReportsHubView();

  @override
  State<_ReportsHubView> createState() => _ReportsHubViewState();
}

class _ReportsHubViewState extends State<_ReportsHubView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onSelectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      locale: const Locale('ar'),
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
        context.read<ReportsBloc>().add(LoadAllReportsEvent(
              startDate: picked.start,
              endDate: picked.end,
            ));
      }
    }
  }

  Future<void> _exportActiveReport(ReportsLoaded state) async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final startStr = dateFormat.format(_selectedDateRange.start);
    final endStr = dateFormat.format(_selectedDateRange.end);
    final buffer = StringBuffer();

    String title = '';
    switch (_tabController.index) {
      case 0:
        title = 'تقرير مزيج المنتجات وحجم المبيعات';
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('            $title            ');
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('الفترة من: $startStr إلى $endStr');
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('اسم الوجبة | الفئة | الكمية المباعة | الإيرادات | نسبة المساهمة');
        buffer.writeln('--------------------------------------------------');
        for (final item in state.productMix) {
          buffer.writeln(
              '${item.mealName} | ${_translateCategory(item.category)} | ${item.totalQuantity.toStringAsFixed(0)} | ${item.totalRevenue.toStringAsFixed(2)} ج.م | ${item.revenuePercentage.toStringAsFixed(1)}%');
        }
        break;
      case 1:
        title = 'تقرير توزيع المصروفات التشغيلية';
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('            $title            ');
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('الفترة من: $startStr إلى $endStr');
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('بند المصروف | عدد القيود | إجمالي المبلغ | النسبة المئوية');
        buffer.writeln('--------------------------------------------------');
        for (final item in state.expenseBreakdown) {
          buffer.writeln(
              '${item.category} | ${item.entryCount} | ${item.categoryTotal.toStringAsFixed(2)} ج.م | ${item.percentage.toStringAsFixed(1)}%');
        }
        break;
      case 2:
        title = 'تقرير استهلاك المكونات ونسب الهالك';
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('            $title            ');
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('الفترة من: $startStr إلى $endStr');
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('المكون | الوحدة | الاستهلاك القياسي | الكمية التالفة | إجمالي المستهلك | نسبة الهالك');
        buffer.writeln('--------------------------------------------------');
        for (final item in state.inventoryConsumption) {
          buffer.writeln(
              '${item.ingredientName} | ${item.unit} | ${item.standardUsage.toStringAsFixed(2)} | ${item.wasteUsage.toStringAsFixed(2)} | ${item.totalConsumed.toStringAsFixed(2)} | ${item.wasteRatio.toStringAsFixed(1)}%');
        }
        break;
      case 3:
        title = 'تقرير تحليل ساعات الذروة';
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('            $title            ');
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('الفترة من: $startStr إلى $endStr');
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('الساعة | عدد الطلبات | إجمالي الإيرادات');
        buffer.writeln('--------------------------------------------------');
        for (final item in state.peakHours) {
          final hourStr = '${item.hourOfDay.toString().padLeft(2, '0')}:00';
          buffer.writeln('$hourStr | ${item.transactionCount} طلب | ${item.totalRevenue.toStringAsFixed(2)} ج.م');
        }
        break;
      case 4:
        title = 'تقرير أداء موظفي الكاشير والتسويات';
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('            $title            ');
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('الفترة من: $startStr إلى $endStr');
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('الموظف | عدد الورديات | المبيعات | ورديات العجز | إجمالي العجز | إجمالي الزيادة | متوسط الفارق');
        buffer.writeln('--------------------------------------------------');
        for (final item in state.cashierPerformance) {
          buffer.writeln(
              '${item.cashierName} | ${item.totalShifts} | ${item.totalSales.toStringAsFixed(2)} ج.م | ${item.shortageCount} | ${item.totalShortage.toStringAsFixed(2)} ج.م | ${item.totalSurplus.toStringAsFixed(2)} ج.م | ${item.avgVariance.toStringAsFixed(2)} ج.م');
        }
        break;
      case 5:
        title = 'تقرير الأرباح والخسائر';
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('            $title            ');
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('الفترة من: $startStr إلى $endStr');
        buffer.writeln('--------------------------------------------------');
        final pl = state.profitLoss;
        buffer.writeln('إجمالي الإيرادات: ${pl.totalRevenue.toStringAsFixed(2)} ج.م');
        buffer.writeln('تكلفة البضاعة المباعة (COGS): ${pl.totalCOGS.toStringAsFixed(2)} ج.م');
        buffer.writeln('إجمالي الهالك المباشر: ${pl.totalWasteCost.toStringAsFixed(2)} ج.م');
        buffer.writeln('المصروفات التشغيلية: ${pl.totalExpenses.toStringAsFixed(2)} ج.م');
        buffer.writeln('--------------------------------------------------');
        buffer.writeln('صافي الربح / الخسارة: ${pl.netProfit.toStringAsFixed(2)} ج.م');
        buffer.writeln('--------------------------------------------------');
        break;
    }

    if (mounted) {
      _showShareDialog(context, title, buffer.toString());
    }
  }

  Future<void> _exportToPdf(BuildContext context, String title, String content) async {
    try {
      final pdf = pw.Document();
      final arabicFont = await PdfGoogleFonts.cairoRegular();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                title,
                style: pw.TextStyle(font: arabicFont, fontSize: 18, fontWeight: pw.FontWeight.bold),
                textDirection: pw.TextDirection.rtl,
              ),
            ),
            pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 10)),
            pw.Text(
              content,
              style: pw.TextStyle(font: arabicFont, fontSize: 11),
              textDirection: pw.TextDirection.rtl,
            ),
          ],
        ),
      );

      final bytes = await pdf.save();
      await Printing.sharePdf(bytes: bytes, filename: '${title.replaceAll(' ', '_')}.pdf');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ أثناء تصدير PDF: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showShareDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('تم إنشاء التقرير بنجاح! يمكنك نسخ النص أو مشاركته كـ PDF.', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  content,
                  style: const TextStyle(fontFamily: 'Courier', fontSize: 10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: content));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✓ تم نسخ التقرير إلى الحافظة!'), backgroundColor: Colors.green),
              );
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('نسخ'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(ctx);
              await _exportToPdf(context, title, content);
            },
            icon: const Icon(Icons.picture_as_pdf, size: 16),
            label: const Text('تصدير PDF'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز التقارير والتحليلات', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          tooltip: 'العودة للمبيعات',
          onPressed: () => context.go('/pos'),
        ),
        actions: [
          BlocBuilder<ReportsBloc, ReportsState>(
            builder: (context, state) {
              if (state is ReportsLoaded) {
                return IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  tooltip: 'مشاركة التقرير الحالي',
                  onPressed: () => _exportActiveReport(state),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.65),
          indicatorColor: const Color(0xFF10B981),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3.5,
          isScrollable: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'مزيج الأصناف', icon: Icon(Icons.bar_chart, size: 20)),
            Tab(text: 'المصروفات', icon: Icon(Icons.receipt_long, size: 20)),
            Tab(text: 'استهلاك المخزون', icon: Icon(Icons.inventory_2_outlined, size: 20)),
            Tab(text: 'ساعات الذروة', icon: Icon(Icons.access_time_filled_rounded, size: 20)),
            Tab(text: 'أداء الكاشير', icon: Icon(Icons.people, size: 20)),
            Tab(text: 'الأرباح والخسائر', icon: Icon(Icons.analytics_rounded, size: 20)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Date Range Selector Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DateRangeHeader(
                selectedDateRange: _selectedDateRange,
                onSelectDateRange: _onSelectDateRange,
              ),
            ),

            // Tab Views & Reports Content
            Expanded(
              child: BlocBuilder<ReportsBloc, ReportsState>(
                builder: (context, state) {
                  if (state is ReportsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ReportsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'حدث خطأ أثناء تحميل البيانات: ${state.errorMessage}',
                          style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  if (state is ReportsLoaded) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        ProductMixTab(items: state.productMix),
                        ExpenseBreakdownTab(
                          items: state.expenseBreakdown,
                          detailedExpenses: state.detailedExpenses,
                        ),
                        ConsumptionTab(items: state.inventoryConsumption),
                        PeakHoursTab(items: state.peakHours),
                        CashierPerformanceTab(items: state.cashierPerformance),
                        ProfitLossTab(profitLoss: state.profitLoss),
                      ],
                    );
                  }
                  return const Center(
                    child: Text('اختر فترة التقرير لعرض البيانات التحليلية.'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _translateCategory(String category) {
  switch (category.toLowerCase().trim()) {
    case 'main course':
      return 'وجبة رئيسية';
    case 'side':
      return 'جانبي';
    case 'drink':
      return 'مشروب';
    case 'dessert':
      return 'حلوى';
    case 'appetizer':
      return 'مقبلات';
    default:
      return category;
  }
}
