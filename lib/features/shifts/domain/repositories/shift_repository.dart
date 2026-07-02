import '../entities/shift_entity.dart';

abstract class ShiftRepository {
  Future<ShiftEntity?> getActiveShift(int cashierId);
  Stream<ShiftEntity?> watchActiveShift(int cashierId);
  Future<int> openShift({
    required int cashierId,
    required double startingCash,
  });
  Future<void> closeShift({
    required int shiftId,
    required double actualClosingCash,
    required String? notes,
  });
  Future<List<ShiftEntity>> getShiftHistory();
  Future<ShiftEntity> getShiftById(int shiftId);
}
