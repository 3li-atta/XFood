import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/pos_bloc.dart';
import '../../../meals/domain/entities/meal_entity.dart';
import '../../../meals/domain/repositories/meal_repository.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/session_manager.dart';

import '../../../shifts/presentation/bloc/shift_bloc.dart';
import '../../../../core/services/update_service.dart';
import '../../../../core/presentation/widgets/update_dialog.dart';

/// POS Screen — main cashier interface with menu grid + cart sidebar.
class PosPage extends StatelessWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<PosBloc>()),
        BlocProvider(create: (_) => getIt<ShiftBloc>()..add(CheckActiveShift(session.currentUserId))),
      ],
      child: const _PosView(),
    );
  }
}

class _PosView extends StatefulWidget {
  const _PosView();

  @override
  State<_PosView> createState() => _PosViewState();
}

class _PosViewState extends State<_PosView> {
  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  void _checkForUpdates() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final updateService = UpdateService();
      final updateInfo = await updateService.checkForUpdate();
      if (updateInfo != null && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => UpdateDialog(updateInfo: updateInfo),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocListener<PosBloc, PosState>(
      listener: (context, state) {
        if (state.status == PosStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✓ Sale completed successfully!'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        } else if (state.status == PosStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Sale failed'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: BlocBuilder<ShiftBloc, ShiftState>(
        builder: (context, shiftState) {
          if (shiftState.status == ShiftStatus.initial ||
              (shiftState.status == ShiftStatus.loading &&
                  shiftState.activeShift == null)) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (shiftState.activeShift == null) {
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Card(
                    margin: const EdgeInsets.all(32),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_outline, size: 64, color: Colors.orange),
                          const SizedBox(height: 16),
                          const Text(
                            'يجب فتح الوردية أولاً للوصول إلى المبيعات\n(An active shift must be opened first to access sales)',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () => context.go('/shifts'),
                            icon: const Icon(Icons.add),
                            label: const Text('Go to Shift Management / فتح وردية'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          
          // Active shift exists, render main POS view
          if (isMobile) {
            return Scaffold(
              body: const SafeArea(
                child: Row(
                  children: [
                    // Left: Navigation rail
                    _NavigationRail(),
                    // Right: Menu grid (Expanded, taking all remaining width)
                    Expanded(child: _MenuGrid()),
                  ],
                ),
              ),
              bottomNavigationBar: const _PersistentBottomCart(),
            );
          } else {
            return Scaffold(
              body: const SafeArea(
                child: Row(
                  children: [
                    // Left: Navigation rail
                    _NavigationRail(),
                    // Center: Menu grid (meals)
                    Expanded(flex: 3, child: _MenuGrid()),
                    // Right: Cart sidebar
                    SizedBox(
                      width: 320,
                      child: _CartSidebar(),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

/// Persistent Bottom Cart bar for mobile layout.
class _PersistentBottomCart extends StatelessWidget {
  const _PersistentBottomCart();

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
                      '\$${state.totalAmount.toStringAsFixed(2)}',
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
                            child: const _CartModalContent(),
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
class _CartModalContent extends StatelessWidget {
  const _CartModalContent();

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
                        '\$${state.totalAmount.toStringAsFixed(2)}',
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
                          ? () {
                              context.read<PosBloc>().add(
                                    CompleteSale(
                                      userId: SessionManager
                                          .instance.currentUserId,
                                    ),
                                  );
                            }
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

/// Left navigation rail with route links.
/// Admin sees all destinations; cashier only sees POS.
class _NavigationRail extends StatelessWidget {
  const _NavigationRail();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final session = SessionManager.instance;

    // Build destinations based on role
    final destinations = <NavigationRailDestination>[
      const NavigationRailDestination(
        icon: Icon(Icons.point_of_sale_outlined),
        selectedIcon: Icon(Icons.point_of_sale),
        label: Text('POS'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.access_time_outlined),
        selectedIcon: Icon(Icons.access_time),
        label: Text('Shifts'),
      ),
    ];

    if (session.isAdmin) {
      destinations.addAll(const [
        NavigationRailDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2),
          label: Text('Stock'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.restaurant_menu_outlined),
          selectedIcon: Icon(Icons.restaurant_menu),
          label: Text('Meals'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: Text('History'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag),
          label: Text('Purchases'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet),
          label: Text('Treasury'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.cloud_sync_outlined),
          selectedIcon: Icon(Icons.cloud_sync),
          label: Text('Backup'),
        ),
      ]);
    }

    return NavigationRail(
      selectedIndex: 0,
      backgroundColor: colorScheme.surface,
      onDestinationSelected: (index) {
        if (session.isAdmin) {
          switch (index) {
            case 0:
              break; // Already on POS
            case 1:
              context.go('/shifts');
              break;
            case 2:
              context.go('/inventory');
              break;
            case 3:
              context.go('/meals');
              break;
            case 4:
              context.go('/transactions');
              break;
            case 5:
              context.go('/purchases');
              break;
            case 6:
              context.go('/treasury');
              break;
            case 7:
              context.go('/backup');
              break;
          }
        } else {
          switch (index) {
            case 0:
              break; // POS
            case 1:
              context.go('/shifts');
              break;
          }
        }
      },
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(Icons.restaurant, size: 32, color: colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              session.currentUser?.username ?? '',
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                SessionManager.instance.clear();
                context.go('/login');
              },
            ),
          ),
        ),
      ),
      destinations: destinations,
    );
  }
}

/// Center: Grid of available meals from the menu.
class _MenuGrid extends StatefulWidget {
  const _MenuGrid();

  @override
  State<_MenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends State<_MenuGrid> {
  Future<List<MealEntity>>? _mealsFuture;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  void _loadMeals() {
    setState(() {
      _mealsFuture = getIt<MealRepository>().getActiveMeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<PosBloc, PosState>(
      listenWhen: (prev, curr) =>
          prev.status != PosStatus.success && curr.status == PosStatus.success,
      listener: (context, state) {
        // Refresh meals grid after a successful sale
        _loadMeals();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with category filter
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Menu', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                // Category filter chips
                FutureBuilder<List<MealEntity>>(
                  future: _mealsFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    final categories = snapshot.data!
                        .map((m) => m.category)
                        .toSet()
                        .toList();
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('All'),
                            selected: _selectedCategory == null,
                            onSelected: (_) =>
                                setState(() => _selectedCategory = null),
                            showCheckmark: false,
                            selectedColor: const Color(0xFF1E3A8A),
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: _selectedCategory == null ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                            side: BorderSide(
                              color: _selectedCategory == null ? Colors.transparent : const Color(0xFFD1D5DB),
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
                                selectedColor: const Color(0xFF1E3A8A),
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                                side: BorderSide(
                                  color: isSelected ? Colors.transparent : const Color(0xFFD1D5DB),
                                  width: 1,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Meal grid
          Expanded(
            child: FutureBuilder<List<MealEntity>>(
              future: _mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

                var meals = snapshot.data!;
                if (_selectedCategory != null) {
                  meals = meals
                      .where((m) => m.category == _selectedCategory)
                      .toList();
                }

                final screenWidth = MediaQuery.of(context).size.width;
                final crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 1000 ? 3 : 4);
                final childAspectRatio = screenWidth < 600 ? 1.3 : 1.2;

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: meals.length,
                  itemBuilder: (context, index) =>
                      _MealCard(meal: meals[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual meal card in the grid.
class _MealCard extends StatelessWidget {
  final MealEntity meal;
  const _MealCard({required this.meal});

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => context.read<PosBloc>().add(AddToCart(meal)),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fastfood_rounded,
                size: isMobile ? 32 : 40,
                color: colorScheme.primary,
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
                '\$${meal.sellingPrice.toStringAsFixed(2)}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 13 : 16,
                ),
              ),
              const SizedBox(height: 4),
              if (screenWidth > 450)
                Chip(
                  label: Text(meal.category,
                      style: TextStyle(fontSize: isMobile ? 9 : 10)),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Right sidebar: Cart with items, totals, and checkout button.
class _CartSidebar extends StatelessWidget {
  const _CartSidebar();

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
                          '\$${state.totalAmount.toStringAsFixed(2)}',
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
                            ? () {
                                context.read<PosBloc>().add(
                                      CompleteSale(
                                        userId: SessionManager
                                            .instance.currentUserId,
                                      ),
                                    );
                              }
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
              );
            },
          ),
        ],
      ),
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
                '\$${item.lineTotal.toStringAsFixed(2)}',
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
                '\$${item.meal.sellingPrice.toStringAsFixed(2)} × ${item.quantity.toStringAsFixed(0)}',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      item.quantity.toStringAsFixed(0),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
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
