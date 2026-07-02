import 'package:equatable/equatable.dart';

class PurchaseItemEntity extends Equatable {
  final int id;
  final int purchaseInvoiceId;
  final int ingredientId;
  final String ingredientName;
  final double quantity;
  final double unitCost;
  final double lineTotal;

  const PurchaseItemEntity({
    required this.id,
    required this.purchaseInvoiceId,
    required this.ingredientId,
    required this.ingredientName,
    required this.quantity,
    required this.unitCost,
    required this.lineTotal,
  });

  @override
  List<Object?> get props => [
        id,
        purchaseInvoiceId,
        ingredientId,
        ingredientName,
        quantity,
        unitCost,
        lineTotal,
      ];
}
