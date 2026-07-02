import 'package:equatable/equatable.dart';

/// Pure domain entity for a TransactionItem (line item).
class TransactionItemEntity extends Equatable {
  final int id;
  final int transactionId;
  final int? mealId;
  final int? ingredientId;
  final double quantity;
  final double priceAtTime;
  final String itemType; // 'meal' or 'ingredient'

  const TransactionItemEntity({
    required this.id,
    required this.transactionId,
    this.mealId,
    this.ingredientId,
    required this.quantity,
    required this.priceAtTime,
    required this.itemType,
  });

  /// Total value of this line item.
  double get lineTotal => quantity * priceAtTime;

  bool get isMealItem => itemType == 'meal';
  bool get isIngredientItem => itemType == 'ingredient';

  @override
  List<Object?> get props => [
        id, transactionId, mealId, ingredientId,
        quantity, priceAtTime, itemType,
      ];
}
