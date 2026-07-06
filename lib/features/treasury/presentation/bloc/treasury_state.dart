part of 'treasury_bloc.dart';

abstract class TreasuryState extends Equatable {
  const TreasuryState();

  @override
  List<Object?> get props => [];
}

class TreasuryInitial extends TreasuryState {
  const TreasuryInitial();
}

class TreasuryLoading extends TreasuryState {
  const TreasuryLoading();
}

class TreasuryLoaded extends TreasuryState {
  final List<TreasuryTransactionEntity> transactions;
  final double balance;
  final bool hasMore;
  final bool isLoadingMore;

  const TreasuryLoaded({
    required this.transactions,
    required this.balance,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  TreasuryLoaded copyWith({
    List<TreasuryTransactionEntity>? transactions,
    double? balance,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return TreasuryLoaded(
      transactions: transactions ?? this.transactions,
      balance: balance ?? this.balance,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [transactions, balance, hasMore, isLoadingMore];
}

class TreasurySuccess extends TreasuryState {
  const TreasurySuccess();
}

class TreasuryError extends TreasuryState {
  final String message;

  const TreasuryError(this.message);

  @override
  List<Object?> get props => [message];
}
