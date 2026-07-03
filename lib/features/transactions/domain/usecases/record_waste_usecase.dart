import '../../../../core/usecases/usecase.dart';
import '../repositories/transaction_repository.dart';

/// Params for recording waste.
class RecordWasteParams {
  final int userId;
  final String? notes;
  final List<WasteInput> items;

  const RecordWasteParams({
    required this.userId,
    this.notes,
    required this.items,
  });
}

/// Records a waste transaction and deducts ingredient stock.
class RecordWasteUseCase implements UseCase<int, RecordWasteParams> {
  final TransactionRepository _repository;

  RecordWasteUseCase(this._repository);

  @override
  Future<int> call(RecordWasteParams params) {
    return _repository.recordWaste(
      userId: params.userId,
      notes: params.notes,
      items: params.items,
    );
  }
}
