import 'package:flutter/material.dart';
import '../../domain/entities/consumption_item.dart';

class ConsumptionTab extends StatelessWidget {
  final List<ConsumptionItem> items;

  const ConsumptionTab({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'لا يوجد استهلاك للمخزون متوفر لهذه الفترة.',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تقرير استهلاك المكونات ونسب الهالك',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('نسبة هالك مرتفعة (>15%)', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
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
                      DataColumn(label: Text('المكون', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الوحدة', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الاستهلاك', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('التالف', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الهالك %', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: items.map((item) {
                      final bool isHighWaste = item.wasteRatio > 15.0;
                      return DataRow(
                        cells: [
                          DataCell(Text(item.ingredientName, style: const TextStyle(fontWeight: FontWeight.w600))),
                          DataCell(Text(item.unit)),
                          DataCell(Text(item.standardUsage.toStringAsFixed(2))),
                          DataCell(
                            Text(
                              item.wasteUsage.toStringAsFixed(2),
                              style: TextStyle(
                                color: item.wasteUsage > 0 ? Colors.red.shade700 : null,
                                fontWeight: item.wasteUsage > 0 ? FontWeight.w600 : null,
                              ),
                            ),
                          ),
                          DataCell(Text(item.totalConsumed.toStringAsFixed(2))),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: LinearProgressIndicator(
                                    value: item.wasteRatio / 100,
                                    backgroundColor: Colors.grey.shade200,
                                    color: isHighWaste ? Colors.red : Colors.orange,
                                    minHeight: 6,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${item.wasteRatio.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isHighWaste ? Colors.red.shade900 : Colors.orange.shade900,
                                  ),
                                ),
                              ],
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
