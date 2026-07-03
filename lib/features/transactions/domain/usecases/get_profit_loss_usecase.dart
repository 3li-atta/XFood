import '../../../../core/usecases/usecase.dart';
import '../entities/profit_loss_report_entity.dart';
import '../repositories/transaction_repository.dart';

/// Params for getting Profit & Loss Report.
class GetProfitLossParams {
  final DateTime start;
  final DateTime end;

  const GetProfitLossParams({
    required this.start,
    required this.end,
  });
}

/// Retrieves the Profit & Loss Report.
class GetProfitLossUseCase implements UseCase<ProfitLossReportEntity, GetProfitLossParams> {
  final TransactionRepository _repository;

  GetProfitLossUseCase(this._repository);

  @override
  Future<ProfitLossReportEntity> call(GetProfitLossParams params) {
    return _repository.getProfitLossReport(params.start, params.end);
  }
}
