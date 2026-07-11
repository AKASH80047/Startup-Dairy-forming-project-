import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/enum/theme_type.dart';

class AppTheme {
  static ThemeData getTheme(ThemeType type) {
    switch (type) {
      case ThemeType.dark:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF52B788),
          secondary: const Color(0xFF74C69D),
          tertiary: const Color(0xFFF4D35E),
          background: const Color(0xFF0F1412),
          surface: const Color(0xFF1B221E),
          textPrimary: const Color(0xFFE2EBE7),
          textSecondary: const Color(0xFF8B9E96),
          divider: const Color(0xFF2D3A34),
        );
      case ThemeType.gold:
        return _buildTheme(
          brightness: Brightness.light,
          primary: const Color(0xFF8C6A15),
          secondary: const Color(0xFFB59449),
          tertiary: const Color(0xFFE5BA53),
          background: const Color(0xFFFAF7F0),
          surface: const Color(0xFFFFFDF9),
          textPrimary: const Color(0xFF2C2518),
          textSecondary: const Color(0xFF70654D),
          divider: const Color(0xFFE8E1CE),
        );
      case ThemeType.light:
        return _buildTheme(
          brightness: Brightness.light,
          primary: const Color(0xFF1B4332),
          secondary: const Color(0xFF40916C),
          tertiary: const Color(0xFFD4AF37),
          background: const Color(0xFFF9F6F0),
          surface: const Color(0xFFFFFFFF),
          textPrimary: const Color(0xFF1A2621),
          textSecondary: const Color(0xFF52615B),
          divider: const Color(0xFFE2EBE7),
        );
    }
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required Color background,
    required Color surface,
    required Color textPrimary,
    required Color textSecondary,
    required Color divider,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: surface,
        error: Colors.redAccent,
        onPrimary: surface,
        onSecondary: surface,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      dividerTheme: DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness == Brightness.light ? Brightness.dark : Brightness.light,
          statusBarBrightness: brightness == Brightness.light ? Brightness.light : Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shadowColor: textSecondary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: divider,
            width: 0.5,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static ThemeData get lightTheme => getTheme(ThemeType.light);
}
