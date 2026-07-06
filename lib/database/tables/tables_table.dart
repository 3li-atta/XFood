import 'package:drift/drift.dart';

/// Tables table — represents physical tables in a dine-in restaurant.
@DataClassName('RestaurantTable')
class Tables extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)(); // "Table 1", "VIP Table", etc.
  TextColumn get status => text().withLength(min: 4, max: 20).withDefault(const Constant('available'))(); // 'available', 'occupied', 'reserved'
  IntColumn get seatsCount => integer().withDefault(const Constant(4))();
}
