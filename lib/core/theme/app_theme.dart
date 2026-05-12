import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Palette ndop — inspired by the royal Bamiléké textile (indigo + cream + gold).
// All hex values are defined once here; widgets reference AppColors, never raw hex.
abstract final class AppColors {
  // Shared (same in light and dark)
  static const amberGold = Color(0xFFC4922A);   // cauris, market badges, today highlight

  // Light mode
  static const cream = Color(0xFFF8F3E6);        // scaffold background
  static const white = Color(0xFFFFFFFF);         // card surfaces
  static const indigoNight = Color(0xFF1A2F6E);  // primary, AppBar
  static const indigoLight = Color(0xFF2E4DA0);  // secondary, Grand Marché badge
  static const anthracite = Color(0xFF1C1C1E);   // body text

  // Dark mode
  static const darkBackground = Color(0xFF0D1A3E); // scaffold background
  static const darkSurface = Color(0xFF1A2F6E);    // card/AppBar surface (same as indigoNight by design)
}

ThemeData buildLightTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.indigoNight,
      secondary: AppColors.indigoLight,
      tertiary: AppColors.amberGold,
      surface: AppColors.white,
      onPrimary: AppColors.cream,
      onSurface: AppColors.anthracite,
    ),
    scaffoldBackgroundColor: AppColors.cream,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.indigoNight,
      foregroundColor: AppColors.cream,
      elevation: 0,
      // titleTextStyle requis en M3 : AppBar ignore foregroundColor pour le titre
      // et utilise textTheme.titleLarge avec onSurface par défaut.
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.cream,
      ),
    ),
    // NavigationBar (M3) will replace this in F2 — kept here for fallback compatibility.
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.indigoNight,
      selectedItemColor: AppColors.amberGold,
      unselectedItemColor: AppColors.cream,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.indigoNight,
      indicatorColor: AppColors.amberGold.withValues(alpha: 0.2),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.amberGold);
        }
        return const IconThemeData(color: AppColors.cream);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(color: AppColors.amberGold, fontSize: 12);
        }
        return const TextStyle(color: AppColors.cream, fontSize: 12);
      }),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.white,
      elevation: 1,
    ),
  );

  // TextTheme is applied via copyWith because google_fonts wraps the base styles —
  // it must receive the base TextStyle to inherit size/weight from Material defaults.
  return base.copyWith(textTheme: _buildTextTheme(base.textTheme));
}

ThemeData buildDarkTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.indigoLight,
      secondary: AppColors.indigoNight,
      tertiary: AppColors.amberGold,
      surface: AppColors.darkSurface,
      onPrimary: AppColors.cream,
      onSurface: AppColors.cream,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.cream,
      elevation: 0,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.cream,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.amberGold,
      unselectedItemColor: AppColors.cream,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      indicatorColor: AppColors.amberGold.withValues(alpha: 0.2),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.amberGold);
        }
        return const IconThemeData(color: AppColors.cream);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(color: AppColors.amberGold, fontSize: 12);
        }
        return const TextStyle(color: AppColors.cream, fontSize: 12);
      }),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.darkSurface,
      elevation: 1,
    ),
  );

  return base.copyWith(textTheme: _buildTextTheme(base.textTheme));
}

// Playfair Display → titles and Nguemba day names (large display).
// Inter → all UI text, body, labels.
// Colors are NOT set here — M3 derives them from colorScheme.onSurface automatically.
TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    displayLarge: GoogleFonts.playfairDisplay(
      textStyle: base.displayLarge,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      textStyle: base.displayMedium,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: GoogleFonts.playfairDisplay(
      textStyle: base.headlineLarge,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.playfairDisplay(
      textStyle: base.titleLarge,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.inter(
      textStyle: base.titleMedium,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.inter(textStyle: base.bodyLarge),
    bodyMedium: GoogleFonts.inter(textStyle: base.bodyMedium),
    bodySmall: GoogleFonts.inter(textStyle: base.bodySmall),
    labelLarge: GoogleFonts.inter(
      textStyle: base.labelLarge,
      fontWeight: FontWeight.w600,
    ),
  );
}
