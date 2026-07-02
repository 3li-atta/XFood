import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'database/app_database.dart';
import 'database/seeder.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection (database + DAOs + repos + blocs).
  await configureDependencies();

  // Seed default admin user on first launch.
  final seeder = DatabaseSeeder(getIt<AppDatabase>());
  await seeder.seed();

  runApp(const XFoodApp());
}
