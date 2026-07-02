import '../../../../core/usecases/usecase.dart';
import '../entities/treasury_transaction_entity.dart';
import '../repositories/treasury_repository.dart';

class GetCurrentBalanceUseCase implements UseCase<double, NoParams> {
  final TreasuryRepository _repository;

  GetCurrentBalanceUseCase(this._repository);

  @override
  Future<double> call(NoParams params) {
    return _repository.getCurrentBalance();
  }
}

class GetAllTreasuryTransactionsUseCase implements UseCase<List<TreasuryTransactionEntity>, NoParams> {
  final TreasuryRepository _repository;

  GetAllTreasuryTransactionsUseCase(this._repository);

  @override
  Future<List<TreasuryTransactionEntity>> call(NoParams params) {
    return _repository.getAllTransactions();
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
    return _repository.addManualAdjustment(
      userId: params.userId,
      shiftId: params.shiftId,
      type: params.type,
      amount: params.amount,
      description: params.description,
    );
  }
}
