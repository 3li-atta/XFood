import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xfood_pos/core/di/injection.dart';
import 'package:xfood_pos/core/services/device_config_service.dart';
import 'package:xfood_pos/core/services/lan_sync/lan_client_service.dart';
import 'router.dart';

/// Root widget for the XFood POS application.
class XFoodApp extends StatefulWidget {
  const XFoodApp({super.key});

  @override
  State<XFoodApp> createState() => _XFoodAppState();
}

class _XFoodAppState extends State<XFoodApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Auto-connect client on startup if configured
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final config = getIt<DeviceConfigService>();
        if (!config.isMaster) {
          getIt<LanClientService>().connect();
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      try {
        final config = getIt<DeviceConfigService>();
        if (!config.isMaster) {
          // Instantly trigger reconnect for client/KDS devices when app resumes
          getIt<LanClientService>().connect();
        }
      } catch (_) {
        // Safe check if services are not registered yet
      }
    }
  }

  // ── Brand Colors ──────────────────────────────────────────────────────
  static const Color _primaryBlue = Color(0xFF1E3A8A);
  static const Color _ctaGreen = Color(0xFF10B981);
  static const Color _backgroundGray = Color(0xFFF3F4F6);
  static const Color _cardWhite = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'XFood POS',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryBlue,
          primary: _primaryBlue,
          onPrimary: Colors.white,
          secondary: _ctaGreen,
          onSecondary: Colors.white,
          surface: _cardWhite,
          onSurface: const Color(0xFF1F2937),
          error: const Color(0xFFDC2626),
          brightness: Brightness.light,
        ),

        // Scaffold
        scaffoldBackgroundColor: _backgroundGray,

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: _primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        // Cards
        cardTheme: CardThemeData(
          color: _cardWhite,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // Filled buttons (CTA — Emerald Green)
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _ctaGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Elevated buttons fallback
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _ctaGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // Input fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _primaryBlue, width: 2),
          ),
        ),

        // Navigation Rail
        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: _cardWhite,
          selectedIconTheme: const IconThemeData(color: _primaryBlue),
          unselectedIconTheme: IconThemeData(color: Colors.grey[600]),
          selectedLabelTextStyle: const TextStyle(
            color: _primaryBlue,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          indicatorColor: _primaryBlue.withValues(alpha: 0.12),
        ),

        // Dividers
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE5E7EB),
          thickness: 1,
        ),

        // Chips
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFEFF6FF),
          selectedColor: _primaryBlue.withValues(alpha: 0.15),
          labelStyle: const TextStyle(fontSize: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
