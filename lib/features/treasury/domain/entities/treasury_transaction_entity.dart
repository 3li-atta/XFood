import 'package:equatable/equatable.dart';

class TreasuryTransactionEntity extends Equatable {
  final int id;
  final int? shiftId;
  final int userId;
  final String type; // 'sale_income', 'purchase_expense', 'cash_in', 'cash_out', 'shift_open', 'shift_close'
  final double amount;
  final String? referenceType; // 'transaction', 'purchase_invoice', 'manual'
  final int? referenceId;
  final String? description;
  final double balanceAfter;
  final DateTime createdAt;

  const TreasuryTransactionEntity({
    required this.id,
    this.shiftId,
    required this.userId,
    required this.type,
    required this.amount,
    this.referenceType,
    this.referenceId,
    this.description,
    required this.balanceAfter,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        shiftId,
        userId,
        type,
        amount,
        referenceType,
        referenceId,
        description,
        balanceAfter,
        createdAt,
      ];
}
