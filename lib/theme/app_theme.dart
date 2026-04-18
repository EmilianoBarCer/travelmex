import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🎨 TravelMex Design System
/// Complete theme configuration with colors, typography, and component styles

class TmColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFFC62300);      // Rich Red
  static const Color primaryDark = Color(0xFF8D1B02);  // Gradient start
  static const Color secondary = Color(0xFF500073);    // Deep Purple
  static const Color accent = Color(0xFFFAD017);       // Gold/Yellow
  static const Color background = Color(0xFFEEF5E8);   // Light Sage

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
}

class TmRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 24.0;    // Cards
  static const double xl = 28.0;    // Featured cards, sheets
  static const double full = 999.0; // Pills, chips
}

class TmShadows {
  static BoxShadow card = BoxShadow(
    color: TmColors.grey300.withValues(alpha: 0.08),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );

  static BoxShadow elevated = BoxShadow(
    color: TmColors.grey300.withValues(alpha: 0.15),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );

  static BoxShadow floating = BoxShadow(
    color: TmColors.grey300.withValues(alpha: 0.12),
    blurRadius: 16,
    offset: const Offset(0, 6),
  );
}

class TmTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: TmColors.primary,
        primary: TmColors.primary,
        secondary: TmColors.secondary,
        surface: TmColors.background,
        onPrimary: TmColors.white,
        onSecondary: TmColors.white,
        onSurface: TmColors.grey900,
      ),

      // Typography
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.sora(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: TmColors.grey900,
        ),
        displayMedium: GoogleFonts.sora(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: TmColors.grey900,
        ),
        displaySmall: GoogleFonts.sora(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: TmColors.grey900,
        ),
        headlineLarge: GoogleFonts.sora(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: TmColors.grey900,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: TmColors.grey800,
        ),
        headlineSmall: GoogleFonts.sora(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: TmColors.grey800,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: TmColors.grey800,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: TmColors.grey700,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: TmColors.grey700,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: TmColors.grey800,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: TmColors.grey700,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: TmColors.grey600,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: TmColors.grey700,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: TmColors.grey600,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: TmColors.grey500,
        ),
      ),

      // Component Themes
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(TmRadius.lg)),
        ),
        color: TmColors.white,
        shadowColor: TmColors.grey300,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TmColors.primary,
          foregroundColor: TmColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TmRadius.lg),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: TmColors.primary,
          side: const BorderSide(color: TmColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TmRadius.lg),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TmColors.grey50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TmRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TmRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TmRadius.md),
          borderSide: const BorderSide(color: TmColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: TmColors.grey400,
          fontSize: 16,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: TmColors.white,
        foregroundColor: TmColors.grey900,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: TmColors.grey900,
        ),
        iconTheme: const IconThemeData(color: TmColors.grey700),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: TmColors.white.withValues(alpha: 0.85),
        selectedItemColor: TmColors.primary,
        unselectedItemColor: TmColors.grey500,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}