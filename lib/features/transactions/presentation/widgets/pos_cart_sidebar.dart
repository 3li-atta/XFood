import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../database/app_database.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/session_manager.dart';
import '../../../meals/domain/repositories/meal_repository.dart';
import '../bloc/pos_bloc.dart';
import 'checkout_dialog.dart';

/// Right sidebar: Cart with items, totals, and checkout button.
class PosCartSidebar extends StatelessWidget {
  const PosCartSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          left: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        children: [
          // Cart header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.shopping_cart, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Current Order',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                const Spacer(),
                BlocBuilder<PosBloc, PosState>(
                  builder: (context, state) {
                    if (!state.hasItems) return const SizedBox.shrink();
                    return IconButton(
                      icon: const Icon(Icons.delete_sweep),
                      tooltip: 'Clear cart',
                      onPressed: () =>
                          context.read<PosBloc>().add(const ClearCart()),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Order Type & Table Selector
          BlocBuilder<PosBloc, PosState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: colorScheme.surface,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ChoiceChip(
                          label: const Text('طاولة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          selected: state.orderType == 'dine_in',
                          selectedColor: colorScheme.primary,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: state.orderType == 'dine_in' ? Colors.white : colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: state.orderType == 'dine_in' ? Colors.transparent : colorScheme.outlineVariant,
                            ),
                          ),
                          onSelected: (val) {
                            if (val) {
                              context.read<PosBloc>().add(const ChangeOrderType('dine_in'));
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('سفري', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          selected: state.orderType == 'takeaway',
                          selectedColor: colorScheme.primary,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: state.orderType == 'takeaway' ? Colors.white : colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: state.orderType == 'takeaway' ? Colors.transparent : colorScheme.outlineVariant,
                            ),
                          ),
                          onSelected: (val) {
                            if (val) {
                              context.read<PosBloc>().add(const ChangeOrderType('takeaway'));
                            }
                          },
                        ),
                        ChoiceChip(
                          label: const Text('توصيل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          selected: state.orderType == 'delivery',
                          selectedColor: colorScheme.primary,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: state.orderType == 'delivery' ? Colors.white : colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: state.orderType == 'delivery' ? Colors.transparent : colorScheme.outlineVariant,
                            ),
                          ),
                          onSelected: (val) {
                            if (val) {
                              context.read<PosBloc>().add(const ChangeOrderType('delivery'));
                            }
                          },
                        ),
                      ],
                    ),
                    if (state.orderType == 'dine_in') ...[
                      const SizedBox(height: 8),
                      // Table selector button
                      FutureBuilder<RestaurantTable?>(
                        future: state.tableId != null
                            ? getIt<AppDatabase>().tableDao.getTableById(state.tableId!)
                            : Future.value(null),
                        builder: (context, tableSnap) {
                          final tableName = tableSnap.data?.name ?? 'اختر الطاولة (Select Table)';
                          return SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _showTableSelectionDialog(context),
                              icon: Icon(Icons.table_restaurant, size: 16, color: colorScheme.primary),
                              label: Text(
                                tableName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: colorScheme.primary, width: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1),

          // Cart items
          Expanded(
            child: BlocBuilder<PosBloc, PosState>(
              builder: (context, state) {
                if (!state.hasItems) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_shopping_cart,
                            size: 48,
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.3)),
                        const SizedBox(height: 8),
                        Text('Tap a meal to add it',
                            style: TextStyle(
                                color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.cartItems.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = state.cartItems[index];
                    return _CartItemTile(item: item);
                  },
                );
              },
            ),
          ),

          // Totals and checkout
          const Divider(height: 1),
          BlocBuilder<PosBloc, PosState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          '${state.totalAmount.toStringAsFixed(2)} ج.م',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: state.hasItems
                                ? () => _parkCurrentOrder(context, state)
                                : null,
                            icon: const Icon(Icons.pause, size: 16),
                            label: const Text('تعليق الطلب', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.orange.withValues(alpha: 0.12),
                              foregroundColor: Colors.orange.shade800,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: () => _showParkedOrdersDialog(context),
                            icon: const Icon(Icons.playlist_play, size: 16),
                            label: const Text('الطلبات المعلقة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.blue.withValues(alpha: 0.12),
                              foregroundColor: Colors.blue.shade800,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: state.hasItems &&
                                state.status != PosStatus.processing
                            ? () => showCheckoutDialog(context, state.totalAmount)
                            : null,
                        icon: state.status == PosStatus.processing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.check_circle),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            state.status == PosStatus.processing
                                ? 'جاري الحفظ...'
                                : 'إتمام البيع',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981), // Emerald green
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
                          disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Persistent Bottom Cart bar for mobile layout.
class PersistentBottomCart extends StatelessWidget {
  const PersistentBottomCart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        if (!state.hasItems) {
          return const SizedBox.shrink(); // Hide if cart is empty
        }

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            border: Border(
              top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${state.totalAmount.toStringAsFixed(2)} ج.م',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (modalContext) {
                        return FractionallySizedBox(
                          heightFactor: 0.8,
                          child: BlocProvider.value(
                            value: context.read<PosBloc>(),
                            child: const CartModalContent(),
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Badge.count(
                    count: state.cartItems.fold<double>(0, (sum, item) => sum + item.quantity).toInt(),
                    child: const Icon(Icons.shopping_cart),
                  ),
                  label: const Text(
                    'View Cart / Checkout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Cart contents for the bottom sheet modal.
class CartModalContent extends StatelessWidget {
  const CartModalContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<PosBloc, PosState>(
      listener: (context, state) {
        if (state.status == PosStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('Current Order',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
                  const Spacer(),
                  if (state.hasItems)
                    IconButton(
                      icon: const Icon(Icons.delete_sweep),
                      tooltip: 'Clear cart',
                      onPressed: () =>
                          context.read<PosBloc>().add(const ClearCart()),
                    ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: state.hasItems
                  ? ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: state.cartItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = state.cartItems[index];
                        return _CartItemTile(item: item);
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_shopping_cart,
                              size: 48,
                              color: colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.3)),
                          const SizedBox(height: 8),
                          Text('Tap a meal to add it',
                              style: TextStyle(
                                  color: colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
            ),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                        '${state.totalAmount.toStringAsFixed(2)} ج.م',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: state.hasItems &&
                              state.status != PosStatus.processing
                          ? () => showCheckoutDialog(context, state.totalAmount, isBottomSheet: true)
                          : null,
                      icon: state.status == PosStatus.processing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.check_circle),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          state.status == PosStatus.processing
                              ? 'Processing...'
                              : 'Complete Sale',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Individual cart item row with quantity controls.
class _CartItemTile extends StatelessWidget {
  final CartItem item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Item Name and Line Total
          Row(
            children: [
              Expanded(
                child: Text(
                  item.meal.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${item.lineTotal.toStringAsFixed(2)} ج.م',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Row 2: Price Breakdowns and Quantity Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${item.meal.sellingPrice.toStringAsFixed(2)} ج.م × ${item.quantity.toStringAsFixed(0)}',
                style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      context.read<PosBloc>().add(UpdateCartItemQuantity(
                            mealId: item.meal.id,
                            newQuantity: item.quantity - 1,
                          ));
                    },
                  ),
                  InkWell(
                    onTap: () => _showQuantityInputDialog(context, item.meal.id, item.quantity),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        item.quantity.toStringAsFixed(0),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      context.read<PosBloc>().add(UpdateCartItemQuantity(
                            mealId: item.meal.id,
                            newQuantity: item.quantity + 1,
                          ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showTableSelectionDialog(BuildContext parentCtx) {
  showDialog(
    context: parentCtx,
    builder: (dialogCtx) {
      return AlertDialog(
        title: const Text('اختر الطاولة (Select Table)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 400,
          height: 350,
          child: FutureBuilder<List<RestaurantTable>>(
            future: getIt<AppDatabase>().tableDao.getAllTables(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('لا توجد طاولات مضافة'));
              }
              
              final tables = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  final table = tables[index];
                  final isOccupied = table.status == 'occupied';
                  return InkWell(
                    onTap: () {
                      parentCtx.read<PosBloc>().add(SelectTable(table.id));
                      Navigator.pop(dialogCtx);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Card(
                      color: isOccupied ? Colors.orange.withValues(alpha: 0.15) : Colors.green.withValues(alpha: 0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isOccupied ? Colors.orange : Colors.green,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.table_restaurant,
                            color: isOccupied ? Colors.orange : Colors.green,
                            size: 24,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            table.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isOccupied ? 'مشغولة' : 'متاحة',
                            style: TextStyle(
                              fontSize: 10,
                              color: isOccupied ? Colors.orange.shade800 : Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('إلغاء'),
          ),
        ],
      );
    },
  );
}

void _parkCurrentOrder(BuildContext context, PosState state) async {
  try {
    final userId = SessionManager.instance.currentUserId;
    final cartList = state.cartItems.map((c) => {
      'meal_id': c.meal.id,
      'quantity': c.quantity,
      'meal_name': c.meal.name,
      'meal_price': c.meal.sellingPrice,
      'meal_category': c.meal.category,
      'meal_image_url': null,
    }).toList();
    
    final cartJson = jsonEncode(cartList);
    
    await getIt<AppDatabase>().pendingOrderDao.insertPendingOrder(
      PendingOrdersCompanion.insert(
        userId: userId,
        tableId: Value(state.tableId),
        orderType: state.orderType,
        cartItemsJson: cartJson,
      ),
    );

    if (state.tableId != null) {
      await getIt<AppDatabase>().tableDao.updateTableStatus(state.tableId!, 'occupied');
    }

    if (context.mounted) {
      context.read<PosBloc>().add(const ClearCart());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ تم تعليق الطلب بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء تعليق الطلب: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

void _showParkedOrdersDialog(BuildContext parentCtx) {
  showDialog(
    context: parentCtx,
    builder: (dialogCtx) {
      return AlertDialog(
        title: const Text('الطلبـات المعلقة (Held Orders)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 450,
          height: 400,
          child: FutureBuilder<List<PendingOrder>>(
            future: getIt<AppDatabase>().pendingOrderDao.getAllPendingOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('لا توجد طلبات معلقة حالياً'));
              }
              
              final orders = snapshot.data!;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final items = jsonDecode(order.cartItemsJson) as List<dynamic>;
                  final itemsCount = items.length;
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        'طلب #${order.id} - ${order.orderType == 'dine_in' ? "طاولة" : order.orderType == 'takeaway' ? "سفري" : "توصيل"}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'عدد الأصناف: $itemsCount | تاريخ التعليق: ${DateFormat('HH:mm - yyyy/MM/dd').format(order.createdAt)}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.restore, color: Colors.green),
                            tooltip: 'استرجاع الطلب',
                            onPressed: () async {
                              await _restoreParkedOrder(parentCtx, order);
                              Navigator.pop(dialogCtx);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'حذف المعلق',
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (c) => AlertDialog(
                                  title: const Text('حذف الطلب المعلق؟'),
                                  content: const Text('هل أنت متأكد من رغبتك في حذف هذا الطلب المعلق نهائياً؟'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(c, false),
                                      child: const Text('إلغاء'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(c, true),
                                      child: const Text('حذف', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await getIt<AppDatabase>().pendingOrderDao.deletePendingOrder(order.id);
                                if (order.tableId != null) {
                                  await getIt<AppDatabase>().tableDao.updateTableStatus(order.tableId!, 'available');
                                }
                                Navigator.pop(dialogCtx);
                                _showParkedOrdersDialog(parentCtx);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('إغلاق'),
          ),
        ],
      );
    },
  );
}

Future<void> _restoreParkedOrder(BuildContext context, PendingOrder order) async {
  try {
    final items = jsonDecode(order.cartItemsJson) as List<dynamic>;
    
    context.read<PosBloc>().add(const ClearCart());
    
    context.read<PosBloc>().add(ChangeOrderType(order.orderType));
    if (order.tableId != null) {
      context.read<PosBloc>().add(SelectTable(order.tableId));
    }
    
    final mealRepo = getIt<MealRepository>();
    for (final item in items) {
      final mealId = item['meal_id'] as int;
      final quantity = (item['quantity'] as num).toDouble();
      
      final meal = await mealRepo.getMealById(mealId);
      if (context.mounted) {
        context.read<PosBloc>().add(AddToCart(meal));
        if (quantity > 1) {
          context.read<PosBloc>().add(UpdateCartItemQuantity(mealId: mealId, newQuantity: quantity));
        }
      }
    }
    
    await getIt<AppDatabase>().pendingOrderDao.deletePendingOrder(order.id);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ تم استرجاع الطلب بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء استرجاع الطلب: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

void _showQuantityInputDialog(BuildContext context, int mealId, double currentQuantity) {
  final controller = TextEditingController(text: currentQuantity.toStringAsFixed(0));
  showDialog(
    context: context,
    builder: (dialogCtx) {
      return AlertDialog(
        title: const Text('تعديل الكمية (Enter Quantity)', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPresetQtyButton(controller, '5'),
                  _buildPresetQtyButton(controller, '10'),
                  _buildPresetQtyButton(controller, '20'),
                  _buildPresetQtyButton(controller, '50'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text) ?? 1.0;
              context.read<PosBloc>().add(UpdateCartItemQuantity(
                    mealId: mealId,
                    newQuantity: val,
                  ));
              Navigator.pop(dialogCtx);
            },
            child: const Text('تحديث'),
          ),
        ],
      );
    },
  );
}

Widget _buildPresetQtyButton(TextEditingController controller, String value) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      minimumSize: Size.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    onPressed: () {
      controller.text = value;
    },
    child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}
