import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/treasury_transaction_entity.dart';
import '../../domain/usecases/treasury_usecases.dart';
import '../../../../core/usecases/usecase.dart';

part 'treasury_event.dart';
part 'treasury_state.dart';

class TreasuryBloc extends Bloc<TreasuryEvent, TreasuryState> {
  final GetCurrentBalanceUseCase _getCurrentBalanceUseCase;
  final GetAllTreasuryTransactionsUseCase _getAllTreasuryTransactionsUseCase;
  final AddManualAdjustmentUseCase _addManualAdjustmentUseCase;

  TreasuryBloc({
    required GetCurrentBalanceUseCase getCurrentBalanceUseCase,
    required GetAllTreasuryTransactionsUseCase getAllTreasuryTransactionsUseCase,
    required AddManualAdjustmentUseCase addManualAdjustmentUseCase,
  })  : _getCurrentBalanceUseCase = getCurrentBalanceUseCase,
        _getAllTreasuryTransactionsUseCase = getAllTreasuryTransactionsUseCase,
        _addManualAdjustmentUseCase = addManualAdjustmentUseCase,
        super(const TreasuryInitial()) {
    on<LoadTreasury>(_onLoadTreasury);
    on<AddManualAdjustmentRequested>(_onAddManualAdjustment);
  }

  Future<void> _onLoadTreasury(LoadTreasury event, Emitter<TreasuryState> emit) async {
    emit(const TreasuryLoading());
    try {
      final balance = await _getCurrentBalanceUseCase(const NoParams());
      final transactions = await _getAllTreasuryTransactionsUseCase(const NoParams());
      emit(TreasuryLoaded(transactions: transactions, balance: balance));
    } catch (e) {
      emit(TreasuryError(e.toString()));
    }
  }

  Future<void> _onAddManualAdjustment(AddManualAdjustmentRequested event, Emitter<TreasuryState> emit) async {
    emit(const TreasuryLoading());
    try {
      await _addManualAdjustmentUseCase(ManualAdjustmentParams(
        userId: event.userId,
        shiftId: event.shiftId,
        type: event.type,
        amount: event.amount,
        description: event.description,
      ));
      emit(const TreasurySuccess());
    } catch (e) {
      emit(TreasuryError(e.toString()));
    }
  }
}
