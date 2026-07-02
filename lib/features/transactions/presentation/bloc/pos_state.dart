part of 'pos_bloc.dart';

/// Processing status for the POS screen.
enum PosStatus { idle, processing, success, error }

/// State for the POS Bloc — holds the cart and sale status.
class PosState extends Equatable {
  final List<CartItem> cartItems;
  final PosStatus status;
  final String? errorMessage;

  const PosState({
    this.cartItems = const [],
    this.status = PosStatus.idle,
    this.errorMessage,
  });

  /// Total amount for the current cart.
  double get totalAmount =>
      cartItems.fold(0, (sum, item) => sum + item.lineTotal);

  /// Total number of items in cart.
  int get itemCount => cartItems.length;

  /// Whether the cart has items.
  bool get hasItems => cartItems.isNotEmpty;

  PosState copyWith({
    List<CartItem>? cartItems,
    PosStatus? status,
    String? errorMessage,
  }) {
    final nextStatus = status ?? this.status;
    return PosState(
      cartItems: cartItems ?? this.cartItems,
      status: nextStatus,
      errorMessage: errorMessage ?? (nextStatus == PosStatus.error ? this.errorMessage : null),
    );
  }

  @override
  List<Object?> get props => [cartItems, status, errorMessage];
}

/// A single item in the POS cart.
class CartItem extends Equatable {
  final MealEntity meal;
  final double quantity;

  const CartItem({required this.meal, required this.quantity});

  /// Total price for this cart line.
  double get lineTotal => meal.sellingPrice * quantity;

  CartItem copyWith({MealEntity? meal, double? quantity}) {
    return CartItem(
      meal: meal ?? this.meal,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [meal, quantity];
}
