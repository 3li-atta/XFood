import 'package:equatable/equatable.dart';

abstract class ProfitLossEvent extends Equatable {
  const ProfitLossEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfitLossReport extends ProfitLossEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadProfitLossReport({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
