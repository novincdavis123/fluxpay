import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  /// =========================================================
  /// LIGHT THEME
  /// =========================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.backgroundwhite,

    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surfaceLight,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,

      iconTheme: IconThemeData(color: AppColors.textPrimaryLight),

      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),

    cardColor: AppColors.cardLight,

    dividerColor: AppColors.borderLight,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor: AppColors.inputFillLight,

      hintStyle: const TextStyle(color: AppColors.textMutedLight),

      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),

        borderSide: const BorderSide(color: AppColors.borderLight),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),

        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimaryLight),

      bodyMedium: TextStyle(color: AppColors.textSecondaryLight),
    ),

    iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
  );

  /// =========================================================
  /// DARK THEME
  /// =========================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.backgroundblack,

    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surfaceDark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,

      iconTheme: IconThemeData(color: AppColors.textPrimaryDark),

      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),

    cardColor: AppColors.cardDark,

    dividerColor: AppColors.borderDark,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor: AppColors.inputFillDark,

      hintStyle: const TextStyle(color: AppColors.textMutedDark),

      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),

        borderSide: const BorderSide(color: AppColors.borderDark),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),

        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimaryDark),

      bodyMedium: TextStyle(color: AppColors.textSecondaryDark),
    ),

    iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
  );
}
