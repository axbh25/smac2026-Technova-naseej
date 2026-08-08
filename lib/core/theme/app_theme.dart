import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final ColorScheme colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.accent,
          onSecondary: AppColors.onPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          outline: AppColors.border,
          error: AppColors.error,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          height: 44 / 36,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 44 / 32,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 24 / 16,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 28 / 18,
          color: AppColors.textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 24 / 16,
          color: AppColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 24 / 16,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 24 / 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: TextStyle(
          color: AppColors.onPrimary,
          fontSize: 14,
          height: 20 / 14,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
