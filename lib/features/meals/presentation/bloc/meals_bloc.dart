import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/meal_repository.dart';

part 'meals_event.dart';
part 'meals_state.dart';

class MealsBloc extends Bloc<MealsEvent, MealsState> {
  final MealRepository _repository;
  StreamSubscription? _subscription;

  MealsBloc({required MealRepository repository})
      : _repository = repository,
        super(const MealsInitial()) {
    on<LoadMeals>(_onLoadMeals);
    on<CreateMealRequested>(_onCreateMeal);
    on<UpdateMealRequested>(_onUpdateMeal);
    on<DeactivateMealRequested>(_onDeactivateMeal);
    on<_UpdateMealsList>(_onUpdateMealsList);
    on<_OnErrorOccurred>(_onOnErrorOccurred);
  }

  void _onLoadMeals(LoadMeals event, Emitter<MealsState> emit) {
    emit(const MealsLoading());
    _subscription?.cancel();
    _subscription = _repository.watchActiveMeals().listen(
      (meals) {
        add(_UpdateMealsList(meals));
      },
      onError: (error) {
        add(_OnErrorOccurred(error.toString()));
      },
    );
  }

  void _onUpdateMealsList(_UpdateMealsList event, Emitter<MealsState> emit) {
    emit(MealsLoaded(event.meals));
  }

  void _onOnErrorOccurred(_OnErrorOccurred event, Emitter<MealsState> emit) {
    emit(MealsError(event.message));
  }

  Future<void> _onCreateMeal(
      CreateMealRequested event, Emitter<MealsState> emit) async {
    try {
      await _repository.createMeal(
        name: event.name,
        sellingPrice: event.sellingPrice,
        category: event.category,
      );
    } catch (e) {
      emit(MealsError(e.toString()));
    }
  }

  Future<void> _onUpdateMeal(
      UpdateMealRequested event, Emitter<MealsState> emit) async {
    try {
      await _repository.updateMeal(
        event.id,
        name: event.name,
        sellingPrice: event.sellingPrice,
        category: event.category,
      );
    } catch (e) {
      emit(MealsError(e.toString()));
    }
  }

  Future<void> _onDeactivateMeal(
      DeactivateMealRequested event, Emitter<MealsState> emit) async {
    try {
      await _repository.deactivateMeal(event.id);
    } catch (e) {
      emit(MealsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

class _UpdateMealsList extends MealsEvent {
  final List<MealEntity> meals;
  const _UpdateMealsList(this.meals);

  @override
  List<Object?> get props => [meals];
}

class _OnErrorOccurred extends MealsEvent {
  final String message;
  const _OnErrorOccurred(this.message);

  @override
  List<Object?> get props => [message];
}
