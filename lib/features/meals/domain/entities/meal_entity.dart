import 'package:equatable/equatable.dart';

/// Pure domain entity for a Meal (menu item / final product).
class MealEntity extends Equatable {
  final int id;
  final String name;
  final double sellingPrice;
  final String category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MealEntity({
    required this.id,
    required this.name,
    required this.sellingPrice,
    required this.category,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, name, sellingPrice, category, isActive, createdAt, updatedAt];
}
