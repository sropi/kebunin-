import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class KebuninTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: KebuninColors.warmCream,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: KebuninColors.forestGreen,
        onPrimary: KebuninColors.white,
        secondary: KebuninColors.leafGreen,
        onSecondary: KebuninColors.white,
        tertiary: KebuninColors.carrotOrange,
        onTertiary: KebuninColors.white,
        error: KebuninColors.error,
        onError: KebuninColors.white,
        surface: KebuninColors.warmCream,
        onSurface: KebuninColors.charcoal,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          color: KebuninColors.charcoal,
          fontWeight: FontWeight.w800,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: KebuninColors.forestGreen,
          fontWeight: FontWeight.w800,
          fontSize: 26,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: KebuninColors.charcoal,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: KebuninColors.charcoal,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: KebuninColors.charcoal,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: KebuninColors.charcoal,
          fontSize: 15,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: KebuninColors.mutedGrey,
          fontSize: 13,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: KebuninColors.white,
        foregroundColor: KebuninColors.charcoal,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: KebuninColors.charcoal,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: KebuninColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KebuninRadius.md),
          side: const BorderSide(color: KebuninColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KebuninColors.forestGreen,
          foregroundColor: KebuninColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KebuninRadius.md),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: KebuninColors.forestGreen,
          side: const BorderSide(color: KebuninColors.forestGreen, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KebuninRadius.md),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KebuninColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KebuninRadius.md),
          borderSide: const BorderSide(color: KebuninColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KebuninRadius.md),
          borderSide: const BorderSide(color: KebuninColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KebuninRadius.md),
          borderSide: const BorderSide(color: KebuninColors.forestGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(KebuninRadius.md),
          borderSide: const BorderSide(color: KebuninColors.error),
        ),
        hintStyle: const TextStyle(
          color: KebuninColors.mutedGrey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: KebuninColors.white,
        selectedItemColor: KebuninColors.forestGreen,
        unselectedItemColor: KebuninColors.mutedGrey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: KebuninColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
