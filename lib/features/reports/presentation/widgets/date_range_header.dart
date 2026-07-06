import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

/// Header widget displaying the currently selected Date Range for reports,
/// with a button to invoke the date range picker.
class DateRangeHeader extends StatelessWidget {
  final DateTimeRange selectedDateRange;
  final VoidCallback onSelectDateRange;

  const DateRangeHeader({
    super.key,
    required this.selectedDateRange,
    required this.onSelectDateRange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'فترة التقرير النشطة',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dateFormat.format(selectedDateRange.start)}  ➔  ${dateFormat.format(selectedDateRange.end)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            FilledButton.icon(
              onPressed: onSelectDateRange,
              icon: const Icon(Icons.date_range, size: 18),
              label: const Text('تغيير الفترة'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
