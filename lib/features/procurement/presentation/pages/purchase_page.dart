import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/purchase_bloc.dart';
import '../../domain/entities/purchase_invoice_entity.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../../../../core/entities/ingredient_entity.dart';
import '../../../inventory/domain/repositories/inventory_repository.dart';
import '../../../shifts/presentation/bloc/shift_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/session_manager.dart';

class PurchasePage extends StatelessWidget {
  const PurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<PurchaseBloc>()..add(const LoadPurchases()),
        ),
        BlocProvider(
          create: (_) => getIt<ShiftBloc>()..add(CheckActiveShift(session.currentUserId)),
        ),
      ],
      child: const _PurchaseView(),
    );
  }
}

class _PurchaseView extends StatelessWidget {
  const _PurchaseView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Procurement (فاتورة المشتريات)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pos'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PurchaseBloc>().add(const LoadPurchases()),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateInvoiceDialog(context),
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('New Invoice (فاتورة جديدة)'),
      ),
      body: BlocConsumer<PurchaseBloc, PurchaseState>(
        listener: (context, state) {
          if (state is PurchaseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
              ),
            );
          } else if (state is PurchaseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('✓ Purchase Invoice processed successfully!'),
                backgroundColor: colorScheme.primary,
              ),
            );
            context.read<PurchaseBloc>().add(const LoadPurchases());
          }
        },
        builder: (context, state) {
          if (state is PurchaseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PurchaseLoaded) {
            final invoices = state.invoices;
            if (invoices.isEmpty) {
              return const Center(
                child: Text('No purchase invoices recorded yet.'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final inv = invoices[index];
                final isVoided = inv.isVoided;
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showInvoiceDetails(context, inv),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: isVoided ? Colors.grey : colorScheme.primary,
                            size: 36,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        inv.invoiceNumber,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isVoided) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'VOIDED',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Supplier: ${inv.supplierName ?? "General"} • Date: ${DateFormat.yMd().add_jm().format(inv.createdAt)}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${inv.totalAmount.toStringAsFixed(2)} ج.م',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isVoided ? Colors.grey : colorScheme.primary,
                                  decoration: isVoided ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.info_outline, size: 20),
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(4),
                                    onPressed: () => _showInvoiceDetails(context, inv),
                                  ),
                                  if (!isVoided && SessionManager.instance.isAdmin) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 20),
                                      tooltip: 'Void Invoice',
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(4),
                                      onPressed: () => _confirmVoidInvoice(context, inv),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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

  void _showInvoiceDetails(BuildContext context, PurchaseInvoiceEntity inv) async {
    final items = await getIt<PurchaseRepository>().getItemsForInvoice(inv.id);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Invoice Details - ${inv.invoiceNumber}'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Supplier: ${inv.supplierName ?? "General"}'),
              Text('Date: ${DateFormat.yMd().add_jm().format(inv.createdAt)}'),
              Text('Status: ${inv.status.toUpperCase()}'),
              const Divider(height: 24),
              const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (itemCtx, idx) {
                    final it = items[idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('${it.ingredientName} (x${it.quantity})')),
                          Text('${it.unitCost.toStringAsFixed(2)} ج.م / unit'),
                          const SizedBox(width: 16),
                          Text('${it.lineTotal.toStringAsFixed(2)} ج.م', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${inv.totalAmount.toStringAsFixed(2)} ج.م',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(ctx).colorScheme.primary, fontSize: 18)),
                ],
              ),
              if (inv.notes != null) ...[
                const SizedBox(height: 12),
                Text('Notes: ${inv.notes!}', style: const TextStyle(fontStyle: FontStyle.italic)),
              ]
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _confirmVoidInvoice(BuildContext context, PurchaseInvoiceEntity inv) {
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text('إلغاء الفاتورة؟ (Void Invoice?)'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Are you sure you want to void invoice ${inv.invoiceNumber}? This will reverse stock addition and refund treasury balance.'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: reasonController,
                    decoration: const InputDecoration(
                      labelText: 'سبب الإلغاء (Void Reason) *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'الرجاء إدخال سبب الإلغاء';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              FilledButton(
                onPressed: reasonController.text.trim().isNotEmpty
                    ? () {
                        if (formKey.currentState!.validate()) {
                          context.read<PurchaseBloc>().add(VoidPurchaseInvoiceRequested(
                                invoiceId: inv.id,
                                reason: reasonController.text.trim(),
                              ));
                          Navigator.pop(ctx);
                        }
                      }
                    : null,
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Void Invoice'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCreateInvoiceDialog(BuildContext parentContext) async {
    final ingredients = await getIt<InventoryRepository>().getAllIngredients();
    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text('Please add ingredients to inventory first!')),
      );
      return;
    }

    final supplierController = TextEditingController();
    final notesController = TextEditingController();

    final List<PurchaseItemInputEntity> cart = [];

    showDialog(
      context: parentContext,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setState) {
            double total = cart.fold(0.0, (sum, i) => sum + i.quantity * i.unitCost);

            return AlertDialog(
              title: const Text('Create Purchase Invoice'),
              content: SizedBox(
                width: 600,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: supplierController,
                        decoration: const InputDecoration(labelText: 'Supplier Name (المنشأ / المورد)'),
                      ),
                      TextField(
                        controller: notesController,
                        decoration: const InputDecoration(labelText: 'Notes / ملاحظات'),
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Items List', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Add Item'),
                            onPressed: () => _showAddItemToInvoiceDialog(context, ingredients, (item) {
                              setState(() {
                                cart.add(item);
                              });
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (cart.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text('No items added. Add items bought.', style: TextStyle(color: Colors.grey)),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cart.length,
                          itemBuilder: (itemCtx, idx) {
                            final c = cart[idx];
                            final ingName = ingredients.firstWhere((ing) => ing.id == c.ingredientId).name;
                            return ListTile(
                              title: Text(ingName),
                              subtitle: Text('${c.quantity} units @ ${c.unitCost.toStringAsFixed(2)} ج.م'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${(c.quantity * c.unitCost).toStringAsFixed(2)} ج.م', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        cart.removeAt(idx);
                                      });
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('${total.toStringAsFixed(2)} ج.م',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
                FilledButton(
                  onPressed: cart.isNotEmpty
                      ? () {
                          final shiftState = parentContext.read<ShiftBloc>().state;
                          int? shiftId;
                          if (shiftState.activeShift != null) {
                            shiftId = shiftState.activeShift!.id;
                          }

                          parentContext.read<PurchaseBloc>().add(
                                CreatePurchaseInvoiceRequested(
                                  userId: SessionManager.instance.currentUserId,
                                  shiftId: shiftId,
                                  supplierName: supplierController.text.isNotEmpty ? supplierController.text : null,
                                  notes: notesController.text.isNotEmpty ? notesController.text : null,
                                  items: cart,
                                ),
                              );
                          Navigator.pop(dialogCtx);
                        }
                      : null,
                  child: const Text('Save Invoice'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddItemToInvoiceDialog(BuildContext context, List<IngredientEntity> ingredients, Function(PurchaseItemInputEntity) onAdd) {
    IngredientEntity? selectedIng = ingredients.first;
    final qtyController = TextEditingController();
    final costController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (stateContext, setState) => AlertDialog(
          title: const Text('Add Procurement Line Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<IngredientEntity>(
                value: selectedIng,
                items: ingredients
                    .map((i) => DropdownMenuItem(value: i, child: Text(i.name)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedIng = val;
                  });
                },
                decoration: const InputDecoration(labelText: 'Select Ingredient'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtyController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Quantity bought'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: costController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: r'Unit Cost Price ($)'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final qty = double.tryParse(qtyController.text) ?? 0.0;
                final cost = double.tryParse(costController.text) ?? 0.0;
                if (qty > 0 && cost >= 0 && selectedIng != null) {
                  onAdd(PurchaseItemInputEntity(
                    ingredientId: selectedIng!.id,
                    quantity: qty,
                    unitCost: cost,
                  ));
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add to list'),
            )
          ],
        ),
      ),
    );
  }
}
