import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/entities/ingredient_entity.dart';
import '../bloc/inventory_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../../../core/utils/session_manager.dart';

/// صفحة إدارة المخزون - عرض المواد الخام وتعديلها وإضافة الهالك بتصميم لوحة بيانات عالية الجودة.
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

class _InventoryView extends StatefulWidget {
  const _InventoryView();

  @override
  State<_InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<_InventoryView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المخزون'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pos'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
            tooltip: 'تسجيل الهالك / Record Waste',
            onPressed: () => _showRecordWasteDialog(context),
          ),
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
        label: const Text('إضافة صنف'),
      ),
      body: BlocConsumer<InventoryBloc, InventoryState>(
        listener: (context, state) {
          if (state is InventoryError) {
            String displayMessage = state.message;
            if (state.message.contains('FOREIGN KEY constraint failed') ||
                state.message.contains('SqliteException(787)')) {
              displayMessage = 'لا يمكن حذف هذا المكون لأنه مرتبط بوصفات وجبات أو عمليات شراء نشطة.';
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(displayMessage),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        buildWhen: (previous, current) {
          if (current is InventoryError && previous is InventoryLoaded) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is InventoryError) {
            return Center(child: Text('خطأ: ${state.message}'));
          }
          if (state is InventoryLoaded) {
            final ingredients = state.ingredients;
            if (ingredients.isEmpty) {
              return const Center(child: Text('لا توجد أصناف في المخزون حالياً.'));
            }

            final searchQuery = _searchController.text.toLowerCase();
            final filtered = ingredients.where((ing) {
              return ing.name.toLowerCase().contains(searchQuery);
            }).toList();

            final totalValue = filtered.fold<double>(
              0.0,
              (sum, ing) => sum + ing.stockValue,
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // شريط البحث والتحليلات العلوي التفاعلي
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 600;

                          final searchField = TextField(
                            controller: _searchController,
                            onChanged: (val) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'البحث عن صنف بالاسم...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          );

                          final totalValueWidget = Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.monetization_on, color: theme.colorScheme.primary),
                                const SizedBox(width: 8),
                                Text(
                                  'إجمالي قيمة المخزون: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                Text(
                                  '${totalValue.toStringAsFixed(2)} ج.م',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (isNarrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                searchField,
                                const SizedBox(height: 12),
                                totalValueWidget,
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(child: searchField),
                              const SizedBox(width: 16),
                              totalValueWidget,
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // لوحة البيانات وجدول الأصناف
                  Expanded(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width - 64,
                              ),
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(
                                  colorScheme.primaryContainer.withValues(alpha: 0.2),
                                ),
                                columnSpacing: 24,
                                horizontalMargin: 20,
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      'اسم الصنف',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'المخزون الحالي',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'تكلفة الوحدة',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'قيمة المخزون',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'إجراءات',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: filtered.map((ing) {
                                  final isLow = ing.isLowStock;
                                  return DataRow(
                                    cells: [
                                      // اسم الصنف مع مؤشر مخزون منخفض
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isLow)
                                              Container(
                                                width: 8,
                                                height: 8,
                                                margin: const EdgeInsets.only(right: 8),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            Text(
                                              ing.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: isLow
                                                    ? Colors.red.shade900
                                                    : colorScheme.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // كمية المخزون الحالي
                                      DataCell(
                                        Text(
                                          '${ing.currentStock.toStringAsFixed(1)} ${ing.unitOfMeasurement}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isLow
                                                ? Colors.red.shade700
                                                : colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                      // تكلفة الوحدة
                                      DataCell(
                                        Text('${ing.costPrice.toStringAsFixed(2)} ج.م'),
                                      ),
                                      // القيمة الكلية للمخزون لهذا الصنف
                                      DataCell(
                                        Text(
                                          '${ing.stockValue.toStringAsFixed(2)} ج.م',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                      // قائمة الإجراءات
                                      DataCell(
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _showAddEditDialog(context, ingredient: ing);
                                            } else if (value == 'delete') {
                                              _confirmDelete(context, ing);
                                            } else if (value == 'waste') {
                                              _showRecordWasteDialogForIngredient(context, ing);
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 'waste',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete_sweep_outlined,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text('تسجيل هالك'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit, color: Colors.blue),
                                                  SizedBox(width: 8),
                                                  Text('تعديل البيانات'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete, color: Colors.red),
                                                  SizedBox(width: 8),
                                                  Text('حذف الصنف'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
    final minStockCtrl = TextEditingController(
        text: ingredient?.minStockAlert.toString() ?? '10.0');
    final bloc = context.read<InventoryBloc>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'تعديل بيانات الصنف' : 'إضافة صنف جديد للمخزون'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'اسم الصنف'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: unitCtrl,
                decoration: const InputDecoration(
                  labelText: 'وحدة القياس (قطع، جرام، كيلو...)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: stockCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'الكمية الحالية بالمخزن'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: costCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'سعر تكلفة الوحدة (ج.م)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: minStockCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'حد تنبيه نقص المخزون (الحد الأدنى)',
                  suffixText: 'وحدة',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final doubleStock = double.tryParse(stockCtrl.text) ?? 0.0;
              final doubleCost = double.tryParse(costCtrl.text) ?? 0.0;
              final doubleMinStock = double.tryParse(minStockCtrl.text) ?? 10.0;
              if (isEdit) {
                bloc.add(UpdateIngredientRequested(
                  id: ingredient.id,
                  name: nameCtrl.text,
                  unitOfMeasurement: unitCtrl.text,
                  costPrice: doubleCost,
                  minStockAlert: doubleMinStock,
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
                  minStockAlert: doubleMinStock,
                ));
              }
              Navigator.pop(ctx);
            },
            child: Text(isEdit ? 'تحديث' : 'إضافة'),
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
        title: const Text('تأكيد الحذف؟'),
        content: Text('هل أنت متأكد من رغبتك في حذف الصنف "${ing.name}" نهائياً؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              bloc.add(DeleteIngredientRequested(ing.id));
              Navigator.pop(ctx);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showRecordWasteDialogForIngredient(BuildContext context, IngredientEntity ingredient) {
    final qtyCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('تسجيل هالك لـ ${ingredient.name}'),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'الصنف: ${ingredient.name} (${ingredient.unitOfMeasurement})',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: qtyCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'الكمية الهالكة / Quantity',
                        hintText: 'مثال: 1.5',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesCtrl,
                      decoration: const InputDecoration(
                        labelText: 'السبب / ملاحظات',
                        hintText: 'مثال: تالف أو منتهي الصلاحية',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(ctx),
                  child: const Text('إلغاء'),
                ),
                FilledButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final qty = double.tryParse(qtyCtrl.text) ?? 0.0;
                          if (qty <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('الرجاء إدخال كمية صالحة أكبر من الصفر')),
                            );
                            return;
                          }

                          setState(() {
                            isSaving = true;
                          });

                          try {
                            final session = SessionManager.instance;
                            await getIt<TransactionRepository>().recordWaste(
                              userId: session.currentUserId,
                              notes: notesCtrl.text.isNotEmpty ? notesCtrl.text : 'Recorded via Wastage UI',
                              items: [
                                WasteInput(
                                  ingredientId: ingredient.id,
                                  quantity: qty,
                                ),
                              ],
                            );
                            
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('✓ تم تسجيل الهالك بنجاح!')),
                              );
                              context.read<InventoryBloc>().add(const LoadIngredients());
                              Navigator.pop(ctx);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('خطأ: ${e.toString()}'),
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                ),
                              );
                            }
                          } finally {
                            setState(() {
                              isSaving = false;
                            });
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('تسجيل'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRecordWasteDialog(BuildContext context) {
    final state = context.read<InventoryBloc>().state;
    if (state is! InventoryLoaded || state.ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد أصناف في المخزون لتسجيل الهالك منها.')),
      );
      return;
    }

    final ingredients = state.ingredients;
    IngredientEntity? selectedIngredient = ingredients.first;
    final qtyCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('تسجيل الهالك / Record Waste'),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<IngredientEntity>(
                      value: selectedIngredient,
                      decoration: const InputDecoration(labelText: 'اختر الصنف'),
                      items: ingredients.map((ing) {
                        return DropdownMenuItem(
                          value: ing,
                          child: Text('${ing.name} (${ing.unitOfMeasurement})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedIngredient = val;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: qtyCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'الكمية المستهلكة / Quantity',
                        hintText: 'مثال: 1.5',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesCtrl,
                      decoration: const InputDecoration(
                        labelText: 'ملاحظات (السبب)',
                        hintText: 'مثال: تالف أو منتهي الصلاحية',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(ctx),
                  child: const Text('إلغاء'),
                ),
                FilledButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final qty = double.tryParse(qtyCtrl.text) ?? 0.0;
                          if (qty <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('الرجاء إدخال كمية صالحة أكبر من الصفر')),
                            );
                            return;
                          }
                          if (selectedIngredient == null) return;

                          setState(() {
                            isSaving = true;
                          });

                          try {
                            final session = SessionManager.instance;
                            await getIt<TransactionRepository>().recordWaste(
                              userId: session.currentUserId,
                              notes: notesCtrl.text.isNotEmpty ? notesCtrl.text : 'Recorded via Wastage UI',
                              items: [
                                WasteInput(
                                  ingredientId: selectedIngredient!.id,
                                  quantity: qty,
                                ),
                              ],
                            );
                            
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('✓ تم تسجيل الهالك بنجاح!')),
                              );
                              context.read<InventoryBloc>().add(const LoadIngredients());
                              Navigator.pop(ctx);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('خطأ: ${e.toString()}'),
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                ),
                              );
                            }
                          } finally {
                            setState(() {
                              isSaving = false;
                            });
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('تسجيل'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
