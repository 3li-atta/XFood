import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/session_manager.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';

/// Left navigation rail with route links.
/// Admin sees all destinations; cashier only sees POS.
class PosNavigationRail extends StatefulWidget {
  const PosNavigationRail({super.key});

  @override
  State<PosNavigationRail> createState() => _PosNavigationRailState();
}

class _PosNavigationRailState extends State<PosNavigationRail> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final session = SessionManager.instance;

    final items = [
      _NavItem(icon: Icons.point_of_sale, label: 'القائمة', route: '/pos'),
      _NavItem(icon: Icons.access_time, label: 'الورديات', route: '/shifts'),
    ];

    if (session.hasPermission('manage_inventory')) {
      items.add(_NavItem(icon: Icons.inventory_2, label: 'المخزون', route: '/inventory'));
    }
    if (session.hasPermission('manage_meals')) {
      items.add(_NavItem(icon: Icons.restaurant_menu, label: 'الوجبات', route: '/meals'));
    }
    if (session.hasPermission('view_transactions')) {
      items.add(_NavItem(icon: Icons.receipt_long, label: 'السجل', route: '/transactions'));
    }
    if (session.hasPermission('view_reports')) {
      items.add(_NavItem(icon: Icons.analytics, label: 'التقارير', route: '/reports'));
    }
    if (session.hasPermission('manage_purchases')) {
      items.add(_NavItem(icon: Icons.shopping_bag, label: 'المشتريات', route: '/purchases'));
    }
    if (session.hasPermission('manage_treasury')) {
      items.add(_NavItem(icon: Icons.account_balance_wallet, label: 'الخزينة', route: '/treasury'));
    }
    if (session.hasPermission('manage_backup')) {
      items.add(_NavItem(icon: Icons.cloud_sync, label: 'النسخ الاحتياطي', route: '/backup'));
    }
    items.add(_NavItem(icon: Icons.settings_ethernet, label: 'إعدادات الأجهزة', route: '/settings/device'));

    final currentRoute = GoRouterState.of(context).uri.path;
    int selectedIndex = 0;
    for (int i = 0; i < items.length; i++) {
      if (items[i].route == currentRoute) {
        selectedIndex = i;
        break;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: _isExpanded ? 220 : 80,
      color: colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: _isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                if (_isExpanded) const SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.menu, color: colorScheme.primary, size: 28),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
                if (_isExpanded) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        session.currentUser?.username ?? 'نظام البيع',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      if (item.route != currentRoute) {
                        context.go(item.route);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: _isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                          if (_isExpanded) ...[
                            const SizedBox(width: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () async {
                getIt<AuthBloc>().add(const LogoutRequested());
                
                SessionManager.instance.clear();

                if (context.mounted) {
                  await Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: _isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.redAccent, size: 24),
                    if (_isExpanded) ...[
                      const SizedBox(width: 16),
                      const Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
