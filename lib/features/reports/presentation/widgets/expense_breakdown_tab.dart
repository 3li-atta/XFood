import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../domain/entities/expense_breakdown_item.dart';
import '../../../../database/app_database.dart';

/// Displays both operating expenses breakdown and detailed log with filters.
class ExpenseBreakdownTab extends StatefulWidget {
  final List<ExpenseBreakdownItem> items;
  final List<Expense> detailedExpenses;

  const ExpenseBreakdownTab({
    super.key,
    required this.items,
    required this.detailedExpenses,
  });

  @override
  State<ExpenseBreakdownTab> createState() => _ExpenseBreakdownTabState();
}

class _ExpenseBreakdownTabState extends State<ExpenseBreakdownTab> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double grandTotal = widget.items.fold(0.0, (sum, item) => sum + item.categoryTotal);
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm');

    // Extract unique categories for filter
    final uniqueCategories = widget.detailedExpenses.map((e) => e.category).toSet().toList();

    // Filter detailed expenses list
    final filteredExpenses = _selectedCategory == null
        ? widget.detailedExpenses
        : widget.detailedExpenses.where((e) => e.category == _selectedCategory).toList();

    if (widget.items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'لا توجد مصروفات مسجلة في هذه الفترة.',
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تحليل وتوزيع المصروفات التشغيلية حسب البند',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Text(
                  'إجمالي المصروفات: ${grandTotal.toStringAsFixed(2)} ج.م',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Category Breakdown Table
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
                    columnSpacing: 12,
                    columns: const [
                      DataColumn(label: Text('بند المصروف', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('القيود', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('المبلغ', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('النسبة %', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: widget.items.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item.category, style: const TextStyle(fontWeight: FontWeight.w600))),
                          DataCell(Text(item.entryCount.toString())),
                          DataCell(Text('${item.categoryTotal.toStringAsFixed(2)} ج.م')),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: LinearProgressIndicator(
                                    value: item.percentage / 100,
                                    backgroundColor: Colors.grey.shade200,
                                    color: Colors.purple,
                                    minHeight: 6,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${item.percentage.toStringAsFixed(1)}%',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
          
          const SizedBox(height: 24),
          
          // Section Header: Detailed log & Filter Dropdown
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'سجل المصروفات التفصيلي',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
                // Dropdown category selector
                Container(
                  width: 200,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _selectedCategory,
                      isExpanded: true,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      hint: const Text('تصفية حسب البند'),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('الكل (جميع البنود)'),
                        ),
                        ...uniqueCategories.map((cat) => DropdownMenuItem<String?>(
                          value: cat,
                          child: Text(cat),
                        )),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Detailed Expenses Table
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 14,
                      columns: const [
                        DataColumn(label: Text('التاريخ', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('البند', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('المبلغ', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('الملاحظات', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: filteredExpenses.map((exp) {
                        return DataRow(
                          cells: [
                            DataCell(Text(dateFormatter.format(exp.date))),
                            DataCell(Text(exp.category, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text('${exp.amount.toStringAsFixed(2)} ج.م', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple))),
                            DataCell(Text(exp.note ?? '-')),
                          ],
                        );
                      }).toList(),
                    ),
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
