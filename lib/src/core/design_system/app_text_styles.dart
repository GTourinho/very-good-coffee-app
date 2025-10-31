import 'package:coffee_app/src/core/design_system/app_colors.dart';
import 'package:flutter/material.dart';

/// {@template app_text_styles}
/// Centralized text styles for the coffee app.
/// {@endtemplate}
class AppTextStyles {
  const AppTextStyles._();

  // Display Styles
  /// Large display text style
  static TextStyle get displayLarge => const TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      );

  /// Medium display text style
  static TextStyle get displayMedium => const TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
      );

  /// Small display text style
  static TextStyle get displaySmall => const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      );

  // Headline Styles
  /// Large headline text style
  static TextStyle get headlineLarge => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.25,
      );

  /// Medium headline text style
  static TextStyle get headlineMedium => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.29,
      );

  /// Small headline text style
  static TextStyle get headlineSmall => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33,
      );

  // Title Styles
  /// Large title text style
  static TextStyle get titleLarge => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.27,
      );

  /// Medium title text style
  static TextStyle get titleMedium => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.5,
      );

  /// Small title text style
  static TextStyle get titleSmall => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  // Body Styles
  /// Large body text style
  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      );

  /// Medium body text style
  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  /// Small body text style
  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  // Label Styles
  /// Large label text style
  static TextStyle get labelLarge => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  /// Medium label text style
  static TextStyle get labelMedium => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      );

  /// Small label text style
  static TextStyle get labelSmall => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.27,
      );

  // Coffee App Specific Styles
  /// App bar title text style
  static TextStyle get appBarTitle => headlineSmall.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
      );

  /// Page title text style
  static TextStyle get pageTitle => headlineMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );

  /// Section title text style
  static TextStyle get sectionTitle => titleLarge.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );

  /// Card title text style
  static TextStyle get cardTitle => titleMedium.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      );

  /// Body text style
  static TextStyle get bodyText => bodyMedium.copyWith(
        color: AppColors.onSurface,
      );

  /// Caption text style
  static TextStyle get caption => bodySmall.copyWith(
        color: AppColors.grey600,
      );

  /// Button text style
  static TextStyle get buttonText => labelLarge.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
      );

  /// Error text style
  static TextStyle get errorText => bodyMedium.copyWith(
        color: AppColors.error,
        fontWeight: FontWeight.w500,
      );

  /// Success text style
  static TextStyle get successText => bodyMedium.copyWith(
        color: AppColors.success,
        fontWeight: FontWeight.w500,
      );

  // Helper methods
  /// Helper method to apply colors to text styles
  static TextStyle withColor(TextStyle textStyle, Color color) {
    return textStyle.copyWith(color: color);
  }

  /// Helper method to apply font weight to text styles
  static TextStyle withWeight(TextStyle textStyle, FontWeight fontWeight) {
    return textStyle.copyWith(fontWeight: fontWeight);
  }
}
