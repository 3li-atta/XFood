import '../../../../core/usecases/usecase.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

/// Params for creating a sale.
class CreateSaleParams {
  final int userId;
  final int? shiftId;
  final double totalAmount;
  final String? notes;
  final List<SaleInput> items;
  final double discountPercentage;

  const CreateSaleParams({
    required this.userId,
    this.shiftId,
    required this.totalAmount,
    this.notes,
    required this.items,
    this.discountPercentage = 0.0,
  });
}

/// Creates a sale transaction with automatic stock deduction.
class CreateSaleUseCase implements UseCase<int, CreateSaleParams> {
  final TransactionRepository _repository;

  CreateSaleUseCase(this._repository);

  @override
  Future<int> call(CreateSaleParams params) {
    return _repository.createSale(
      userId: params.userId,
      shiftId: params.shiftId,
      totalAmount: params.totalAmount,
      notes: params.notes,
      items: params.items,
      discountPercentage: params.discountPercentage,
    );
  }
}

/// Gets all transactions.
class GetTransactionsUseCase
    implements UseCase<List<TransactionEntity>, NoParams> {
  final TransactionRepository _repository;

  GetTransactionsUseCase(this._repository);

  @override
  Future<List<TransactionEntity>> call(NoParams params) {
    return _repository.getAllTransactions();
  }
}
