import 'package:drift/drift.dart';
import '../../../../core/entities/ingredient_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/ingredient_dao.dart';

/// Concrete implementation of [InventoryRepository] using Drift DAOs.
class InventoryRepositoryImpl implements InventoryRepository {
  final IngredientDao _ingredientDao;

  InventoryRepositoryImpl(this._ingredientDao);

  @override
  Future<List<IngredientEntity>> getAllIngredients() async {
    final rows = await _ingredientDao.getAllIngredients();
    return rows.map(_mapToEntity).toList();
  }

  @override
  Future<IngredientEntity> getIngredientById(int id) async {
    try {
      final row = await _ingredientDao.getById(id);
      return _mapToEntity(row);
    } catch (_) {
      throw NotFoundException('Ingredient', id);
    }
  }

  @override
  Stream<List<IngredientEntity>> watchAllIngredients() {
    return _ingredientDao.watchAllIngredients().map(
          (rows) => rows.map(_mapToEntity).toList(),
        );
  }

  @override
  Future<List<IngredientEntity>> getLowStockIngredients(
      double threshold) async {
    final rows = await _ingredientDao.getLowStockIngredients(threshold);
    return rows.map(_mapToEntity).toList();
  }

  @override
  Future<IngredientEntity> addIngredient({
    required String name,
    required String unitOfMeasurement,
    required double currentStock,
    required double costPrice,
    required double minStockAlert,
  }) async {
    final id = await _ingredientDao.insertIngredient(
      IngredientsCompanion.insert(
        name: name,
        unitOfMeasurement: unitOfMeasurement,
        currentStock: Value(currentStock),
        costPrice: costPrice,
        minStockAlert: Value(minStockAlert),
      ),
    );
    return getIngredientById(id);
  }

  @override
  Future<bool> updateStock(int ingredientId, double newStock) {
    return _ingredientDao.updateStock(ingredientId, newStock);
  }

  @override
  Future<bool> updateIngredient(
    int ingredientId, {
    String? name,
    String? unitOfMeasurement,
    double? costPrice,
    double? minStockAlert,
  }) {
    final companion = IngredientsCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      unitOfMeasurement: unitOfMeasurement != null
          ? Value(unitOfMeasurement)
          : const Value.absent(),
      costPrice: costPrice != null ? Value(costPrice) : const Value.absent(),
      minStockAlert: minStockAlert != null ? Value(minStockAlert) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    return _ingredientDao.updateIngredient(ingredientId, companion);
  }

  @override
  Future<bool> deleteIngredient(int ingredientId) async {
    final result = await _ingredientDao.deleteIngredient(ingredientId);
    return result > 0;
  }

  IngredientEntity _mapToEntity(Ingredient row) {
    return IngredientEntity(
      id: row.id,
      name: row.name,
      unitOfMeasurement: row.unitOfMeasurement,
      currentStock: row.currentStock,
      costPrice: row.costPrice,
      minStockAlert: row.minStockAlert,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
