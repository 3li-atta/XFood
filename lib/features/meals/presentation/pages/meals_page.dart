import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/meal_repository.dart';
import '../bloc/meals_bloc.dart';
import '../../../../core/entities/ingredient_entity.dart';
import '../../../inventory/domain/repositories/inventory_repository.dart';
import '../../../../core/di/injection.dart';

/// Meals management page — view, add, edit meals and their recipes.
class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MealsBloc>()..add(const LoadMeals()),
      child: const _MealsView(),
    );
  }
}

class _MealsView extends StatelessWidget {
  const _MealsView();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MealsBloc>();
    final mealRepo = getIt<MealRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals & Recipes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pos'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => bloc.add(const LoadMeals()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMealDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Meal'),
      ),
      body: BlocBuilder<MealsBloc, MealsState>(
        builder: (context, state) {
          if (state is MealsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MealsError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is MealsLoaded) {
            final meals = state.meals;
            if (meals.isEmpty) {
              return const Center(child: Text('No meals yet. Add one!'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return _MealTile(
                  meal: meal,
                  onEdit: () => _showMealDialog(context, meal: meal),
                  onRecipe: () => _showRecipeDialog(context, meal, bloc),
                  onToggle: () {
                    bloc.add(ToggleMealActiveRequested(meal.id, !meal.isActive));
                  },
                  onViewCost: () => _showCostBreakdown(context, meal, mealRepo),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showMealDialog(BuildContext context, {MealEntity? meal}) {
    final isEdit = meal != null;
    final nameCtrl = TextEditingController(text: meal?.name ?? '');
    final priceCtrl =
        TextEditingController(text: meal?.sellingPrice.toString() ?? '');
    final catCtrl = TextEditingController(text: meal?.category ?? '');
    final bloc = context.read<MealsBloc>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Edit Meal' : 'Add Meal'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 12),
              TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Selling Price')),
              const SizedBox(height: 12),
              TextField(
                  controller: catCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Category',
                      hintText: 'Main Course, Drink, Dessert...')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final doublePrice = double.tryParse(priceCtrl.text) ?? 0.0;
              if (isEdit) {
                bloc.add(UpdateMealRequested(
                  id: meal.id,
                  name: nameCtrl.text,
                  sellingPrice: doublePrice,
                  category: catCtrl.text,
                ));
              } else {
                bloc.add(CreateMealRequested(
                  name: nameCtrl.text,
                  sellingPrice: doublePrice,
                  category: catCtrl.text,
                ));
              }
              Navigator.pop(ctx);
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _showRecipeDialog(BuildContext context, MealEntity meal, MealsBloc bloc) async {
    final mealRepo = getIt<MealRepository>();
    final recipe = await mealRepo.getRecipeForMeal(meal.id);
    final allIngredients = await getIt<InventoryRepository>().getAllIngredients();

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) => _RecipeEditorDialog(
        meal: meal,
        currentRecipe: recipe,
        allIngredients: allIngredients,
        mealRepo: mealRepo,
        onSaved: () => bloc.add(const LoadMeals()),
      ),
    );
  }

  void _showCostBreakdown(BuildContext context, MealEntity meal, MealRepository mealRepo) async {
    final recipe = await mealRepo.getRecipeForMeal(meal.id);
    final totalCost = await mealRepo.calculateMealCost(meal.id);
    final profit = meal.sellingPrice - totalCost;

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cost: ${meal.name}'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...recipe.map((r) => ListTile(
                    dense: true,
                    title: Text(r.ingredient.name),
                    subtitle: Text(
                        '${r.recipe.quantityRequired} ${r.ingredient.unitOfMeasurement}'),
                    trailing: Text('${r.ingredientCost.toStringAsFixed(2)} ج.م'),
                  )),
              const Divider(),
              ListTile(
                title: const Text('Total Cost',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text('${totalCost.toStringAsFixed(2)} ج.م',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('Selling Price'),
                trailing: Text('${meal.sellingPrice.toStringAsFixed(2)} ج.م'),
              ),
              ListTile(
                title: Text('Profit',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: profit >= 0 ? Colors.green : Colors.red)),
                trailing: Text('${profit.toStringAsFixed(2)} ج.م',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: profit >= 0 ? Colors.green : Colors.red)),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close')),
        ],
      ),
    );
  }
}

class _MealTile extends StatelessWidget {
  final MealEntity meal;
  final VoidCallback onEdit;
  final VoidCallback onRecipe;
  final VoidCallback onToggle;
  final VoidCallback onViewCost;

  const _MealTile({
    required this.meal,
    required this.onEdit,
    required this.onRecipe,
    required this.onToggle,
    required this.onViewCost,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar Container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: meal.isActive
                    ? colorScheme.primary.withValues(alpha: 0.08)
                    : colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                meal.category.toLowerCase().contains('drink')
                    ? Icons.local_drink_rounded
                    : Icons.restaurant_rounded,
                color: meal.isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      decoration: meal.isActive ? null : TextDecoration.lineThrough,
                      color: meal.isActive ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          meal.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${meal.sellingPrice.toStringAsFixed(2)} ج.م',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: meal.isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.receipt_long_rounded),
                  tooltip: 'Recipe',
                  color: meal.isActive ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  onPressed: onRecipe,
                ),
                IconButton(
                  icon: const Icon(Icons.calculate_outlined),
                  tooltip: 'Cost Breakdown',
                  color: meal.isActive ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  onPressed: onViewCost,
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert_rounded, color: colorScheme.onSurfaceVariant),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'toggle') {
                      onToggle();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('Edit Meal'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'toggle',
                      child: Row(
                        children: [
                          Icon(
                            meal.isActive ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(meal.isActive ? 'Deactivate' : 'Activate'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeEditorDialog extends StatefulWidget {
  final MealEntity meal;
  final List<RecipeDetailEntity> currentRecipe;
  final List<IngredientEntity> allIngredients;
  final MealRepository mealRepo;
  final VoidCallback onSaved;

  const _RecipeEditorDialog({
    required this.meal,
    required this.currentRecipe,
    required this.allIngredients,
    required this.mealRepo,
    required this.onSaved,
  });

  @override
  State<_RecipeEditorDialog> createState() => _RecipeEditorDialogState();
}

class _RecipeEditorDialogState extends State<_RecipeEditorDialog> {
  late List<_RecipeEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = widget.currentRecipe
        .map((r) => _RecipeEntry(
              ingredientId: r.ingredient.id,
              quantity: r.recipe.quantityRequired,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Recipe: ${widget.meal.name}'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_entries.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('No ingredients in recipe yet.'),
              )
            else
              ..._entries.asMap().entries.map((e) {
                final idx = e.key;
                final entry = e.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<int>(
                          initialValue: entry.ingredientId,
                          decoration: const InputDecoration(
                              labelText: 'Ingredient', isDense: true),
                          items: widget.allIngredients
                              .map((i) => DropdownMenuItem(
                                  value: i.id, child: Text(i.name)))
                              .toList(),
                          onChanged: (v) => setState(
                              () => _entries[idx].ingredientId = v!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue: entry.quantity.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Qty', isDense: true),
                          onChanged: (v) => _entries[idx].quantity =
                              double.tryParse(v) ?? 0,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () =>
                            setState(() => _entries.removeAt(idx)),
                      ),
                    ],
                  ),
                );
              }),
            if (widget.allIngredients.isNotEmpty)
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Ingredient'),
                onPressed: () => setState(() => _entries.add(_RecipeEntry(
                      ingredientId: widget.allIngredients.first.id,
                      quantity: 1,
                    ))),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () async {
            await widget.mealRepo.setRecipe(
              widget.meal.id,
              _entries
                  .map((e) => RecipeIngredientInput(
                        ingredientId: e.ingredientId,
                        quantityRequired: e.quantity,
                      ))
                  .toList(),
            );
            if (context.mounted) Navigator.pop(context);
            widget.onSaved();
          },
          child: const Text('Save Recipe'),
        ),
      ],
    );
  }
}

class _RecipeEntry {
  int ingredientId;
  double quantity;
  _RecipeEntry({required this.ingredientId, required this.quantity});
}
