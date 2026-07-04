part of 'pos_bloc.dart';

/// Events for the POS Bloc.
abstract class PosEvent extends Equatable {
  const PosEvent();

  @override
  List<Object?> get props => [];
}

/// Add a meal to the cart.
class AddToCart extends PosEvent {
  final MealEntity meal;
  const AddToCart(this.meal);

  @override
  List<Object?> get props => [meal];
}

/// Remove a meal from the cart by meal id.
class RemoveFromCart extends PosEvent {
  final int mealId;
  const RemoveFromCart(this.mealId);

  @override
  List<Object?> get props => [mealId];
}

/// Update the quantity of an item in the cart.
class UpdateCartItemQuantity extends PosEvent {
  final int mealId;
  final double newQuantity;

  const UpdateCartItemQuantity({
    required this.mealId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [mealId, newQuantity];
}

/// Clear all items from the cart.
class ClearCart extends PosEvent {
  const ClearCart();
}

/// Complete the sale — triggers stock deduction.
class CompleteSale extends PosEvent {
  final int userId;
  final String? notes;
  final double discountPercentage;

  const CompleteSale({required this.userId, this.notes, this.discountPercentage = 0.0});

  @override
  List<Object?> get props => [userId, notes, discountPercentage];
}
