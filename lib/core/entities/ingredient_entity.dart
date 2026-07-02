import 'package:equatable/equatable.dart';

/// Pure domain entity for an Ingredient (raw material).
class IngredientEntity extends Equatable {
  final int id;
  final String name;
  final String unitOfMeasurement;
  final double currentStock;
  final double costPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  const IngredientEntity({
    required this.id,
    required this.name,
    required this.unitOfMeasurement,
    required this.currentStock,
    required this.costPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Total value of current stock.
  double get stockValue => currentStock * costPrice;

  /// Whether stock is critically low (below 10 units).
  bool get isLowStock => currentStock <= 10;

  @override
  List<Object?> get props => [
        id,
        name,
        unitOfMeasurement,
        currentStock,
        costPrice,
        createdAt,
        updatedAt,
      ];
}
