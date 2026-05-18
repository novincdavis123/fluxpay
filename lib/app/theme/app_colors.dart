import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// =========================================================
  /// DARK THEME
  /// =========================================================

  static const Color backgroundblack = Color(0xFF0B1120);

  static const Color scaffoldDark = Color(0xFF0B1120);

  static const Color cardDark = Color(0xFF111827);

  static const Color surfaceDark = Color(0xFF172033);

  static const Color elevatedDark = Color(0xFF1E293B);

  static const Color inputFillDark = Color(0xFF1A2436);

  static const Color borderDark = Color(0xFF243041);

  static const Color dividerDark = Color(0xFF1E293B);

  static const Color textPrimaryDark = Colors.white;

  static const Color textSecondaryDark = Color(0xFF94A3B8);

  static const Color textMutedDark = Color(0xFF64748B);

  /// =========================================================
  /// LIGHT THEME
  /// =========================================================

  static const Color backgroundwhite = Color(0xFFF8FAFC);

  static const Color scaffoldLight = Color(0xFFF8FAFC);

  static const Color cardLight = Colors.white;

  static const Color surfaceLight = Color(0xFFFFFFFF);

  static const Color elevatedLight = Color(0xFFF1F5F9);

  static const Color inputFillLight = Color(0xFFF1F5F9);

  static const Color borderLight = Color(0xFFE2E8F0);

  static const Color dividerLight = Color(0xFFE5E7EB);

  static const Color textPrimaryLight = Color(0xFF0F172A);

  static const Color textSecondaryLight = Color(0xFF475569);

  static const Color textMutedLight = Color(0xFF64748B);

  /// =========================================================
  /// BRAND COLORS
  /// =========================================================

  static const Color primary = Color(0xFF4F46E5);

  static const Color primaryLight = Color(0xFF6366F1);

  static const Color secondary = Color(0xFF06B6D4);

  static const Color accent = Color(0xFF8B5CF6);

  /// =========================================================
  /// STATUS COLORS
  /// =========================================================

  static const Color success = Color(0xFF22C55E);

  static const Color warning = Color(0xFFF59E0B);

  static const Color error = Color(0xFFEF4444);

  static const Color info = Color(0xFF3B82F6);

  static const Color refunded = Color(0xFF8B5CF6);

  static const Color pending = Color(0xFFF59E0B);

  static const Color processing = Color(0xFF3B82F6);

  /// =========================================================
  /// GRADIENTS
  /// =========================================================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,

    colors: [Color(0xFF6366F1), Color(0xFF4F46E5), Color(0xFF4338CA)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,

    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,

    colors: [Color(0xFF172033), Color(0xFF111827)],
  );

  /// =========================================================
  /// HELPERS
  /// =========================================================

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getBackground(BuildContext context) {
    return isDark(context) ? backgroundblack : backgroundwhite;
  }

  static Color getScaffold(BuildContext context) {
    return isDark(context) ? scaffoldDark : scaffoldLight;
  }

  static Color getCardColor(BuildContext context) {
    return isDark(context) ? cardDark : cardLight;
  }

  static Color getSurfaceColor(BuildContext context) {
    return isDark(context) ? surfaceDark : surfaceLight;
  }

  static Color getElevatedColor(BuildContext context) {
    return isDark(context) ? elevatedDark : elevatedLight;
  }

  static Color getInputFill(BuildContext context) {
    return isDark(context) ? inputFillDark : inputFillLight;
  }

  static Color getBorderColor(BuildContext context) {
    return isDark(context) ? borderDark : borderLight;
  }

  static Color getDividerColor(BuildContext context) {
    return isDark(context) ? dividerDark : dividerLight;
  }

  static Color getTextPrimary(BuildContext context) {
    return isDark(context) ? textPrimaryDark : textPrimaryLight;
  }

  static Color getTextSecondary(BuildContext context) {
    return isDark(context) ? textSecondaryDark : textSecondaryLight;
  }

  static Color getTextMuted(BuildContext context) {
    return isDark(context) ? textMutedDark : textMutedLight;
  }

  /// =========================================================
  /// TRANSPARENT HELPERS
  /// =========================================================

  static const Color white05 = Color(0x0DFFFFFF);

  static const Color white08 = Color(0x14FFFFFF);

  static const Color white10 = Colors.white10;

  static const Color white12 = Colors.white12;

  static const Color white24 = Colors.white24;

  static const Color black04 = Color(0x0A000000);

  static const Color black05 = Color(0x0D000000);

  static const Color black08 = Color(0x14000000);

  static const Color black12 = Color(0x1F000000);

  /// =========================================================
  /// LEGACY SUPPORT
  /// =========================================================

  /// Keeps old code working
  static Color get card => cardDark;
}
