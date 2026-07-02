import '../../../../core/usecases/usecase.dart';
import '../entities/purchase_invoice_entity.dart';
import '../repositories/purchase_repository.dart';

class CreatePurchaseParams {
  final int userId;
  final int? shiftId;
  final String? supplierName;
  final String? notes;
  final List<PurchaseItemInputEntity> items;

  const CreatePurchaseParams({
    required this.userId,
    this.shiftId,
    this.supplierName,
    this.notes,
    required this.items,
  });
}

class CreatePurchaseInvoiceUseCase implements UseCase<int, CreatePurchaseParams> {
  final PurchaseRepository _repository;

  CreatePurchaseInvoiceUseCase(this._repository);

  @override
  Future<int> call(CreatePurchaseParams params) {
    return _repository.createPurchaseInvoice(
      userId: params.userId,
      shiftId: params.shiftId,
      supplierName: params.supplierName,
      notes: params.notes,
      items: params.items,
    );
  }
}

class GetAllPurchaseInvoicesUseCase implements UseCase<List<PurchaseInvoiceEntity>, NoParams> {
  final PurchaseRepository _repository;

  GetAllPurchaseInvoicesUseCase(this._repository);

  @override
  Future<List<PurchaseInvoiceEntity>> call(NoParams params) {
    return _repository.getAllInvoices();
  }
}

class VoidPurchaseInvoiceUseCase implements UseCase<bool, int> {
  final PurchaseRepository _repository;

  VoidPurchaseInvoiceUseCase(this._repository);

  @override
  Future<bool> call(int invoiceId) {
    return _repository.voidPurchaseInvoice(invoiceId);
  }
}
