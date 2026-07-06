import 'dart:async';
import 'dart:convert';
import 'package:xfood_pos/core/entities/ingredient_entity.dart';
import 'package:xfood_pos/core/services/lan_sync/lan_client_service.dart';
import 'package:xfood_pos/core/services/lan_sync/ws_events.dart';
import 'package:xfood_pos/features/meals/domain/entities/meal_entity.dart';
import 'package:xfood_pos/features/meals/domain/entities/recipe_entity.dart';
import 'package:xfood_pos/features/meals/domain/repositories/meal_repository.dart';

/// Client-side implementation of [MealRepository] that delegates all operations
/// to the Master server via HTTP REST API and updates reactively via WebSockets.
class RemoteMealRepository implements MealRepository {
  final LanClientService _client;

  RemoteMealRepository(this._client);

  DateTime _parseDateTime(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    } else if (value is String) {
      return DateTime.parse(value);
    }
    return DateTime.now();
  }

  MealEntity _mapJsonToMealEntity(Map<String, dynamic> json) {
    return MealEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      category: json['category'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  @override
  Future<List<MealEntity>> getActiveMeals() async {
    final response = await _client.get('/api/meals');
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((item) => _mapJsonToMealEntity(item as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load active meals from master server');
  }

  @override
  Future<List<MealEntity>> getAllMeals() async {
    // Falls back to active meals or fetches all (we can use same endpoint)
    final response = await _client.get('/api/meals');
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((item) => _mapJsonToMealEntity(item as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load meals from master server');
  }

  @override
  Future<List<MealEntity>> getMealsByCategory(String category) async {
    final all = await getActiveMeals();
    return all.where((m) => m.category == category).toList();
  }

  @override
  Stream<List<MealEntity>> watchActiveMeals() {
    final controller = StreamController<List<MealEntity>>.broadcast();

    Future<void> updateList() async {
      try {
        final list = await getActiveMeals();
        if (!controller.isClosed) {
          controller.add(list);
        }
      } catch (_) {}
    }

    // Initial fetch
    updateList();

    // Re-fetch on any menu updates from WebSocket
    final subscription = _client.events.listen((msg) {
      if (msg.event == WsEvents.menuUpdated ||
          msg.event == WsEvents.mealAdded ||
          msg.event == WsEvents.mealDeactivated) {
        updateList();
      }
    });

    controller.onCancel = () {
      subscription.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  Stream<List<MealEntity>> watchAllMeals() => watchActiveMeals();

  @override
  Future<MealEntity> getMealById(int id) async {
    final all = await getActiveMeals();
    return all.firstWhere(
      (m) => m.id == id,
      orElse: () => throw Exception('Meal with ID $id not found on master server'),
    );
  }

  @override
  Future<MealEntity> createMeal({
    required String name,
    required double sellingPrice,
    required String category,
  }) {
    throw UnsupportedError('Meal management is only supported on the Master device.');
  }

  @override
  Future<bool> updateMeal(int mealId, {
    String? name,
    double? sellingPrice,
    String? category,
    bool? isActive,
  }) {
    throw UnsupportedError('Meal management is only supported on the Master device.');
  }

  @override
  Future<bool> deactivateMeal(int mealId) {
    throw UnsupportedError('Meal management is only supported on the Master device.');
  }

  @override
  Future<bool> toggleMealActive(int mealId, bool isActive) {
    throw UnsupportedError('Meal management is only supported on the Master device.');
  }

  @override
  Future<List<RecipeDetailEntity>> getRecipeForMeal(int mealId) {
    throw UnsupportedError('Recipe reading is only supported on the Master device.');
  }

  @override
  Future<void> setRecipe(int mealId, List<RecipeIngredientInput> ingredients) {
    throw UnsupportedError('Recipe management is only supported on the Master device.');
  }

  @override
  Future<double> calculateMealCost(int mealId) async {
    return 0.0; // Client POS terminals do not perform cost estimation
  }
}
