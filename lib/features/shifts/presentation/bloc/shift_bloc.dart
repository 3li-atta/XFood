import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/usecases/shift_usecases.dart';
import '../../../../core/usecases/usecase.dart';

part 'shift_event.dart';
part 'shift_state.dart';

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  final OpenShiftUseCase _openShiftUseCase;
  final CloseShiftUseCase _closeShiftUseCase;
  final GetActiveShiftUseCase _getActiveShiftUseCase;
  final GetShiftHistoryUseCase _getShiftHistoryUseCase;

  ShiftBloc({
    required OpenShiftUseCase openShiftUseCase,
    required CloseShiftUseCase closeShiftUseCase,
    required GetActiveShiftUseCase getActiveShiftUseCase,
    required GetShiftHistoryUseCase getShiftHistoryUseCase,
  })  : _openShiftUseCase = openShiftUseCase,
        _closeShiftUseCase = closeShiftUseCase,
        _getActiveShiftUseCase = getActiveShiftUseCase,
        _getShiftHistoryUseCase = getShiftHistoryUseCase,
        super(const ShiftState()) {
    on<CheckActiveShift>(_onCheckActiveShift);
    on<OpenShiftRequested>(_onOpenShift);
    on<CloseShiftRequested>(_onCloseShift);
    on<LoadShiftHistory>(_onLoadShiftHistory);
  }

  Future<void> _onCheckActiveShift(CheckActiveShift event, Emitter<ShiftState> emit) async {
    emit(state.copyWith(status: ShiftStatus.loading));
    try {
      final shift = await _getActiveShiftUseCase(event.cashierId);
      if (shift != null) {
        emit(state.copyWith(
          status: ShiftStatus.active,
          activeShift: shift,
        ));
      } else {
        emit(state.copyWith(
          status: ShiftStatus.noActive,
          clearActiveShift: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ShiftStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onOpenShift(OpenShiftRequested event, Emitter<ShiftState> emit) async {
    emit(state.copyWith(status: ShiftStatus.loading));
    try {
      await _openShiftUseCase(OpenShiftParams(
        cashierId: event.cashierId,
        startingCash: event.startingCash,
      ));
      add(CheckActiveShift(event.cashierId));
    } catch (e) {
      emit(state.copyWith(
        status: ShiftStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCloseShift(CloseShiftRequested event, Emitter<ShiftState> emit) async {
    emit(state.copyWith(status: ShiftStatus.loading));
    try {
      await _closeShiftUseCase(CloseShiftParams(
        shiftId: event.shiftId,
        actualClosingCash: event.actualClosingCash,
        notes: event.notes,
      ));
      emit(state.copyWith(
        status: ShiftStatus.closed,
        clearActiveShift: true,
        closedShiftId: event.shiftId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ShiftStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadShiftHistory(LoadShiftHistory event, Emitter<ShiftState> emit) async {
    final initialLoading = state.history.isEmpty;
    if (initialLoading) {
      emit(state.copyWith(status: ShiftStatus.loading));
    }
    try {
      final shifts = await _getShiftHistoryUseCase(const NoParams());
      emit(state.copyWith(
        status: state.activeShift != null ? ShiftStatus.active : ShiftStatus.noActive,
        history: shifts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ShiftStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
