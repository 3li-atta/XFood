import 'package:flutter/material.dart';
import 'router.dart';

/// Root widget for the XFood POS application.
class XFoodApp extends StatelessWidget {
  const XFoodApp({super.key});

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
