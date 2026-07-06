import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../core/di/injection.dart';
import '../../../../database/app_database.dart';
import '../bloc/profit_loss_bloc.dart';
import '../bloc/profit_loss_event.dart';
import '../bloc/profit_loss_state.dart';

/// تقرير الأرباح والخسائر والمزيج والتكاليف (Analytical Dashboard)
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التقارير التحليلية والربحية', style: TextStyle(fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            tooltip: 'العودة للمبيعات',
            onPressed: () => context.go('/pos'),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.65),
            indicatorColor: const Color(0xFF10B981), // CTA green indicator
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3.5,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            tabs: const [
              Tab(
                text: 'الأرباح والخسائر',
                icon: Icon(Icons.analytics, size: 22),
              ),
              Tab(
                text: 'مزيج المبيعات',
                icon: Icon(Icons.bar_chart, size: 22),
              ),
              Tab(
                text: 'تكاليف الوصفات',
                icon: Icon(Icons.receipt_long, size: 22),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProfitLossTab(theme, colorScheme, dateFormat),
            _buildSalesMixTab(theme, colorScheme, dateFormat),
            _buildRecipeCostsTab(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitLossTab(ThemeData theme, ColorScheme colorScheme, DateFormat dateFormat) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // كارت اختيار الفترة
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
                            childAspectRatio: 1.3,
                            children: [
                              _buildMetricCard(
                                title: 'إجمالي المبيعات',
                                value: r.totalRevenue,
                                color: Colors.blue.shade700,
                                icon: Icons.shopping_bag_outlined,
                              ),
                              _buildMetricCard(
                                title: 'تكلفة المبيعات (المكونات)',
                                value: r.totalCOGS,
                                color: Colors.orange.shade700,
                                icon: Icons.kitchen_outlined,
                              ),
                              _buildMetricCard(
                                title: 'هامش الربح الإجمالي',
                                value: r.totalRevenue - r.totalCOGS,
                                color: Colors.teal.shade700,
                                icon: Icons.monetization_on_outlined,
                              ),
                              _buildMetricCard(
                                title: 'قيمة المكونات التالفة',
                                value: r.totalWasteCost,
                                color: Colors.red.shade700,
                                icon: Icons.delete_sweep_outlined,
                              ),
                              _buildMetricCard(
                                title: 'إجمالي المصروفات',
                                value: r.totalExpenses,
                                color: Colors.purple.shade700,
                                icon: Icons.receipt_outlined,
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
    );
  }

  Widget _buildSalesMixTab(ThemeData theme, ColorScheme colorScheme, DateFormat dateFormat) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'تقرير مزيج المبيعات (Sales Mix)',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _exportSalesMixReport(),
                icon: const Icon(Icons.share),
                label: const Text('مشاركة / طباعة التقرير'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'تحليل كميات وقيمة مبيعات الأصناف ونسبتها من إجمالي الإيرادات للفترة من ${dateFormat.format(_selectedDateRange.start)} إلى ${dateFormat.format(_selectedDateRange.end)}',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: getIt<AppDatabase>().transactionDao.getSalesMixReport(_selectedDateRange.start, _selectedDateRange.end),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('لا توجد مبيعات مسجلة في هذه الفترة'),
                  ),
                );
              }

              final reportData = snapshot.data!;
              final double grandTotalRevenue = reportData.fold(0.0, (sum, item) => sum + (item['total_revenue'] as double));

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 20,
                            columns: const [
                              DataColumn(label: Text('اسم الصنف', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('الكمية المباعة', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('سعر البيع', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('إجمالي الإيراد', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('نسبة الإيراد', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: reportData.map((item) {
                              final double totalRevenue = item['total_revenue'] as double;
                              final double percentage = grandTotalRevenue > 0 ? (totalRevenue / grandTotalRevenue) * 100 : 0.0;
                              return DataRow(
                                cells: [
                                  DataCell(Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600))),
                                  DataCell(Text((item['qty'] as double).toStringAsFixed(0))),
                                  DataCell(Text('${(item['price'] as double).toStringAsFixed(2)} ج.م')),
                                  DataCell(Text('${totalRevenue.toStringAsFixed(2)} ج.م')),
                                  DataCell(Text('${percentage.toStringAsFixed(1)}%')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        const Divider(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('إجمالي إيرادات المبيعات:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(
                                '${grandTotalRevenue.toStringAsFixed(2)} ج.م',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCostsTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'تقرير تكاليف الوصفات وهامش الربح',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _exportRecipeCostsReport(),
                icon: const Icon(Icons.share),
                label: const Text('مشاركة / طباعة التقرير'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'حساب تكلفة إنتاج الوجبات بناءً على أسعار شراء المكونات الحالية ومقارنتها بسعر البيع لتحديد هامش الربح.',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: getIt<AppDatabase>().transactionDao.getRecipeCostSummary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('لا توجد وجبات نشطة لعرض تكاليفها'),
                  ),
                );
              }

              final reportData = snapshot.data!;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('اسم الوجبة', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('تكلفة المكونات', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('سعر البيع', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('هامش الربح (ج.م)', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('نسبة الربح', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: reportData.map((item) {
                          final double sellingPrice = item['selling_price'] as double;
                          final double totalCost = item['total_cost'] as double;
                          final double profit = sellingPrice - totalCost;
                          final double profitMargin = sellingPrice > 0 ? (profit / sellingPrice) * 100 : 0.0;
                          final isProfitable = profit >= 0;

                          return DataRow(
                            cells: [
                              DataCell(Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600))),
                              DataCell(Text('${totalCost.toStringAsFixed(2)} ج.م')),
                              DataCell(Text('${sellingPrice.toStringAsFixed(2)} ج.م')),
                              DataCell(
                                Text(
                                  '${profit.toStringAsFixed(2)} ج.م',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isProfitable ? Colors.green.shade700 : Colors.red.shade700,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${profitMargin.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isProfitable ? Colors.green.shade700 : Colors.red.shade700,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _exportSalesMixReport() async {
    final reportData = await getIt<AppDatabase>().transactionDao.getSalesMixReport(_selectedDateRange.start, _selectedDateRange.end);
    final double grandTotalRevenue = reportData.fold(0.0, (sum, item) => sum + (item['total_revenue'] as double));
    final buffer = StringBuffer();
    buffer.writeln('--------------------------------------------------');
    buffer.writeln('          تقرير مزيج المبيعات (Sales Mix)          ');
    buffer.writeln('--------------------------------------------------');
    buffer.writeln('الفترة من: ${DateFormat('yyyy-MM-dd').format(_selectedDateRange.start)} إلى ${DateFormat('yyyy-MM-dd').format(_selectedDateRange.end)}');
    buffer.writeln('--------------------------------------------------');
    buffer.writeln('اسم الصنف | الكمية | سعر البيع | إجمالي الإيراد | النسبة');
    buffer.writeln('--------------------------------------------------');
    for (final item in reportData) {
      final double totalRevenue = item['total_revenue'] as double;
      final double percentage = grandTotalRevenue > 0 ? (totalRevenue / grandTotalRevenue) * 100 : 0.0;
      buffer.writeln('${item['name']} | ${item['qty'].toStringAsFixed(0)} | ${item['price'].toStringAsFixed(2)} | ${totalRevenue.toStringAsFixed(2)} | ${percentage.toStringAsFixed(1)}%');
    }
    buffer.writeln('--------------------------------------------------');
    buffer.writeln('إجمالي الإيرادات: ${grandTotalRevenue.toStringAsFixed(2)} ج.م');
    buffer.writeln('--------------------------------------------------');

    if (mounted) {
      _showShareDialog(context, 'تقرير مزيج المبيعات', buffer.toString());
    }
  }

  void _exportRecipeCostsReport() async {
    final reportData = await getIt<AppDatabase>().transactionDao.getRecipeCostSummary();
    final buffer = StringBuffer();
    buffer.writeln('--------------------------------------------------');
    buffer.writeln('     تقرير تكاليف الوصفات (Recipe Cost Summary)     ');
    buffer.writeln('--------------------------------------------------');
    buffer.writeln('تاريخ التصدير: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}');
    buffer.writeln('--------------------------------------------------');
    buffer.writeln('اسم الوجبة | تكلفة المكونات | سعر البيع | هامش الربح | النسبة');
    buffer.writeln('--------------------------------------------------');
    for (final item in reportData) {
      final double sellingPrice = item['selling_price'] as double;
      final double totalCost = item['total_cost'] as double;
      final double profit = sellingPrice - totalCost;
      final double profitMargin = sellingPrice > 0 ? (profit / sellingPrice) * 100 : 0.0;
      buffer.writeln('${item['name']} | ${totalCost.toStringAsFixed(2)} | ${sellingPrice.toStringAsFixed(2)} | ${profit.toStringAsFixed(2)} | ${profitMargin.toStringAsFixed(1)}%');
    }
    buffer.writeln('--------------------------------------------------');

    if (mounted) {
      _showShareDialog(context, 'تقرير تكاليف الوصفات', buffer.toString());
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
            const Text('تم إنشاء التقرير بنجاح! يمكنك نسخ النص أدناه أو مشاركته.', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 250),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  content,
                  style: const TextStyle(fontFamily: 'Courier', fontSize: 11),
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
            icon: const Icon(Icons.copy),
            label: const Text('نسخ التقرير'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(ctx);
              await _exportToPdf(context, title, content);
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('تصدير PDF'),
          ),
        ],
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
