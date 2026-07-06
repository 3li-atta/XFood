import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/purchase_invoice_entity.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../../domain/usecases/procurement_usecases.dart';
import '../../../../core/usecases/usecase.dart';

part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final CreatePurchaseInvoiceUseCase _createPurchaseInvoiceUseCase;
  final GetAllPurchaseInvoicesUseCase _getAllPurchaseInvoicesUseCase;
  final VoidPurchaseInvoiceUseCase _voidPurchaseInvoiceUseCase;

  PurchaseBloc({
    required CreatePurchaseInvoiceUseCase createPurchaseInvoiceUseCase,
    required GetAllPurchaseInvoicesUseCase getAllPurchaseInvoicesUseCase,
    required VoidPurchaseInvoiceUseCase voidPurchaseInvoiceUseCase,
  })  : _createPurchaseInvoiceUseCase = createPurchaseInvoiceUseCase,
        _getAllPurchaseInvoicesUseCase = getAllPurchaseInvoicesUseCase,
        _voidPurchaseInvoiceUseCase = voidPurchaseInvoiceUseCase,
        super(const PurchaseInitial()) {
    on<LoadPurchases>(_onLoadPurchases);
    on<CreatePurchaseInvoiceRequested>(_onCreatePurchase);
    on<VoidPurchaseInvoiceRequested>(_onVoidPurchase);
  }

  Future<void> _onLoadPurchases(LoadPurchases event, Emitter<PurchaseState> emit) async {
    emit(const PurchaseLoading());
    try {
      final invoices = await _getAllPurchaseInvoicesUseCase(const NoParams());
      emit(PurchaseLoaded(invoices));
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }

  Future<void> _onCreatePurchase(CreatePurchaseInvoiceRequested event, Emitter<PurchaseState> emit) async {
    emit(const PurchaseLoading());
    try {
      await _createPurchaseInvoiceUseCase(CreatePurchaseParams(
        userId: event.userId,
        shiftId: event.shiftId,
        supplierName: event.supplierName,
        notes: event.notes,
        items: event.items,
      ));
      emit(const PurchaseSuccess());
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }

  Future<void> _onVoidPurchase(VoidPurchaseInvoiceRequested event, Emitter<PurchaseState> emit) async {
    emit(const PurchaseLoading());
    try {
      await _voidPurchaseInvoiceUseCase(VoidPurchaseParams(
        invoiceId: event.invoiceId,
        reason: event.reason,
      ));
      emit(const PurchaseSuccess());
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }
}
