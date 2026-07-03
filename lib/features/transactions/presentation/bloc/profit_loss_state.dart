import 'package:equatable/equatable.dart';
import '../../domain/entities/profit_loss_report_entity.dart';

abstract class ProfitLossState extends Equatable {
  const ProfitLossState();

  @override
  List<Object?> get props => [];
}

class ProfitLossInitial extends ProfitLossState {}

class ProfitLossLoading extends ProfitLossState {}

class ProfitLossLoaded extends ProfitLossState {
  final ProfitLossReportEntity report;
  final DateTime startDate;
  final DateTime endDate;

  const ProfitLossLoaded({
    required this.report,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [report, startDate, endDate];
}

class ProfitLossError extends ProfitLossState {
  final String errorMessage;

  const ProfitLossError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
