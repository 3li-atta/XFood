part of 'purchase_bloc.dart';

abstract class PurchaseState extends Equatable {
  const PurchaseState();

  @override
  List<Object?> get props => [];
}

class PurchaseInitial extends PurchaseState {
  const PurchaseInitial();
}

class PurchaseLoading extends PurchaseState {
  const PurchaseLoading();
}

class PurchaseLoaded extends PurchaseState {
  final List<PurchaseInvoiceEntity> invoices;

  const PurchaseLoaded(this.invoices);

  @override
  List<Object?> get props => [invoices];
}

class PurchaseSuccess extends PurchaseState {
  const PurchaseSuccess();
}

class PurchaseError extends PurchaseState {
  final String message;

  const PurchaseError(this.message);

  @override
  List<Object?> get props => [message];
}
