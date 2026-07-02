part of 'treasury_bloc.dart';

abstract class TreasuryEvent extends Equatable {
  const TreasuryEvent();

  @override
  List<Object?> get props => [];
}

class LoadTreasury extends TreasuryEvent {
  const LoadTreasury();
}

class AddManualAdjustmentRequested extends TreasuryEvent {
  final int userId;
  final int? shiftId;
  final String type; // 'cash_in' or 'cash_out'
  final double amount;
  final String? description;

  const AddManualAdjustmentRequested({
    required this.userId,
    this.shiftId,
    required this.type,
    required this.amount,
    this.description,
  });

  @override
  List<Object?> get props => [userId, shiftId, type, amount, description];
}
