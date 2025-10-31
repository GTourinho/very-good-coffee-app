// coverage:ignore-file
import 'package:coffee_app/src/core/design_system/app_colors.dart';
import 'package:coffee_app/src/core/design_system/app_spacing.dart';
import 'package:coffee_app/src/core/design_system/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Coffee roast types for theming
enum CoffeeRoast {
  /// Light roast - bright, creamy, fresh vibe
  lightRoast,

  /// Medium roast - balanced, warm, inviting
  mediumRoast,

  /// Dark roast - bold, rich, cozy feel
  darkRoast,
}

/// {@template app_theme}
/// Centralized theme configuration for the coffee app.
/// Based on coffee roast types for a unique theming experience.
/// {@endtemplate}
class AppTheme {
  const AppTheme._();

  /// Gets the theme based on coffee roast type
  static ThemeData getTheme(CoffeeRoast roast) {
    switch (roast) {
      case CoffeeRoast.lightRoast:
        return lightRoast;
      case CoffeeRoast.mediumRoast:
        return mediumRoast;
      case CoffeeRoast.darkRoast:
        return darkRoast;
    }
  }

  // Light Roast Theme - Fresh, Bright, Creamy ☕
  /// {@macro app_theme}
  static ThemeData get lightRoast {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme - Light Roast
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightRoastPrimary,
        primaryContainer: AppColors.lightRoastAccent,
        secondary: AppColors.lightRoastPrimary,
        secondaryContainer: AppColors.lightRoastAccent,
        surface: AppColors.lightRoastSurface,
        onPrimary: AppColors.grey900,
        onSecondary: AppColors.grey900,
        onSurface: AppColors.grey900,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightRoastPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: AppTextStyles.appBarTitle.copyWith(color: Colors.white),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: AppSpacing.iconMedium,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightRoastPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: AppSpacing.paddingHorizontalMedium +
              AppSpacing.paddingVerticalSmall,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          textStyle: AppTextStyles.buttonText,
          minimumSize: const Size(0, AppSpacing.buttonHeightMedium),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightRoastPrimary,
          side: const BorderSide(color: AppColors.lightRoastPrimary),
          padding: AppSpacing.paddingHorizontalMedium +
              AppSpacing.paddingVerticalSmall,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          textStyle: AppTextStyles.buttonText.copyWith(
            color: AppColors.lightRoastPrimary,
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeightMedium),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightRoastPrimary,
          padding: AppSpacing.paddingHorizontalMedium +
              AppSpacing.paddingVerticalSmall,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          textStyle: AppTextStyles.buttonText.copyWith(
            color: AppColors.lightRoastPrimary,
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeightMedium),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.lightRoastSurface,
        elevation: AppSpacing.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        margin: AppSpacing.marginAllMedium,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.grey800,
        size: AppSpacing.iconMedium,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: AppSizes.dividerNormal,
        space: AppSpacing.sm,
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grey800,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.lightRoastPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        filled: true,
        fillColor: AppColors.lightRoastSurface,
        contentPadding: AppSpacing.paddingHorizontalMedium +
            AppSpacing.paddingVerticalSmall,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.grey500,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightRoastPrimary,
        selectedItemColor: Colors.white,
        unselectedItemColor: AppColors.grey300,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // Medium Roast Theme - Balanced, Warm, Inviting ☕☕
  /// {@macro app_theme}
  static ThemeData get mediumRoast {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme - Medium Roast
      colorScheme: const ColorScheme.light(
        primary: AppColors.mediumRoastPrimary,
        primaryContainer: AppColors.mediumRoastAccent,
        secondary: AppColors.mediumRoastPrimary,
        secondaryContainer: AppColors.mediumRoastAccent,
        surface: AppColors.mediumRoastSurface,
        onSecondary: Colors.white,
        onSurface: AppColors.grey900,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.mediumRoastPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: AppTextStyles.appBarTitle.copyWith(color: Colors.white),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: AppSpacing.iconMedium,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mediumRoastPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: AppSpacing.paddingHorizontalMedium +
              AppSpacing.paddingVerticalSmall,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          textStyle: AppTextStyles.buttonText,
          minimumSize: const Size(0, AppSpacing.buttonHeightMedium),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.mediumRoastSurface,
        elevation: AppSpacing.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        margin: AppSpacing.marginAllMedium,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.grey800,
        size: AppSpacing.iconMedium,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.mediumRoastPrimary,
        selectedItemColor: Colors.white,
        unselectedItemColor: AppColors.grey300,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grey800,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
    );
  }

  // Dark Roast Theme - Bold, Rich, Cozy ☕☕☕
  /// {@macro app_theme}
  static ThemeData get darkRoast {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme - Dark Roast
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkRoastPrimary,
        primaryContainer: AppColors.darkRoastAccent,
        secondary: AppColors.darkRoastAccent,
        secondaryContainer: AppColors.darkRoastPrimary,
        surface: AppColors.darkRoastSurface,
        onPrimary: AppColors.grey900,
        onSecondary: AppColors.grey900,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkRoastBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.appBarTitle.copyWith(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: AppSpacing.iconMedium,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkRoastPrimary,
          foregroundColor: AppColors.grey900,
          elevation: 2,
          padding: AppSpacing.paddingHorizontalMedium +
              AppSpacing.paddingVerticalSmall,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          textStyle: AppTextStyles.buttonText,
          minimumSize: const Size(0, AppSpacing.buttonHeightMedium),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.darkRoastSurface,
        elevation: AppSpacing.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        margin: AppSpacing.marginAllMedium,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: AppSpacing.iconMedium,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: Colors.white,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: Colors.white,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: Colors.white,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: Colors.white,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: Colors.white,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: Colors.white,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: Colors.white,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: Colors.white),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: Colors.white),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.white),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: Colors.white),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: Colors.white),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: Colors.white),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkRoastSurface,
        selectedItemColor: AppColors.darkRoastAccent,
        unselectedItemColor: AppColors.grey400,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkRoastPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
    );
  }

  // Backward compatibility getters
  /// Light theme (defaults to medium roast for balanced experience)
  static ThemeData get light => mediumRoast;

  /// Dark theme (defaults to dark roast)
  static ThemeData get dark => darkRoast;
}
