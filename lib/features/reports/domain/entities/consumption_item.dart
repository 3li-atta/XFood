import 'package:equatable/equatable.dart';

/// Entity for a single ingredient row in the Inventory Consumption Report.
///
/// Tracks both standard usage (from sold meals via recipes) and waste usage
/// (from direct waste records), plus the combined total.
class ConsumptionItem extends Equatable {
  final int ingredientId;
  final String ingredientName;
  final String unit;
  final double standardUsage;  // From sales via recipes
  final double wasteUsage;     // From waste records
  final double totalConsumed;  // standardUsage + wasteUsage
  final double wasteRatio;     // (wasteUsage / totalConsumed) * 100

  const ConsumptionItem({
    required this.ingredientId,
    required this.ingredientName,
    required this.unit,
    required this.standardUsage,
    required this.wasteUsage,
    required this.totalConsumed,
    required this.wasteRatio,
  });

  @override
  List<Object?> get props => [
        ingredientId,
        ingredientName,
        unit,
        standardUsage,
        wasteUsage,
        totalConsumed,
        wasteRatio,
      ];
}
