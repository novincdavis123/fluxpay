import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundblack,
    useMaterial3: true,
  );
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundwhite,
    useMaterial3: true,
  );
}
