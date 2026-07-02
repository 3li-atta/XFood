/// Application-wide constants and enums for XFood POS.
library;

/// User roles in the POS system.
enum UserRole { admin, cashier }

/// Types of transactions tracked by the system.
enum TransactionType { sale, purchase, waste, inventoryCheck }

/// Whether a transaction line item refers to a meal or raw ingredient.
enum TransactionItemType { meal, ingredient }

/// Common units of measurement for ingredients.
class UnitOfMeasurement {
  static const String grams = 'grams';
  static const String kilograms = 'kg';
  static const String liters = 'liters';
  static const String milliliters = 'ml';
  static const String pieces = 'pieces';
  static const String cups = 'cups';

  static const List<String> all = [
    grams,
    kilograms,
    liters,
    milliliters,
    pieces,
    cups,
  ];
}

/// Meal categories for menu organization.
class MealCategory {
  static const String appetizer = 'Appetizer';
  static const String mainCourse = 'Main Course';
  static const String dessert = 'Dessert';
  static const String drink = 'Drink';
  static const String side = 'Side';
  static const String combo = 'Combo';

  static const List<String> all = [
    appetizer,
    mainCourse,
    dessert,
    drink,
    side,
    combo,
  ];
}
