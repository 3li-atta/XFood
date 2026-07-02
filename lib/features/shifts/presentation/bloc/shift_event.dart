part of 'shift_bloc.dart';

abstract class ShiftEvent extends Equatable {
  const ShiftEvent();

  @override
  List<Object?> get props => [];
}

class CheckActiveShift extends ShiftEvent {
  final int cashierId;

  const CheckActiveShift(this.cashierId);

  @override
  List<Object?> get props => [cashierId];
}

class OpenShiftRequested extends ShiftEvent {
  final int cashierId;
  final double startingCash;

  const OpenShiftRequested({
    required this.cashierId,
    required this.startingCash,
  });

  @override
  List<Object?> get props => [cashierId, startingCash];
}

class CloseShiftRequested extends ShiftEvent {
  final int shiftId;
  final double actualClosingCash;
  final String? notes;

  const CloseShiftRequested({
    required this.shiftId,
    required this.actualClosingCash,
    this.notes,
  });

  @override
  List<Object?> get props => [shiftId, actualClosingCash, notes];
}

class LoadShiftHistory extends ShiftEvent {
  const LoadShiftHistory();
}
