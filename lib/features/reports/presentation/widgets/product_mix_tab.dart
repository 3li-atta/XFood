import 'package:flutter/material.dart';
import '../../domain/entities/product_mix_item.dart';

class ProductMixTab extends StatefulWidget {
  final List<ProductMixItem> items;

  const ProductMixTab({super.key, required this.items});

  @override
  State<ProductMixTab> createState() => _ProductMixTabState();
}

class _ProductMixTabState extends State<ProductMixTab> {
  bool _sortByRevenue = true; // True for revenue, false for quantity
  late List<ProductMixItem> _sortedItems;

  @override
  void initState() {
    super.initState();
    _sortItems();
  }

  @override
  void didUpdateWidget(ProductMixTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _sortItems();
    }
  }

  void _sortItems() {
    _sortedItems = List.from(widget.items);
    if (_sortByRevenue) {
      _sortedItems.sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));
    } else {
      _sortedItems.sort((a, b) => b.totalQuantity.compareTo(a.totalQuantity));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_sortedItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'لا توجد بيانات مبيعات متوفرة لهذه الفترة.',
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
                'تقرير مزيج المنتجات وحجم المبيعات',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              ToggleButtons(
                isSelected: [_sortByRevenue, !_sortByRevenue],
                onPressed: (index) {
                  setState(() {
                    _sortByRevenue = index == 0;
                    _sortItems();
                  });
                },
                borderRadius: BorderRadius.circular(12),
                constraints: const BoxConstraints(minHeight: 36, minWidth: 100),
                selectedColor: Colors.white,
                fillColor: const Color(0xFF1E3A8A),
                children: const [
                  Text('الأعلى إيراداً', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('الأكثر مبيعاً', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                    columnSpacing: 12,
                    columns: const [
                      DataColumn(label: Text('الوجبة', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الفئة', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الكمية', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الإيرادات', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('النسبة', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: _sortedItems.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item.mealName, style: const TextStyle(fontWeight: FontWeight.w600))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _translateCategory(item.category),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(item.totalQuantity.toStringAsFixed(0))),
                          DataCell(Text('${item.totalRevenue.toStringAsFixed(2)} ج.م')),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: LinearProgressIndicator(
                                    value: item.revenuePercentage / 100,
                                    backgroundColor: Colors.grey.shade200,
                                    color: const Color(0xFF10B981),
                                    minHeight: 6,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${item.revenuePercentage.toStringAsFixed(1)}%',
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
        ],
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
