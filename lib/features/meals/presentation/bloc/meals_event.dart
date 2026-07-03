part of 'meals_bloc.dart';

abstract class MealsEvent extends Equatable {
  const MealsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMeals extends MealsEvent {
  const LoadMeals();
}

class CreateMealRequested extends MealsEvent {
  final String name;
  final double sellingPrice;
  final String category;

  const CreateMealRequested({
    required this.name,
    required this.sellingPrice,
    required this.category,
  });

  @override
  List<Object?> get props => [name, sellingPrice, category];
}

class UpdateMealRequested extends MealsEvent {
  final int id;
  final String name;
  final double sellingPrice;
  final String category;

  const UpdateMealRequested({
    required this.id,
    required this.name,
    required this.sellingPrice,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, sellingPrice, category];
}

class DeactivateMealRequested extends MealsEvent {
  final int id;

  const DeactivateMealRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleMealActiveRequested extends MealsEvent {
  final int id;
  final bool isActive;

  const ToggleMealActiveRequested(this.id, this.isActive);

  @override
  List<Object?> get props => [id, isActive];
}
