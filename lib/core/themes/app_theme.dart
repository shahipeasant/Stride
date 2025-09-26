import 'package:flutter/material.dart';

class AppColors {
  static const Color lightBg = Color(0xFFCCD5A1); // stronger, earthy background
  static const Color primary = Color(0xFF5A493B); // deeper, stronger brown/green
  static const Color secondary = Color(0xFFADC178); // softer green
  static const Color accent = Color(0xFFA98467); // warm brown accent
  static const Color dark = Color(0xFF3D3A34); // almost-black text
}

class AppTheme{
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.lightBg,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightBg,
      onPrimary: AppColors.dark,
      onSecondary: AppColors.dark,
      onSurface: AppColors.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Color(0xFFF5F5F0),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Color(0xFFF5F5F0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
  );
}