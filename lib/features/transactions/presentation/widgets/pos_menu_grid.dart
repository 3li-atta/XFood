import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../database/app_database.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/session_manager.dart';
import '../../../meals/domain/entities/meal_entity.dart';
import '../../../meals/domain/repositories/meal_repository.dart';
import '../bloc/pos_bloc.dart';

/// Center: Grid of available meals from the menu.
class PosMenuGrid extends StatefulWidget {
  const PosMenuGrid({super.key});

  @override
  State<PosMenuGrid> createState() => _PosMenuGridState();
}

class _PosMenuGridState extends State<PosMenuGrid> {
  String? _selectedCategory;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<List<MealEntity>>(
      stream: getIt<MealRepository>().watchActiveMeals(),
      builder: (context, mealsSnapshot) {
        return StreamBuilder<List<int>>(
          stream: getIt<AppDatabase>().mealDao.watchLowStockMealIds(),
          builder: (context, lowStockSnapshot) {
            if (mealsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final allMeals = mealsSnapshot.data ?? [];
            final lowStockIds = lowStockSnapshot.data ?? [];

            if (allMeals.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.restaurant_menu,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.3)),
                    const SizedBox(height: 16),
                    const Text('No meals found. Add meals first.'),
                    if (SessionManager.instance.isAdmin) ...[
                      const SizedBox(height: 8),
                      FilledButton.tonal(
                        onPressed: () => context.go('/meals'),
                        child: const Text('Go to Meals'),
                      ),
                    ],
                  ],
                ),
              );
            }

            // Categories list from all active meals
            final categories = allMeals.map((m) => m.category).toSet().toList();

            // Filter meals
            var filteredMeals = List<MealEntity>.from(allMeals);
            if (_selectedCategory != null) {
              filteredMeals = filteredMeals
                  .where((m) => m.category == _selectedCategory)
                  .toList();
            }
            if (_searchQuery.isNotEmpty) {
              filteredMeals = filteredMeals
                  .where((m) => m.name.toLowerCase().contains(_searchQuery))
                  .toList();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with category filter and search bar
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Menu', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 250,
                            height: 38,
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'البحث عن وجبة...',
                                prefixIcon: const Icon(Icons.search, size: 18),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 16),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            _searchQuery = '';
                                          });
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val.trim().toLowerCase();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Category filter chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FilterChip(
                              label: const Text('الكل'),
                              selected: _selectedCategory == null,
                              onSelected: (_) =>
                                  setState(() => _selectedCategory = null),
                              showCheckmark: false,
                              selectedColor: theme.colorScheme.primary,
                              backgroundColor: theme.colorScheme.surface,
                              labelStyle: TextStyle(
                                  color: _selectedCategory == null 
                                      ? Colors.white 
                                      : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: _selectedCategory == null 
                                    ? Colors.transparent 
                                    : theme.colorScheme.outlineVariant,
                                width: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ...categories.map((cat) {
                              final isSelected = _selectedCategory == cat;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(cat),
                                  selected: isSelected,
                                  onSelected: (_) =>
                                      setState(() => _selectedCategory = cat),
                                  showCheckmark: false,
                                  selectedColor: theme.colorScheme.primary,
                                  backgroundColor: theme.colorScheme.surface,
                                  labelStyle: TextStyle(
                                      color: isSelected 
                                          ? Colors.white 
                                          : theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(
                                    color: isSelected 
                                        ? Colors.transparent 
                                        : theme.colorScheme.outlineVariant,
                                    width: 1,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Meal grid
                Expanded(
                  child: Column(
                    children: [
                      if (lowStockIds.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning, color: Colors.orange, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'تنبيه: يوجد بعض الوجبات التي شارف مخزونها على النفاد!',
                                  style: TextStyle(color: Colors.orange.shade800, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final availableWidth = constraints.maxWidth;
                            final crossAxisCount = availableWidth < 240
                                ? 1
                                : (availableWidth < 480 ? 2 : (availableWidth < 800 ? 3 : 4));
                            final childAspectRatio = availableWidth < 240
                                ? 2.2
                                : (availableWidth < 480 ? 0.95 : 1.2);

                            return GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: childAspectRatio,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: filteredMeals.length,
                              itemBuilder: (context, index) {
                                final meal = filteredMeals[index];
                                final isLowStock = lowStockIds.contains(meal.id);
                                return _MealCard(meal: meal, isLowStock: isLowStock);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// Individual meal card in the grid.
class _MealCard extends StatelessWidget {
  final MealEntity meal;
  final bool isLowStock;
  const _MealCard({required this.meal, this.isLowStock = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final cardPadding = isMobile ? 8.0 : 16.0;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isLowStock ? BorderSide(color: Colors.orange.shade300, width: 1.5) : BorderSide.none,
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () => context.read<PosBloc>().add(AddToCart(meal)),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.fastfood_rounded,
                      size: isMobile ? 32 : 40,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: isMobile ? 12 : 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${meal.sellingPrice.toStringAsFixed(2)} ج.م',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 13 : 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (screenWidth > 450)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        meal.category,
                        style: TextStyle(
                          fontSize: isMobile ? 9 : 10,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isLowStock)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'قليل',
                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
