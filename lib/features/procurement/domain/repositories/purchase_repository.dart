import '../entities/purchase_invoice_entity.dart';
import '../entities/purchase_item_entity.dart';

abstract class PurchaseRepository {
  Future<int> createPurchaseInvoice({
    required int userId,
    required int? shiftId,
    required String? supplierName,
    required String? notes,
    required List<PurchaseItemInputEntity> items,
  });

  Future<List<PurchaseInvoiceEntity>> getAllInvoices();

  Future<List<PurchaseItemEntity>> getItemsForInvoice(int invoiceId);

  Future<bool> voidPurchaseInvoice(int invoiceId);
}

class PurchaseItemInputEntity {
  final int ingredientId;
  final double quantity;
  final double unitCost;

  const PurchaseItemInputEntity({
    required this.ingredientId,
    required this.quantity,
    required this.unitCost,
  });
}
