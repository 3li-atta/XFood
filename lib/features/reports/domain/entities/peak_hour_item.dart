import 'package:equatable/equatable.dart';

/// Entity for a single hour slot in the Peak Hours Analysis Report.
class PeakHourItem extends Equatable {
  final int hourOfDay; // 0-23
  final int transactionCount;
  final double totalRevenue;

  const PeakHourItem({
    required this.hourOfDay,
    required this.transactionCount,
    required this.totalRevenue,
  });

  @override
  List<Object?> get props => [hourOfDay, transactionCount, totalRevenue];
}
