/// Failure classes for functional error handling.
///
/// Used with Either<Failure, Success> pattern in use cases.
library;

import 'package:equatable/equatable.dart';

/// Base failure class.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Authentication-related failures.
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Database operation failures.
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Stock/inventory-related failures.
class StockFailure extends Failure {
  final String ingredientName;
  final double required;
  final double available;

  const StockFailure({
    required this.ingredientName,
    required this.required,
    required this.available,
  }) : super('Insufficient stock for "$ingredientName"');

  @override
  List<Object?> get props => [message, ingredientName, required, available];
}

/// Validation failures.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Entity not found failures.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Shift-related failures (V-63).
class ShiftFailure extends Failure {
  const ShiftFailure(super.message);
}

/// Treasury-related failures (V-63).
class TreasuryFailure extends Failure {
  const TreasuryFailure(super.message);
}

/// Purchase-related failures (V-63).
class PurchaseFailure extends Failure {
  const PurchaseFailure(super.message);
}
