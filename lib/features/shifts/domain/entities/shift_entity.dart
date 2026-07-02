import 'package:equatable/equatable.dart';

class ShiftEntity extends Equatable {
  final int id;
  final int cashierId;
  final String cashierName;
  final String status; // 'open', 'closed'
  final double startingCash;
  final double? expectedClosingCash;
  final double? actualClosingCash;
  final double? variance;
  final double totalSales;
  final double totalPurchases;
  final double totalCashIn;
  final double totalCashOut;
  final DateTime openedAt;
  final DateTime? closedAt;
  final String? notes;

  const ShiftEntity({
    required this.id,
    required this.cashierId,
    required this.cashierName,
    required this.status,
    required this.startingCash,
    this.expectedClosingCash,
    this.actualClosingCash,
    this.variance,
    required this.totalSales,
    required this.totalPurchases,
    required this.totalCashIn,
    required this.totalCashOut,
    required this.openedAt,
    this.closedAt,
    this.notes,
  });

  bool get isOpen => status == 'open';

  @override
  List<Object?> get props => [
        id,
        cashierId,
        cashierName,
        status,
        startingCash,
        expectedClosingCash,
        actualClosingCash,
        variance,
        totalSales,
        totalPurchases,
        totalCashIn,
        totalCashOut,
        openedAt,
        closedAt,
        notes,
      ];
}
