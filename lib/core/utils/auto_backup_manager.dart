import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../di/injection.dart';
import '../../features/backup/domain/services/backup_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await configureDependencies();

      final backupService = getIt<BackupService>();
      final fileId = await backupService.backupDatabase();
      return Future.value(fileId != null);
    } catch (e) {
      return Future.value(false);
    }
  });
}

/// مدير النسخ الاحتياطي التلقائي بالخلفية باستخدام WorkManager.
class AutoBackupManager {
  static const String taskUniqueName = 'xfood_auto_backup';
  static const String taskName = 'xfood_auto_backup_task';

  static const String prefEnabledKey = 'auto_backup_enabled';
  static const String prefFrequencyKey = 'auto_backup_frequency';

  /// تهيئة WorkManager مع الـ Callback Dispatcher
  static Future<void> init() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  /// تحميل إعدادات النسخ الاحتياطي التلقائي من SharedPreferences
  static Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(prefEnabledKey) ?? false;
    final frequency = prefs.getString(prefFrequencyKey) ?? 'Daily';
    return {
      'enabled': enabled,
      'frequency': frequency,
    };
  }

  /// حفظ إعدادات النسخ الاحتياطي التلقائي وجدولة المهمة
  static Future<void> saveSettings(bool enabled, String frequency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefEnabledKey, enabled);
    await prefs.setString(prefFrequencyKey, frequency);
    await applyScheduling(enabled, frequency);
  }

  /// تطبيق جدولة المهمة بالخلفية
  static Future<void> applyScheduling(bool enabled, String frequency) async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    // إلغاء أي مهام مجدولة مسبقاً لمنع التكرار
    await Workmanager().cancelByUniqueName(taskUniqueName);

    if (!enabled) return;

    Duration duration;
    switch (frequency) {
      case 'Daily':
        duration = const Duration(hours: 24);
        break;
      case 'Every 3 days':
        duration = const Duration(days: 3);
        break;
      case 'Weekly':
        duration = const Duration(days: 7);
        break;
      default:
        duration = const Duration(hours: 24);
    }

    await Workmanager().registerPeriodicTask(
      taskUniqueName,
      taskName,
      frequency: duration,
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      constraints: Constraints(
        networkType: NetworkType.connected, // تنفيذ المهمة فقط عند الاتصال بالإنترنت
      ),
    );
  }
}
