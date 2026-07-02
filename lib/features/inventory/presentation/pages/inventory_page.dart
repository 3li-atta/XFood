import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/entities/ingredient_entity.dart';
import '../bloc/inventory_bloc.dart';
import '../../../../core/di/injection.dart';

/// Inventory management page — view, add, edit ingredients and stock levels.
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InventoryBloc>()..add(const LoadIngredients()),
      child: const _InventoryView(),
    );
  }
}

class _InventoryView extends StatelessWidget {
  const _InventoryView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pos'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<InventoryBloc>().add(const LoadIngredients());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Ingredient'),
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is InventoryError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is InventoryLoaded) {
            final ingredients = state.ingredients;
            if (ingredients.isEmpty) {
              return const Center(child: Text('No ingredients yet.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ing = ingredients[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(Icons.inventory_2_outlined, color: theme.colorScheme.primary),
                    ),
                    title: Text(
                      ing.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 4,
                        children: [
                          Text('Unit: ${ing.unitOfMeasurement}', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                          Text('Cost: \$${ing.costPrice.toStringAsFixed(2)}', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                          Text(
                            'Value: \$${ing.stockValue.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _StockBadge(
                          isLow: ing.isLowStock,
                          stockText: '${ing.currentStock.toStringAsFixed(1)} ${ing.unitOfMeasurement}',
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: 'Edit',
                          onPressed: () =>
                              _showAddEditDialog(context, ingredient: ing),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: theme.colorScheme.error),
                          tooltip: 'Delete',
                          onPressed: () => _confirmDelete(context, ing),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, {IngredientEntity? ingredient}) {
    final isEdit = ingredient != null;
    final nameCtrl = TextEditingController(text: ingredient?.name ?? '');
    final unitCtrl =
        TextEditingController(text: ingredient?.unitOfMeasurement ?? '');
    final stockCtrl = TextEditingController(
        text: ingredient?.currentStock.toString() ?? '0');
    final costCtrl = TextEditingController(
        text: ingredient?.costPrice.toString() ?? '');
    final bloc = context.read<InventoryBloc>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Edit Ingredient' : 'Add Ingredient'),
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
                  controller: unitCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Unit (grams, pieces, kg...)')),
              const SizedBox(height: 12),
              TextField(
                  controller: stockCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Current Stock')),
              const SizedBox(height: 12),
              TextField(
                  controller: costCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Cost per Unit')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final doubleStock = double.tryParse(stockCtrl.text) ?? 0.0;
              final doubleCost = double.tryParse(costCtrl.text) ?? 0.0;
              if (isEdit) {
                bloc.add(UpdateIngredientRequested(
                  id: ingredient.id,
                  name: nameCtrl.text,
                  unitOfMeasurement: unitCtrl.text,
                  costPrice: doubleCost,
                ));
                bloc.add(UpdateStockRequested(
                  id: ingredient.id,
                  currentStock: doubleStock,
                ));
              } else {
                bloc.add(AddIngredientRequested(
                  name: nameCtrl.text,
                  unitOfMeasurement: unitCtrl.text,
                  currentStock: doubleStock,
                  costPrice: doubleCost,
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

  void _confirmDelete(BuildContext context, IngredientEntity ing) {
    final bloc = context.read<InventoryBloc>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Ingredient?'),
        content: Text('Are you sure you want to delete "${ing.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              bloc.add(DeleteIngredientRequested(ing.id));
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final bool isLow;
  final String stockText;
  const _StockBadge({required this.isLow, required this.stockText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isLow ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLow ? Colors.red.shade200 : Colors.green.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isLow ? Colors.red : Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            stockText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isLow ? Colors.red.shade900 : Colors.green.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
