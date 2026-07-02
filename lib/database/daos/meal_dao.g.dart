// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_dao.dart';

// ignore_for_file: type=lint
mixin _$MealDaoMixin on DatabaseAccessor<AppDatabase> {
  $MealsTable get meals => attachedDatabase.meals;
  MealDaoManager get managers => MealDaoManager(this);
}

class MealDaoManager {
  final _$MealDaoMixin _db;
  MealDaoManager(this._db);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db.attachedDatabase, _db.meals);
}
