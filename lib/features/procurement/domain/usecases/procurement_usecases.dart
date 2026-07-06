import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/session_manager.dart';
import '../../../../core/error/exceptions.dart';
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
    if (!SessionManager.instance.hasPermission('manage_purchases')) {
      throw const UnauthorizedException('Permission denied: manage_purchases');
    }
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
    if (!SessionManager.instance.hasPermission('manage_purchases')) {
      throw const UnauthorizedException('Permission denied: manage_purchases');
    }
    return _repository.getAllInvoices();
  }
}

class VoidPurchaseParams {
  final int invoiceId;
  final String reason;

  const VoidPurchaseParams({required this.invoiceId, required this.reason});
}

class VoidPurchaseInvoiceUseCase implements UseCase<bool, VoidPurchaseParams> {
  final PurchaseRepository _repository;

  VoidPurchaseInvoiceUseCase(this._repository);

  @override
  Future<bool> call(VoidPurchaseParams params) {
    if (!SessionManager.instance.hasPermission('manage_purchases')) {
      throw const UnauthorizedException('Permission denied: manage_purchases');
    }
    return _repository.voidPurchaseInvoice(params.invoiceId, params.reason);
  }
}
