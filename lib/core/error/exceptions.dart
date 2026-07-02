/// Custom exception classes for the application.
library;

/// Thrown when authentication fails (wrong username/password).
class AuthenticationException implements Exception {
  final String message;
  const AuthenticationException([this.message = 'Authentication failed']);

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Thrown when a user tries to perform an action without permission.
class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = 'Unauthorized']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Thrown when a sale would cause ingredient stock to go negative.
class InsufficientStockException implements Exception {
  final String ingredientName;
  final double required;
  final double available;

  const InsufficientStockException({
    required this.ingredientName,
    required this.required,
    required this.available,
  });

  @override
  String toString() =>
      'InsufficientStockException: Need $required of "$ingredientName", '
      'but only $available available.';
}

/// Thrown when a database operation fails.
class DatabaseException implements Exception {
  final String message;
  final Object? originalError;

  const DatabaseException(this.message, [this.originalError]);

  @override
  String toString() => 'DatabaseException: $message';
}

/// Thrown when a requested entity is not found.
class NotFoundException implements Exception {
  final String entityName;
  final dynamic id;

  const NotFoundException(this.entityName, [this.id]);

  @override
  String toString() => 'NotFoundException: $entityName${id != null ? ' with id $id' : ''} not found.';
}

/// Thrown when input validation fails.
class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

/// Thrown when a cashier attempts a sale without an active open shift.
class NoActiveShiftException implements Exception {
  final String message;
  const NoActiveShiftException([this.message = 'No active shift. يجب فتح وردية أولاً']);

  @override
  String toString() => 'NoActiveShiftException: $message';
}
