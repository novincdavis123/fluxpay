import 'package:flutter/material.dart';

import 'package:fluxpay/app/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'SFPro';

  /// =========================================================
  /// DISPLAY
  /// =========================================================

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.2,
    height: 1.1,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.9,
    height: 1.15,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.2,
  );

  /// =========================================================
  /// HEADINGS
  /// =========================================================

  static const TextStyle headingLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// =========================================================
  /// BODY
  /// =========================================================

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.55,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.2,
  );

  /// =========================================================
  /// AMOUNTS / CURRENCY
  /// =========================================================

  static const TextStyle amountLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w800,
    letterSpacing: -1,
    height: 1.1,
  );

  static const TextStyle amountMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle currencyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -1,
  );

  static const TextStyle currencyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle rateText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.success,
  );

  /// =========================================================
  /// BUTTONS
  /// =========================================================

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  /// =========================================================
  /// LABELS
  /// =========================================================

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
  );

  /// =========================================================
  /// STATUS
  /// =========================================================

  static const TextStyle success = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
  );

  static const TextStyle error = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );

  static const TextStyle warning = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.warning,
  );

  /// =========================================================
  /// THEME HELPERS
  /// =========================================================

  static TextStyle displayLargeStyle(BuildContext context) {
    return displayLarge.copyWith(color: AppColors.getTextPrimary(context));
  }

  static TextStyle displayMediumStyle(BuildContext context) {
    return displayMedium.copyWith(color: AppColors.getTextPrimary(context));
  }

  static TextStyle displaySmallStyle(BuildContext context) {
    return displaySmall.copyWith(color: AppColors.getTextPrimary(context));
  }

  static TextStyle headingLargeStyle(BuildContext context) {
    return headingLarge.copyWith(color: AppColors.getTextPrimary(context));
  }

  static TextStyle headingMediumStyle(BuildContext context) {
    return headingMedium.copyWith(color: AppColors.getTextPrimary(context));
  }

  static TextStyle headingSmallStyle(BuildContext context) {
    return headingSmall.copyWith(color: AppColors.getTextPrimary(context));
  }

  static TextStyle bodyLargeStyle(BuildContext context) {
    return bodyLarge.copyWith(color: AppColors.getTextPrimary(context));
  }

  static TextStyle bodyMediumStyle(BuildContext context) {
    return bodyMedium.copyWith(color: AppColors.getTextSecondary(context));
  }

  static TextStyle bodySmallStyle(BuildContext context) {
    return bodySmall.copyWith(color: AppColors.getTextMuted(context));
  }

  static TextStyle captionStyle(BuildContext context) {
    return caption.copyWith(color: AppColors.getTextMuted(context));
  }

  static TextStyle amountLargeStyle(BuildContext context) {
    return amountLarge.copyWith(color: AppColors.getTextPrimary(context));
  }

  static TextStyle amountMediumStyle(BuildContext context) {
    return amountMedium.copyWith(color: AppColors.getTextPrimary(context));
  }

  static TextStyle currencyLargeStyle(BuildContext context) {
    return currencyLarge.copyWith(color: AppColors.getTextPrimary(context));
  }

  static TextStyle currencyMediumStyle(BuildContext context) {
    return currencyMedium.copyWith(color: AppColors.getTextPrimary(context));
  }

  static TextStyle buttonTextStyle(BuildContext context) {
    return buttonText.copyWith(color: Colors.white);
  }

  static TextStyle buttonSmallStyle(BuildContext context) {
    return buttonSmall.copyWith(color: Colors.white);
  }

  static TextStyle labelStyle(BuildContext context) {
    return label.copyWith(color: AppColors.getTextMuted(context));
  }

  static TextStyle overlineStyle(BuildContext context) {
    return overline.copyWith(color: AppColors.getTextMuted(context));
  }
}
