import 'package:go_router/go_router.dart';
import '../core/utils/session_manager.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/password_change_page.dart';
import '../features/transactions/presentation/pages/pos_page.dart';
import '../features/inventory/presentation/pages/inventory_page.dart';
import '../features/meals/presentation/pages/meals_page.dart';
import '../features/transactions/presentation/pages/transactions_page.dart';
import '../features/shifts/presentation/pages/shift_page.dart';
import '../features/procurement/presentation/pages/purchase_page.dart';
import '../features/treasury/presentation/pages/treasury_page.dart';
import '../features/backup/presentation/pages/backup_page.dart';

/// Application router configuration using GoRouter.
///
/// Includes:
/// 1. Auth redirect guard — all routes except `/login` require active session.
/// 2. Role-based redirect guard (V-07) — admin routes require admin privileges.
/// 3. Force password change redirect guard (V-12) — redirect to password change if needed.
final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final isLoggedIn = SessionManager.instance.isLoggedIn;
    final isLoginRoute = state.matchedLocation == '/login';
    final mustChangePassword = SessionManager.instance.currentUser?.mustChangePassword ?? false;
    final isChangePasswordRoute = state.matchedLocation == '/change-password';

    // Not logged in and trying to access protected route → redirect to login
    if (!isLoggedIn && !isLoginRoute) {
      return '/login';
    }

    // Already logged in and on login page → redirect to POS or change password
    if (isLoggedIn && isLoginRoute) {
      return mustChangePassword ? '/change-password' : '/pos';
    }

    // Enforce first login password change (V-12)
    if (isLoggedIn && mustChangePassword && !isChangePasswordRoute) {
      return '/change-password';
    }

    // Redirect to POS if already changed default password
    if (isLoggedIn && !mustChangePassword && isChangePasswordRoute) {
      return '/pos';
    }

    // Role-based route guard enforcement (V-07)
    final adminOnlyRoutes = [
      '/inventory',
      '/meals',
      '/transactions',
      '/purchases',
      '/treasury',
      '/backup',
    ];
    final isAdminRoute = adminOnlyRoutes.contains(state.matchedLocation);
    if (isLoggedIn && isAdminRoute && !SessionManager.instance.isAdmin) {
      return '/pos'; // cashier restricted to POS & Shifts
    }

    // No redirect needed
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/change-password',
      name: 'change-password',
      builder: (context, state) => const PasswordChangePage(),
    ),
    GoRoute(
      path: '/pos',
      name: 'pos',
      builder: (context, state) => const PosPage(),
    ),
    GoRoute(
      path: '/inventory',
      name: 'inventory',
      builder: (context, state) => const InventoryPage(),
    ),
    GoRoute(
      path: '/meals',
      name: 'meals',
      builder: (context, state) => const MealsPage(),
    ),
    GoRoute(
      path: '/transactions',
      name: 'transactions',
      builder: (context, state) => const TransactionsPage(),
    ),
    GoRoute(
      path: '/shifts',
      name: 'shifts',
      builder: (context, state) => const ShiftPage(),
    ),
    GoRoute(
      path: '/purchases',
      name: 'purchases',
      builder: (context, state) => const PurchasePage(),
    ),
    GoRoute(
      path: '/treasury',
      name: 'treasury',
      builder: (context, state) => const TreasuryPage(),
    ),
    GoRoute(
      path: '/backup',
      name: 'backup',
      builder: (context, state) => const BackupPage(),
    ),
  ],
);
