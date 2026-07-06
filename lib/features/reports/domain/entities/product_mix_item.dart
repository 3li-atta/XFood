import 'package:equatable/equatable.dart';

/// Entity for a single item in the Product Mix / Item Sales Report.
class ProductMixItem extends Equatable {
  final int mealId;
  final String mealName;
  final String category;
  final double totalQuantity;
  final double totalRevenue;
  final double revenuePercentage; // Calculated in repository

  const ProductMixItem({
    required this.mealId,
    required this.mealName,
    required this.category,
    required this.totalQuantity,
    required this.totalRevenue,
    this.revenuePercentage = 0.0,
  });

  ProductMixItem copyWith({double? revenuePercentage}) {
    return ProductMixItem(
      mealId: mealId,
      mealName: mealName,
      category: category,
      totalQuantity: totalQuantity,
      totalRevenue: totalRevenue,
      revenuePercentage: revenuePercentage ?? this.revenuePercentage,
    );
  }

  @override
  List<Object?> get props => [mealId, mealName, category, totalQuantity, totalRevenue, revenuePercentage];
}
