import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/treasury_transaction_entity.dart';
import '../../domain/usecases/treasury_usecases.dart';
import '../../../../core/usecases/usecase.dart';

part 'treasury_event.dart';
part 'treasury_state.dart';

class TreasuryBloc extends Bloc<TreasuryEvent, TreasuryState> {
  final GetCurrentBalanceUseCase _getCurrentBalanceUseCase;
  final GetTreasuryTransactionsPaginatedUseCase _getTreasuryTransactionsPaginatedUseCase;
  final AddManualAdjustmentUseCase _addManualAdjustmentUseCase;

  static const int _pageSize = 20;

  TreasuryBloc({
    required GetCurrentBalanceUseCase getCurrentBalanceUseCase,
    required GetTreasuryTransactionsPaginatedUseCase getTreasuryTransactionsPaginatedUseCase,
    required AddManualAdjustmentUseCase addManualAdjustmentUseCase,
  })  : _getCurrentBalanceUseCase = getCurrentBalanceUseCase,
        _getTreasuryTransactionsPaginatedUseCase = getTreasuryTransactionsPaginatedUseCase,
        _addManualAdjustmentUseCase = addManualAdjustmentUseCase,
        super(const TreasuryInitial()) {
    on<LoadTreasury>(_onLoadTreasury);
    on<LoadMoreTreasury>(_onLoadMoreTreasury);
    on<AddManualAdjustmentRequested>(_onAddManualAdjustment);
  }

  Future<void> _onLoadTreasury(LoadTreasury event, Emitter<TreasuryState> emit) async {
    if (event.isRefresh || state is! TreasuryLoaded) {
      emit(const TreasuryLoading());
    }
    try {
      final balance = await _getCurrentBalanceUseCase(const NoParams());
      final transactions = await _getTreasuryTransactionsPaginatedUseCase(
        const TreasuryPaginationParams(limit: _pageSize, offset: 0),
      );
      emit(TreasuryLoaded(
        transactions: transactions,
        balance: balance,
        hasMore: transactions.length >= _pageSize,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(TreasuryError(e.toString()));
    }
  }

  Future<void> _onLoadMoreTreasury(LoadMoreTreasury event, Emitter<TreasuryState> emit) async {
    final currentState = state;
    if (currentState is TreasuryLoaded && currentState.hasMore && !currentState.isLoadingMore) {
      emit(currentState.copyWith(isLoadingMore: true));
      try {
        final newTransactions = await _getTreasuryTransactionsPaginatedUseCase(
          TreasuryPaginationParams(
            limit: _pageSize,
            offset: currentState.transactions.length,
          ),
        );
        emit(currentState.copyWith(
          transactions: [...currentState.transactions, ...newTransactions],
          hasMore: newTransactions.length >= _pageSize,
          isLoadingMore: false,
        ));
      } catch (e) {
        emit(TreasuryError(e.toString()));
      }
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
