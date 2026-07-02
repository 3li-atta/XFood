part of 'shift_bloc.dart';

enum ShiftStatus { initial, loading, active, closed, noActive, error }

class ShiftState extends Equatable {
  final ShiftStatus status;
  final ShiftEntity? activeShift;
  final List<ShiftEntity> history;
  final String? errorMessage;
  final int? closedShiftId;

  const ShiftState({
    this.status = ShiftStatus.initial,
    this.activeShift,
    this.history = const [],
    this.errorMessage,
    this.closedShiftId,
  });

  ShiftState copyWith({
    ShiftStatus? status,
    ShiftEntity? activeShift,
    bool clearActiveShift = false,
    List<ShiftEntity>? history,
    String? errorMessage,
    int? closedShiftId,
  }) {
    return ShiftState(
      status: status ?? this.status,
      activeShift: clearActiveShift ? null : (activeShift ?? this.activeShift),
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
      closedShiftId: closedShiftId ?? this.closedShiftId,
    );
  }

  @override
  List<Object?> get props => [status, activeShift, history, errorMessage, closedShiftId];
}
