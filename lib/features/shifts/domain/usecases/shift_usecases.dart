import '../../../../core/usecases/usecase.dart';
import '../entities/shift_entity.dart';
import '../repositories/shift_repository.dart';

class OpenShiftParams {
  final int cashierId;
  final double startingCash;

  const OpenShiftParams({
    required this.cashierId,
    required this.startingCash,
  });
}

class OpenShiftUseCase implements UseCase<int, OpenShiftParams> {
  final ShiftRepository _repository;

  OpenShiftUseCase(this._repository);

  @override
  Future<int> call(OpenShiftParams params) {
    return _repository.openShift(
      cashierId: params.cashierId,
      startingCash: params.startingCash,
    );
  }
}

class CloseShiftParams {
  final int shiftId;
  final double actualClosingCash;
  final String? notes;

  const CloseShiftParams({
    required this.shiftId,
    required this.actualClosingCash,
    this.notes,
  });
}

class CloseShiftUseCase implements UseCase<void, CloseShiftParams> {
  final ShiftRepository _repository;

  CloseShiftUseCase(this._repository);

  @override
  Future<void> call(CloseShiftParams params) {
    return _repository.closeShift(
      shiftId: params.shiftId,
      actualClosingCash: params.actualClosingCash,
      notes: params.notes,
    );
  }
}

class GetActiveShiftUseCase implements UseCase<ShiftEntity?, int> {
  final ShiftRepository _repository;

  GetActiveShiftUseCase(this._repository);

  @override
  Future<ShiftEntity?> call(int cashierId) {
    return _repository.getActiveShift(cashierId);
  }
}

class GetShiftHistoryUseCase implements UseCase<List<ShiftEntity>, NoParams> {
  final ShiftRepository _repository;

  GetShiftHistoryUseCase(this._repository);

  @override
  Future<List<ShiftEntity>> call(NoParams params) {
    return _repository.getShiftHistory();
  }
}
