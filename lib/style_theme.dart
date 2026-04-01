import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xffD8A32B);

  static const Color primaryShade = Color(0xffF3E4C1);
  static const Color backgroundMain = Color(0xffF5F5EE);
  static const Color textDark = Color(0xff484C52);

  static const Color borderColor = Color(0xFFDBDBDB);

  static const Color textgrey = Color(0xFF808080);
}

class StyleTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      // secondary: AppColors.secondaryGold,
      surface: AppColors.backgroundMain,
      tertiary: AppColors.textDark,
    ),

    scaffoldBackgroundColor: AppColors.backgroundMain,
  );
}
