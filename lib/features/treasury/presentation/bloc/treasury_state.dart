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

  const TreasuryLoaded({required this.transactions, required this.balance});

  @override
  List<Object?> get props => [transactions, balance];
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
