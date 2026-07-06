import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/peak_hour_item.dart';

class PeakHoursTab extends StatelessWidget {
  final List<PeakHourItem> items;

  const PeakHoursTab({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxRevenue = items.isEmpty
        ? 1.0
        : items.map((i) => i.totalRevenue).reduce(max);
    
    // Sort by hour to display sequentially
    final sortedItems = List<PeakHourItem>.from(items)
      ..sort((a, b) => a.hourOfDay.compareTo(b.hourOfDay));

    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'لا توجد عمليات بيع مسجلة لتحليل ساعات الذروة.',
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
            'تحليل ساعات الذروة وكثافة الإيرادات اليومية',
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
              padding: const EdgeInsets.all(16.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: sortedItems.map((item) {
                    final double ratio = maxRevenue > 0 ? (item.totalRevenue / maxRevenue) : 0.0;
                    final hourStr = '${item.hourOfDay.toString().padLeft(2, '0')}:00';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text(
                              hourStr,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: ratio,
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: 24,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.orange.shade300, Colors.orange.shade600],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${item.transactionCount} طلب',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: ratio > 0.4 ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        '${item.totalRevenue.toStringAsFixed(2)} ج.م',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: ratio > 0.4 ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
