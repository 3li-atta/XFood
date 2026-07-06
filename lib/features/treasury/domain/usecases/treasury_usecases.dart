import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/session_manager.dart';
import '../../../../core/error/exceptions.dart';
import '../entities/treasury_transaction_entity.dart';
import '../repositories/treasury_repository.dart';

class GetCurrentBalanceUseCase implements UseCase<double, NoParams> {
  final TreasuryRepository _repository;

  GetCurrentBalanceUseCase(this._repository);

  @override
  Future<double> call(NoParams params) {
    if (!SessionManager.instance.hasPermission('manage_treasury')) {
      throw const UnauthorizedException('Permission denied: manage_treasury');
    }
    return _repository.getCurrentBalance();
  }
}

class GetAllTreasuryTransactionsUseCase implements UseCase<List<TreasuryTransactionEntity>, NoParams> {
  final TreasuryRepository _repository;

  GetAllTreasuryTransactionsUseCase(this._repository);

  @override
  Future<List<TreasuryTransactionEntity>> call(NoParams params) {
    if (!SessionManager.instance.hasPermission('manage_treasury')) {
      throw const UnauthorizedException('Permission denied: manage_treasury');
    }
    return _repository.getAllTransactions();
  }
}

class TreasuryPaginationParams {
  final int limit;
  final int offset;

  const TreasuryPaginationParams({required this.limit, required this.offset});
}

class GetTreasuryTransactionsPaginatedUseCase implements UseCase<List<TreasuryTransactionEntity>, TreasuryPaginationParams> {
  final TreasuryRepository _repository;

  GetTreasuryTransactionsPaginatedUseCase(this._repository);

  @override
  Future<List<TreasuryTransactionEntity>> call(TreasuryPaginationParams params) {
    if (!SessionManager.instance.hasPermission('manage_treasury')) {
      throw const UnauthorizedException('Permission denied: manage_treasury');
    }
    return _repository.getTransactionsPaginated(params.limit, params.offset);
  }
}

class ManualAdjustmentParams {
  final int userId;
  final int? shiftId;
  final String type; // 'cash_in' or 'cash_out'
  final double amount;
  final String? description;

  const ManualAdjustmentParams({
    required this.userId,
    this.shiftId,
    required this.type,
    required this.amount,
    this.description,
  });
}

class AddManualAdjustmentUseCase implements UseCase<int, ManualAdjustmentParams> {
  final TreasuryRepository _repository;

  AddManualAdjustmentUseCase(this._repository);

  @override
  Future<int> call(ManualAdjustmentParams params) {
    if (!SessionManager.instance.hasPermission('manage_treasury')) {
      throw const UnauthorizedException('Permission denied: manage_treasury');
    }
    return _repository.addManualAdjustment(
      userId: params.userId,
      shiftId: params.shiftId,
      type: params.type,
      amount: params.amount,
      description: params.description,
    );
  }
}
