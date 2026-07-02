part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadIngredients extends InventoryEvent {
  const LoadIngredients();
}

class AddIngredientRequested extends InventoryEvent {
  final String name;
  final String unitOfMeasurement;
  final double currentStock;
  final double costPrice;

  const AddIngredientRequested({
    required this.name,
    required this.unitOfMeasurement,
    required this.currentStock,
    required this.costPrice,
  });

  @override
  List<Object?> get props => [name, unitOfMeasurement, currentStock, costPrice];
}

class UpdateIngredientRequested extends InventoryEvent {
  final int id;
  final String name;
  final String unitOfMeasurement;
  final double costPrice;

  const UpdateIngredientRequested({
    required this.id,
    required this.name,
    required this.unitOfMeasurement,
    required this.costPrice,
  });

  @override
  List<Object?> get props => [id, name, unitOfMeasurement, costPrice];
}

class UpdateStockRequested extends InventoryEvent {
  final int id;
  final double currentStock;

  const UpdateStockRequested({
    required this.id,
    required this.currentStock,
  });

  @override
  List<Object?> get props => [id, currentStock];
}

class DeleteIngredientRequested extends InventoryEvent {
  final int id;

  const DeleteIngredientRequested(this.id);

  @override
  List<Object?> get props => [id];
}
