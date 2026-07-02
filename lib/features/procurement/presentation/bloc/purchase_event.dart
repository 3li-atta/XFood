part of 'purchase_bloc.dart';

abstract class PurchaseEvent extends Equatable {
  const PurchaseEvent();

  @override
  List<Object?> get props => [];
}

class LoadPurchases extends PurchaseEvent {
  const LoadPurchases();
}

class CreatePurchaseInvoiceRequested extends PurchaseEvent {
  final int userId;
  final int? shiftId;
  final String? supplierName;
  final String? notes;
  final List<PurchaseItemInputEntity> items;

  const CreatePurchaseInvoiceRequested({
    required this.userId,
    this.shiftId,
    this.supplierName,
    this.notes,
    required this.items,
  });

  @override
  List<Object?> get props => [userId, shiftId, supplierName, notes, items];
}

class VoidPurchaseInvoiceRequested extends PurchaseEvent {
  final int invoiceId;

  const VoidPurchaseInvoiceRequested(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}
