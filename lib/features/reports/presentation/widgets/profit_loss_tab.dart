import 'package:flutter/material.dart';
import '../../../transactions/domain/entities/profit_loss_report_entity.dart';

/// Tab widget displaying a beautiful Profit & Loss Statement (تقرير الأرباح والخسائر).
class ProfitLossTab extends StatelessWidget {
  final ProfitLossReportEntity profitLoss;

  const ProfitLossTab({super.key, required this.profitLoss});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final grossProfit = profitLoss.totalRevenue - profitLoss.totalCOGS - profitLoss.totalWasteCost;
    final isNetProfitPositive = profitLoss.netProfit >= 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // P&L Statement Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'قائمة الأرباح والخسائر',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Row: Revenue
                  _buildPlRow('إجمالي الإيرادات', profitLoss.totalRevenue, Colors.green.shade700, isBold: true),
                  const Divider(height: 24),
                  
                  // Row: COGS
                  _buildPlRow('تكلفة البضاعة المباعة', -profitLoss.totalCOGS, Colors.red.shade700),
                  const SizedBox(height: 12),
                  
                  // Row: Waste Cost
                  _buildPlRow('تكلفة الهالك المباشر', -profitLoss.totalWasteCost, Colors.red.shade700),
                  const Divider(height: 24),
                  
                  // Row: Gross Profit
                  _buildPlRow('مجمل الربح', grossProfit, grossProfit >= 0 ? Colors.green.shade800 : Colors.red.shade800, isBold: true),
                  const Divider(height: 24),
                  
                  // Row: Operating Expenses
                  _buildPlRow('المصروفات التشغيلية', -profitLoss.totalExpenses, Colors.red.shade700),
                  const Divider(height: 32),
                  
                  // Row: Net Profit
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: isNetProfitPositive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isNetProfitPositive ? Colors.green.shade300 : Colors.red.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: _buildPlRow(
                      'صافي الربح / الخسارة',
                      profitLoss.netProfit,
                      isNetProfitPositive ? Colors.green.shade800 : Colors.red.shade800,
                      isBold: true,
                      largeValue: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Expenses Breakdown Card
          if (profitLoss.expensesByCategory.isNotEmpty) ...[
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'المصروفات التشغيلية حسب البند',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...profitLoss.expensesByCategory.entries.map((entry) {
                      final percentage = profitLoss.totalExpenses > 0 ? (entry.value / profitLoss.totalExpenses) * 100 : 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                            Row(
                              children: [
                                Text('${percentage.toStringAsFixed(1)}%', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
                                const SizedBox(width: 12),
                                Text('${entry.value.toStringAsFixed(2)} ج.م', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlRow(String label, double value, Color valueColor, {bool isBold = false, bool largeValue = false}) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: largeValue ? 18 : (isBold ? 14 : 13),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          '${value >= 0 ? "" : "-"}${value.abs().toStringAsFixed(2)} ج.م',
          style: style.copyWith(color: valueColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
