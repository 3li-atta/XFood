import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/session_manager.dart';
import '../../../../core/error/exceptions.dart';
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
  final double taxPercentage;
  final String orderType;
  final String paymentMethod;
  final int? tableId;

  const CreateSaleParams({
    required this.userId,
    this.shiftId,
    required this.totalAmount,
    this.notes,
    required this.items,
    this.discountPercentage = 0.0,
    this.taxPercentage = 0.0,
    this.orderType = 'takeaway',
    this.paymentMethod = 'cash',
    this.tableId,
  });
}

/// Creates a sale transaction with automatic stock deduction.
class CreateSaleUseCase implements UseCase<int, CreateSaleParams> {
  final TransactionRepository _repository;

  CreateSaleUseCase(this._repository);

  @override
  Future<int> call(CreateSaleParams params) {
    if (!SessionManager.instance.hasPermission('make_sales')) {
      throw const UnauthorizedException('Permission denied: make_sales');
    }
    return _repository.createSale(
      userId: params.userId,
      shiftId: params.shiftId,
      totalAmount: params.totalAmount,
      notes: params.notes,
      items: params.items,
      discountPercentage: params.discountPercentage,
      taxPercentage: params.taxPercentage,
      orderType: params.orderType,
      paymentMethod: params.paymentMethod,
      tableId: params.tableId,
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
    if (!SessionManager.instance.hasPermission('view_transactions')) {
      throw const UnauthorizedException('Permission denied: view_transactions');
    }
    return _repository.getAllTransactions();
  }
}
