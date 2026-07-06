import 'package:flutter/material.dart';
import '../../domain/entities/cashier_performance_item.dart';

class CashierPerformanceTab extends StatelessWidget {
  final List<CashierPerformanceItem> items;

  const CashierPerformanceTab({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'لا توجد ورديات مغلقة لتحليل أداء الكاشير.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تحليل أداء موظفي الكاشير والتسويات المالية',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 10,
                    columns: const [
                      DataColumn(label: Text('الموظف', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الورديات', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('المبيعات', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('مرات العجز', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('العجز', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الزيادة', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('المتوسط', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: items.map((item) {
                      final hasShortage = item.totalShortage > 0;
                      final avgVarianceColor = item.avgVariance < 0
                          ? Colors.red.shade700
                          : (item.avgVariance > 0 ? Colors.green.shade700 : Colors.black87);

                      return DataRow(
                        cells: [
                          DataCell(Text(item.cashierName, style: const TextStyle(fontWeight: FontWeight.w600))),
                          DataCell(Text(item.totalShifts.toString())),
                          DataCell(Text('${item.totalSales.toStringAsFixed(2)} ج.م')),
                          DataCell(
                            Text(
                              item.shortageCount.toString(),
                              style: TextStyle(
                                color: hasShortage ? Colors.red : null,
                                fontWeight: hasShortage ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${item.totalShortage.toStringAsFixed(2)} ج.م',
                              style: TextStyle(
                                color: hasShortage ? Colors.red.shade700 : null,
                                fontWeight: hasShortage ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${item.totalSurplus.toStringAsFixed(2)} ج.م',
                              style: TextStyle(
                                color: item.totalSurplus > 0 ? Colors.green.shade700 : null,
                                fontWeight: item.totalSurplus > 0 ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${item.avgVariance.toStringAsFixed(2)} ج.م',
                              style: TextStyle(
                                color: avgVarianceColor,
                                fontWeight: FontWeight.bold,
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
          ),
        ],
      ),
    );
  }
}
