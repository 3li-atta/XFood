import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'database/app_database.dart';
import 'database/seeder.dart';
import 'app/app.dart';
import 'core/utils/auto_backup_manager.dart';

void main() {
  // Use runZonedGuarded to catch ALL uncaught async errors — critical for release mode
  // where debugPrint is a no-op and unhandled errors crash silently.
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Catch Flutter framework errors (rendering, layout, etc.)
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        if (kDebugMode) {
          debugPrint('🔴 FlutterError: ${details.exceptionAsString()}');
        }
      };

      // ── Initialize WorkManager (non-critical — must not block startup) ──
      try {
        await AutoBackupManager.init();
      } catch (_) {
        // WorkManager init failure is non-critical; app should still start.
      }

      // ── Initialize DI (critical) ──
      try {
        await configureDependencies();
        final seeder = DatabaseSeeder(getIt<AppDatabase>());
        await seeder.seed();
      } catch (e) {
        if (kDebugMode) {
          debugPrint('🔴 Initialization error: $e');
        }
      }

      // Always run the app, even if init partially failed.
      runApp(const XFoodApp());
    },
    (error, stack) {
      // This catches any uncaught async error in the entire app.
      if (kDebugMode) {
        debugPrint('🔴 Uncaught error: $error\n$stack');
      }
    },
  );
}
