import 'package:flutter/material.dart';

abstract final class AppColors {
  static const cream = Color(0xFFFAF7EF);
  static const paper = Color(0xFFFFFFFF);
  static const navy = Color(0xFF222C3B);
  static const mutedInk = Color(0xFF536074);
  static const border = Color(0xFFDEDCD5);
  static const yellow = Color(0xFFF4D77B);
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      primary: AppColors.navy,
      onPrimary: AppColors.paper,
      surface: AppColors.paper,
      onSurface: AppColors.navy,
    ),
    fontFamily: 'Segoe UI',
    fontFamilyFallback: const ['Microsoft YaHei', 'Noto Sans SC', 'sans-serif'],
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 36, height: 1.22, fontWeight: FontWeight.w700),
      headlineSmall: TextStyle(fontSize: 24, height: 1.33, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, height: 1.43),
    ).apply(bodyColor: AppColors.navy, displayColor: AppColors.navy),
  );
}
