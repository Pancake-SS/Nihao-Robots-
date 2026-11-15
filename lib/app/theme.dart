import 'package:flutter/material.dart';

/// Visual tokens only. Storage, curriculum and audio use their existing APIs.
abstract final class AppColors {
  static const cream = Color(0xFFE9E4D9);
  static const paper = Color(0xFFFFFEFA);
  static const navy = Color(0xFF182845);
  static const deepNavy = Color(0xFF101F3B);
  static const mutedInk = Color(0xFF617084);
  static const border = Color(0xFFE9DDCA);
  static const yellow = Color(0xFFFFD275);
  static const gold = Color(0xFFECAF45);
  static const peach = Color(0xFFFFE3CC);
  static const sky = Color(0xFFD5ECFB);
  static const blue = Color(0xFF9DCBF0);
  static const leaf = Color(0xFF9ECD91);
  static const paleGreen = Color(0xFFE8F4DF);
  static const lilac = Color(0xFFECE8FA);
}

ThemeData buildTheme() {
  const radius = BorderRadius.all(Radius.circular(18));
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      primary: AppColors.navy,
      onPrimary: AppColors.paper,
      secondary: AppColors.gold,
      surface: AppColors.paper,
      onSurface: AppColors.navy,
    ),
    fontFamily: 'Segoe UI',
    fontFamilyFallback: const [
      'Nunito',
      'Microsoft YaHei',
      'Noto Sans SC',
      'sans-serif',
    ],
    dividerColor: AppColors.border,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.navy,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Segoe UI',
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.navy,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.paper,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: AppColors.navy, width: 1.8),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 48),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(
          fontFamily: 'Segoe UI',
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        foregroundColor: AppColors.navy,
        side: const BorderSide(color: AppColors.border, width: 1.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(
          fontFamily: 'Segoe UI',
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(64, 44),
        foregroundColor: AppColors.navy,
        textStyle: const TextStyle(
          fontFamily: 'Segoe UI',
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.cream,
      selectedColor: AppColors.sky,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.gold,
      linearTrackColor: AppColors.border,
      linearMinHeight: 9,
    ),
    textTheme: const TextTheme(
      labelLarge: TextStyle(
        fontFamily: 'Segoe UI',
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: TextStyle(
        fontSize: 35,
        height: 1.16,
        fontWeight: FontWeight.w800,
        letterSpacing: -.7,
      ),
      headlineMedium: TextStyle(
        fontSize: 27,
        height: 1.20,
        fontWeight: FontWeight.w800,
      ),
      headlineSmall: TextStyle(
        fontSize: 23,
        height: 1.28,
        fontWeight: FontWeight.w800,
      ),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 16, height: 1.48),
      bodyMedium: TextStyle(fontSize: 14, height: 1.45),
    ).apply(bodyColor: AppColors.navy, displayColor: AppColors.navy),
  );
}
