import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/create_sale_usecase.dart';
import '../../../meals/domain/entities/meal_entity.dart';
import '../../../shifts/domain/repositories/shift_repository.dart';
import '../../../../database/app_database.dart';

part 'pos_event.dart';
part 'pos_state.dart';

/// Bloc managing the POS (Point of Sale) screen state.
///
/// Handles cart management and sale completion with stock deduction.
class PosBloc extends Bloc<PosEvent, PosState> {
  final CreateSaleUseCase _createSaleUseCase;
  final ShiftRepository _shiftRepository;

  PosBloc({
    required CreateSaleUseCase createSaleUseCase,
    required ShiftRepository shiftRepository,
  })  : _createSaleUseCase = createSaleUseCase,
        _shiftRepository = shiftRepository,
        super(const PosState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
    on<CompleteSale>(_onCompleteSale);
    on<ChangeOrderType>(_onChangeOrderType);
    on<SelectTable>(_onSelectTable);
    on<ChangePaymentMethod>(_onChangePaymentMethod);
    on<ResetPosStatus>(_onResetPosStatus);
  }

  void _onAddToCart(AddToCart event, Emitter<PosState> emit) {
    final items = List<CartItem>.from(state.cartItems);
    final existingIndex = items.indexWhere((i) => i.meal.id == event.meal.id);

    if (existingIndex >= 0) {
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + 1,
      );
    } else {
      items.add(CartItem(meal: event.meal, quantity: 1));
    }

    emit(state.copyWith(cartItems: items, status: PosStatus.idle));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<PosState> emit) {
    final items = List<CartItem>.from(state.cartItems)
      ..removeWhere((i) => i.meal.id == event.mealId);
    emit(state.copyWith(cartItems: items, status: PosStatus.idle));
  }

  void _onUpdateQuantity(
      UpdateCartItemQuantity event, Emitter<PosState> emit) {
    final items = List<CartItem>.from(state.cartItems);
    final index = items.indexWhere((i) => i.meal.id == event.mealId);
    if (index >= 0) {
      if (event.newQuantity <= 0) {
        items.removeAt(index);
      } else {
        items[index] = items[index].copyWith(quantity: event.newQuantity);
      }
    }
    emit(state.copyWith(cartItems: items, status: PosStatus.idle));
  }

  void _onChangeOrderType(ChangeOrderType event, Emitter<PosState> emit) {
    if (event.orderType != 'dine_in') {
      emit(state.copyWith(orderType: event.orderType, clearTable: true, status: PosStatus.idle));
    } else {
      emit(state.copyWith(orderType: event.orderType, status: PosStatus.idle));
    }
  }

  void _onSelectTable(SelectTable event, Emitter<PosState> emit) {
    emit(state.copyWith(tableId: event.tableId, status: PosStatus.idle));
  }

  void _onChangePaymentMethod(ChangePaymentMethod event, Emitter<PosState> emit) {
    emit(state.copyWith(paymentMethod: event.paymentMethod, status: PosStatus.idle));
  }

  void _onClearCart(ClearCart event, Emitter<PosState> emit) {
    emit(state.copyWith(
      cartItems: [],
      status: PosStatus.idle,
      orderType: 'takeaway',
      paymentMethod: 'cash',
      clearTable: true,
    ));
  }

  Future<void> _onCompleteSale(
      CompleteSale event, Emitter<PosState> emit) async {
    if (state.cartItems.isEmpty) return;

    emit(state.copyWith(status: PosStatus.processing));

    try {
      // 1. Shift Gate Enforcement
      final activeShift = await _shiftRepository.getActiveShift(event.userId);
      if (activeShift == null) {
        emit(state.copyWith(
          status: PosStatus.error,
          errorMessage: 'يجب فتح وردية أولاً (An active shift must be opened first).',
        ));
        return;
      }

      final saleItems = state.cartItems
          .map((c) => SaleInput(
                mealId: c.meal.id,
                quantity: c.quantity,
                priceAtTime: c.meal.sellingPrice,
              ))
          .toList();

      final txnId = await _createSaleUseCase(CreateSaleParams(
        userId: event.userId,
        shiftId: activeShift.id,
        totalAmount: state.totalAmount,
        notes: event.notes,
        items: saleItems,
        discountPercentage: event.discountPercentage,
        taxPercentage: event.taxPercentage,
        orderType: event.orderType,
        paymentMethod: event.paymentMethod,
        tableId: event.tableId,
      ));

      final subtotal = state.totalAmount;
      final discountAmount = subtotal * (event.discountPercentage / 100);
      final taxableAmount = subtotal - discountAmount;
      final taxAmount = taxableAmount * (event.taxPercentage / 100);
      final total = taxableAmount + taxAmount;

      final completedTxn = Transaction(
        id: txnId,
        userId: event.userId,
        shiftId: activeShift.id,
        type: 'sale',
        totalAmount: total,
        subtotalAmount: subtotal,
        discountAmount: discountAmount,
        taxAmount: taxAmount,
        createdAt: DateTime.now(),
        orderType: event.orderType,
        paymentMethod: event.paymentMethod,
        tableId: event.tableId,
        notes: event.notes,
      );

      final completedItems = state.cartItems
          .map((c) => {
                'meal_name': c.meal.name,
                'quantity': c.quantity,
                'meal_price': c.meal.sellingPrice,
              })
          .toList();

      emit(state.copyWith(
        cartItems: [],
        status: PosStatus.success,
        orderType: 'takeaway',
        paymentMethod: 'cash',
        clearTable: true,
        completedTransaction: completedTxn,
        completedTransactionItems: completedItems,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PosStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetPosStatus(ResetPosStatus event, Emitter<PosState> emit) {
    emit(state.copyWith(status: PosStatus.idle));
  }
}
