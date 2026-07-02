/// Base use case contract for Clean Architecture.
///
/// Every use case implements this interface with a specific [Type] (return)
/// and [Params] (input).
library;

/// Base use case — all domain use cases implement this.
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use when a use case requires no parameters.
class NoParams {
  const NoParams();
}
