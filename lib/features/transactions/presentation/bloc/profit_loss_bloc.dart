import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profit_loss_usecase.dart';
import 'profit_loss_event.dart';
import 'profit_loss_state.dart';

class ProfitLossBloc extends Bloc<ProfitLossEvent, ProfitLossState> {
  final GetProfitLossUseCase _getProfitLossUseCase;

  ProfitLossBloc({
    required GetProfitLossUseCase getProfitLossUseCase,
  })  : _getProfitLossUseCase = getProfitLossUseCase,
        super(ProfitLossInitial()) {
    on<LoadProfitLossReport>(_onLoadProfitLossReport);
  }

  Future<void> _onLoadProfitLossReport(
    LoadProfitLossReport event,
    Emitter<ProfitLossState> emit,
  ) async {
    emit(ProfitLossLoading());
    try {
      final report = await _getProfitLossUseCase(
        GetProfitLossParams(
          start: event.startDate,
          end: event.endDate,
        ),
      );
      emit(ProfitLossLoaded(
        report: report,
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    } catch (e) {
      emit(ProfitLossError(e.toString()));
    }
  }
}
