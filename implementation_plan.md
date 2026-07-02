# XFood POS — Complete Remaining Tasks to Make App Production-Ready

## Overview

After a thorough review of the entire XFood POS codebase (56 files), the app has a solid foundation with Clean Architecture, Drift database with code generation, and Bloc state management. However, several critical issues prevent it from running correctly. This plan addresses **all remaining tasks** to make the app fully functional.

---

## Proposed Changes

### Phase 1: Fix Build-Breaking Issues

#### 1.1 Fix Seeder Import Paths (Build Breaker)

#### [MODIFY] [seeder.dart](file:///d:/XFood/lib/database/seeder.dart)

The seeder file is inside `lib/database/` but imports use `../database/` which resolves incorrectly. Fix all relative imports:

```diff
-import '../database/app_database.dart';
-import '../database/daos/user_dao.dart';
-import '../core/utils/password_hasher.dart';
-import '../database/tables/users_table.dart';
+import 'app_database.dart';
+import 'daos/user_dao.dart';
+import '../core/utils/password_hasher.dart';
+import 'tables/users_table.dart';
```

---

### Phase 2: Auth State Persistence Across Pages

Currently, after login the `AuthBloc` is scoped to the `LoginPage` only. Once navigated to POS, the user info (ID, role) is lost. The POS page hardcodes `userId: 1`.

#### 2.1 Create Global Auth Session Manager

#### [NEW] [session_manager.dart](file:///d:/XFood/lib/core/utils/session_manager.dart)

A simple singleton to hold the current logged-in user across the app:

- Stores the current `UserEntity` after login
- Provides `currentUser`, `currentUserId`, `isAdmin` getters
- `clear()` on logout

#### 2.2 Wire Session Into Login Flow

#### [MODIFY] [auth_bloc.dart](file:///d:/XFood/lib/features/auth/presentation/bloc/auth_bloc.dart)

- On successful login → store user in `SessionManager`
- On logout → clear session

#### 2.3 Use Real User ID in POS

#### [MODIFY] [pos_page.dart](file:///d:/XFood/lib/features/transactions/presentation/pages/pos_page.dart)

- Replace hardcoded `userId: 1` with `SessionManager.instance.currentUserId`

---

### Phase 3: Route Protection

#### [MODIFY] [router.dart](file:///d:/XFood/lib/app/router.dart)

- Add `redirect` guard: if user is not logged in (session is empty), redirect to `/login`
- After logout, redirect to `/login`

---

### Phase 4: Fix Deprecated APIs

#### [MODIFY] [pos_page.dart](file:///d:/XFood/lib/features/transactions/presentation/pages/pos_page.dart)

- Replace `Color.withOpacity()` with `Color.withValues(alpha: ...)` (Flutter 3.x deprecation)

---

### Phase 5: Enhance Transaction Details

#### [MODIFY] [transactions_page.dart](file:///d:/XFood/lib/features/transactions/presentation/pages/transactions_page.dart)

Currently transaction details show raw IDs (`Meal #3`, `Ingredient #5`) instead of actual names. Fix by:
- Fetching meal/ingredient names from repositories when displaying details
- Showing actual names in the detail dialog

---

### Phase 6: Complete Database Seeder with Sample Data

#### [MODIFY] [seeder.dart](file:///d:/XFood/lib/database/seeder.dart)

Add sample ingredients, meals, and recipes so the app is immediately usable after first launch:
- 5-6 sample ingredients (Beef Patty, Bun, Lettuce, Tomato, Cheese, Chicken)
- 3-4 sample meals (Burger, Chicken Sandwich, Salad, Cheese Burger)
- Recipe links between them
- This lets testers immediately try the POS screen

---

### Phase 7: Inventory & Meals Bloc (Architecture Completeness)

The inventory and meals pages call repositories directly instead of going through Blocs/UseCases. While functional, this violates the Clean Architecture pattern used everywhere else.

#### 7.1 Inventory Feature Bloc

#### [NEW] [inventory_bloc.dart](file:///d:/XFood/lib/features/inventory/presentation/bloc/inventory_bloc.dart)
#### [NEW] [inventory_event.dart](file:///d:/XFood/lib/features/inventory/presentation/bloc/inventory_event.dart)  
#### [NEW] [inventory_state.dart](file:///d:/XFood/lib/features/inventory/presentation/bloc/inventory_state.dart)

Events: `LoadIngredients`, `AddIngredient`, `UpdateIngredient`, `DeleteIngredient`, `UpdateStock`

#### [MODIFY] [inventory_page.dart](file:///d:/XFood/lib/features/inventory/presentation/pages/inventory_page.dart)

Refactor to use `InventoryBloc` instead of direct repo calls.

#### 7.2 Meals Feature Bloc

#### [NEW] [meals_bloc.dart](file:///d:/XFood/lib/features/meals/presentation/bloc/meals_bloc.dart)
#### [NEW] [meals_event.dart](file:///d:/XFood/lib/features/meals/presentation/bloc/meals_event.dart)
#### [NEW] [meals_state.dart](file:///d:/XFood/lib/features/meals/presentation/bloc/meals_state.dart)

Events: `LoadMeals`, `CreateMeal`, `UpdateMeal`, `DeactivateMeal`, `LoadRecipe`, `SaveRecipe`

#### [MODIFY] [meals_page.dart](file:///d:/XFood/lib/features/meals/presentation/pages/meals_page.dart)

Refactor to use `MealsBloc` instead of direct repo calls.

#### 7.3 Register New Blocs in DI

#### [MODIFY] [injection.dart](file:///d:/XFood/lib/core/di/injection.dart)

Register `InventoryBloc` and `MealsBloc` as factories.

---

### Phase 8: POS Page — Refresh Meals After Sale

#### [MODIFY] [pos_page.dart](file:///d:/XFood/lib/features/transactions/presentation/pages/pos_page.dart)

The menu grid loads meals once in `initState`. After a sale is completed, the grid doesn't refresh. Add a mechanism to reload the menu after successful sale (so the user can continue selling).

---

### Phase 9: Admin-Only Navigation Guards

#### [MODIFY] [pos_page.dart](file:///d:/XFood/lib/features/transactions/presentation/pages/pos_page.dart)

- Hide the Inventory, Meals, and History navigation options for cashier users
- Only admin can access management pages
- Cashier only sees the POS screen

---

## Summary of All Files to Create/Modify

| Action | File | Purpose |
|--------|------|---------|
| FIX | `seeder.dart` | Fix import paths + add sample data |
| NEW | `session_manager.dart` | Global auth session singleton |
| MODIFY | `auth_bloc.dart` | Store user in session on login |
| MODIFY | `router.dart` | Add auth redirect guard |
| MODIFY | `pos_page.dart` | Real userId, role-based nav, refresh, deprecations |
| MODIFY | `transactions_page.dart` | Show names instead of IDs |
| MODIFY | `injection.dart` | Register new blocs |
| NEW | `inventory_bloc.dart` + event + state | Inventory state management |
| NEW | `meals_bloc.dart` + event + state | Meals state management |
| MODIFY | `inventory_page.dart` | Use bloc instead of direct repo |
| MODIFY | `meals_page.dart` | Use bloc instead of direct repo |

---

## Verification Plan

### Automated Tests
```bash
C:\flutter\bin\flutter.bat analyze
```

### Manual Verification
- App launches without errors
- Login with `admin/admin123` works
- POS page shows seeded meals
- Sale completes with stock deduction
- Inventory page shows ingredients with updated stock
- Transaction history shows completed sales with meal names
- Route guard prevents unauthenticated access
- Logout redirects to login
