import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/entities/ingredient_entity.dart';
import '../../domain/repositories/inventory_repository.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository _repository;
  StreamSubscription? _subscription;

  InventoryBloc({required InventoryRepository repository})
      : _repository = repository,
        super(const InventoryInitial()) {
    on<LoadIngredients>(_onLoadIngredients);
    on<AddIngredientRequested>(_onAddIngredient);
    on<UpdateIngredientRequested>(_onUpdateIngredient);
    on<UpdateStockRequested>(_onUpdateStock);
    on<DeleteIngredientRequested>(_onDeleteIngredient);
    on<_UpdateIngredientsList>(_onUpdateIngredientsList);
    on<_OnErrorOccurred>(_onOnErrorOccurred);
  }

  void _onLoadIngredients(LoadIngredients event, Emitter<InventoryState> emit) {
    emit(const InventoryLoading());
    _subscription?.cancel();
    _subscription = _repository.watchAllIngredients().listen(
      (ingredients) {
        add(_UpdateIngredientsList(ingredients));
      },
      onError: (error) {
        add(_OnErrorOccurred(error.toString()));
      },
    );
  }

  // Internal event to handle stream updates
  void _onUpdateIngredientsList(_UpdateIngredientsList event, Emitter<InventoryState> emit) {
    emit(InventoryLoaded(event.ingredients));
  }

  void _onOnErrorOccurred(_OnErrorOccurred event, Emitter<InventoryState> emit) {
    emit(InventoryError(event.message));
  }

  Future<void> _onAddIngredient(
      AddIngredientRequested event, Emitter<InventoryState> emit) async {
    try {
      await _repository.addIngredient(
        name: event.name,
        unitOfMeasurement: event.unitOfMeasurement,
        currentStock: event.currentStock,
        costPrice: event.costPrice,
        minStockAlert: event.minStockAlert,
      );
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onUpdateIngredient(
      UpdateIngredientRequested event, Emitter<InventoryState> emit) async {
    try {
      await _repository.updateIngredient(
        event.id,
        name: event.name,
        unitOfMeasurement: event.unitOfMeasurement,
        costPrice: event.costPrice,
        minStockAlert: event.minStockAlert,
      );
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onUpdateStock(
      UpdateStockRequested event, Emitter<InventoryState> emit) async {
    try {
      await _repository.updateStock(event.id, event.currentStock);
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onDeleteIngredient(
      DeleteIngredientRequested event, Emitter<InventoryState> emit) async {
    try {
      await _repository.deleteIngredient(event.id);
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

// Private helper events for stream subscription
class _UpdateIngredientsList extends InventoryEvent {
  final List<IngredientEntity> ingredients;
  const _UpdateIngredientsList(this.ingredients);

  @override
  List<Object?> get props => [ingredients];
}

class _OnErrorOccurred extends InventoryEvent {
  final String message;
  const _OnErrorOccurred(this.message);

  @override
  List<Object?> get props => [message];
}
