import '../../domain/entities/purchase_invoice_entity.dart';
import '../../domain/entities/purchase_item_entity.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/purchase_dao.dart';
import '../../../../database/daos/ingredient_dao.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseDao _purchaseDao;
  final IngredientDao _ingredientDao;

  PurchaseRepositoryImpl(this._purchaseDao, this._ingredientDao);

  @override
  Future<int> createPurchaseInvoice({
    required int userId,
    required int? shiftId,
    required String? supplierName,
    required String? notes,
    required List<PurchaseItemInputEntity> items,
  }) {
    return _purchaseDao.createPurchaseInvoice(
      userId: userId,
      shiftId: shiftId,
      supplierName: supplierName,
      notes: notes,
      items: items
          .map((i) => PurchaseItemInput(
                ingredientId: i.ingredientId,
                quantity: i.quantity,
                unitCost: i.unitCost,
              ))
          .toList(),
    );
  }

  @override
  Future<List<PurchaseInvoiceEntity>> getAllInvoices() async {
    final rows = await _purchaseDao.getAllInvoices();
    return rows.map(_mapInvoiceToEntity).toList();
  }

  @override
  Future<List<PurchaseItemEntity>> getItemsForInvoice(int invoiceId) async {
    final rows = await _purchaseDao.getItemsForInvoice(invoiceId);
    final List<PurchaseItemEntity> entities = [];
    for (final row in rows) {
      String name = 'Unknown Ingredient';
      try {
        final ingredient = await _ingredientDao.getById(row.ingredientId);
        name = ingredient.name;
      } catch (_) {}
      entities.add(PurchaseItemEntity(
        id: row.id,
        purchaseInvoiceId: row.purchaseInvoiceId,
        ingredientId: row.ingredientId,
        ingredientName: name,
        quantity: row.quantity,
        unitCost: row.unitCost,
        lineTotal: row.lineTotal,
      ));
    }
    return entities;
  }

  @override
  Future<bool> voidPurchaseInvoice(int invoiceId, String reason) {
    return _purchaseDao.voidPurchaseInvoice(
      invoiceId: invoiceId,
      reason: reason,
    );
  }

  PurchaseInvoiceEntity _mapInvoiceToEntity(PurchaseInvoice row) {
    return PurchaseInvoiceEntity(
      id: row.id,
      invoiceNumber: row.invoiceNumber,
      supplierName: row.supplierName,
      userId: row.userId,
      shiftId: row.shiftId,
      totalAmount: row.totalAmount,
      notes: row.notes,
      status: row.status,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
