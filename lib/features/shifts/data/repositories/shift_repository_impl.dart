import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/shift_dao.dart';
import '../../../../database/daos/user_dao.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  final ShiftDao _shiftDao;
  final UserDao _userDao;

  ShiftRepositoryImpl(this._shiftDao, this._userDao);

  @override
  Future<ShiftEntity?> getActiveShift(int cashierId) async {
    final row = await _shiftDao.getActiveShift(cashierId);
    if (row != null) {
      return _mapToEntity(row);
    }

    // If no active shift is found for this cashierId, check if they are an admin
    try {
      final users = await _userDao.getAllUsers();
      final user = users.firstWhere((u) => u.id == cashierId);
      if (user.role == 'admin') {
        final anyOpenShift = await _shiftDao.getAnyActiveShift();
        if (anyOpenShift != null) {
          return _mapToEntity(anyOpenShift);
        }
      }
    } catch (_) {}

    return null;
  }

  @override
  Stream<ShiftEntity?> watchActiveShift(int cashierId) {
    return _shiftDao.watchActiveShift(cashierId).asyncMap((row) async {
      if (row == null) return null;
      return _mapToEntity(row);
    });
  }

  @override
  Future<int> openShift({
    required int cashierId,
    required double startingCash,
  }) {
    return _shiftDao.openShift(
      cashierId: cashierId,
      startingCash: startingCash,
    );
  }

  @override
  Future<void> closeShift({
    required int shiftId,
    required double actualClosingCash,
    required String? notes,
  }) {
    return _shiftDao.closeShift(
      shiftId: shiftId,
      actualClosingCash: actualClosingCash,
      notes: notes,
    );
  }

  @override
  Future<List<ShiftEntity>> getShiftHistory() async {
    final rows = await _shiftDao.getShiftHistory();
    final List<ShiftEntity> list = [];
    for (final row in rows) {
      list.add(await _mapToEntity(row));
    }
    return list;
  }

  @override
  Future<ShiftEntity> getShiftById(int shiftId) async {
    final row = await _shiftDao.getById(shiftId);
    return _mapToEntity(row);
  }

  Future<ShiftEntity> _mapToEntity(Shift row) async {
    String cashierName = 'Unknown';
    try {
      final users = await _userDao.getAllUsers();
      final user = users.firstWhere((u) => u.id == row.cashierId);
      cashierName = user.username;
    } catch (_) {}

    return ShiftEntity(
      id: row.id,
      cashierId: row.cashierId,
      cashierName: cashierName,
      status: row.status,
      startingCash: row.startingCash,
      expectedClosingCash: row.expectedClosingCash,
      actualClosingCash: row.actualClosingCash,
      variance: row.variance,
      totalSales: row.totalSales,
      totalPurchases: row.totalPurchases,
      totalCashIn: row.totalCashIn,
      totalCashOut: row.totalCashOut,
      openedAt: row.openedAt,
      closedAt: row.closedAt,
      notes: row.notes,
    );
  }
}
