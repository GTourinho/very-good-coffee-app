// coverage:ignore-file
// We can ignore this here because we don't need a
// comment for each individual property
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// {@template app_colors}
/// Centralized color palette for the coffee app.
/// {@endtemplate}
class AppColors {
  const AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF6F4E37); // Coffee Brown
  static const Color primaryVariant = Color(0xFF5A3E2B);
  static const Color onPrimary = Colors.white;

  // Secondary Colors
  static const Color secondary = Color(0xFFD2B48C); // Tan
  static const Color secondaryVariant = Color(0xFFC19A6B);
  static const Color onSecondary = Color(0xFF2C1810);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color onBackground = Color(0xFF1A1A1A);
  static const Color onSurface = Color(0xFF2C2C2C);

  // Error Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color errorBackground = Color(0xFFFFEBEE);
  static const Color onError = Colors.white;

  // Success Colors
  static const Color success = Color(0xFF388E3C);
  static const Color successBackground = Color(0xFFE8F5E8);
  static const Color onSuccess = Colors.white;

  // Info Colors
  static const Color info = Color(0xFF1976D2);
  static const Color infoBackground = Color(0xFFE3F2FD);
  static const Color onInfo = Colors.white;

  // Neutral Colors
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Coffee Roast-specific Colors
  // Light Roast Theme Colors (Brightest)
  static const Color lightRoastPrimary = Color(
    0xFFC4956C,
  ); // Light coffee brown
  static const Color lightRoastBackground = Color(
    0xFFFFFBF5,
  ); // Lightest cream
  static const Color lightRoastSurface = Color(
    0xFFFFF5E6,
  ); // Very light tan
  static const Color lightRoastAccent = Color(
    0xFFE5C9A0,
  ); // Light caramel

  // Medium Roast Theme Colors (Balanced)
  static const Color mediumRoastPrimary = Color(
    0xFF9B7653,
  ); // Medium coffee brown
  static const Color mediumRoastBackground = Color(
    0xFFF5EFE7,
  ); // Warm cream
  static const Color mediumRoastSurface = Color(
    0xFFEFE3D0,
  ); // Medium tan
  static const Color mediumRoastAccent = Color(
    0xFFD4B896,
  ); // Caramel

  // Dark Roast Theme Colors (Darkest - with better contrast)
  static const Color darkRoastPrimary = Color(
    0xFFB8956F,
  ); // Lighter coffee for contrast
  static const Color darkRoastBackground = Color(
    0xFF1C1410,
  ); // Very dark brown
  static const Color darkRoastSurface = Color(
    0xFF2D2318,
  ); // Dark surface
  static const Color darkRoastAccent = Color(
    0xFFC4A076,
  ); // Light accent for contrast

  // Legacy coffee colors (kept for compatibility)
  static const Color coffeeLight = Color(
    0xFFA67C52,
  );
  static const Color coffeeMedium = Color(0xFF6F4E37);
  static const Color coffeeDark = Color(0xFF3E2723);
  static const Color cream = Color(0xFFF5DEB3);
  static const Color foam = Color(0xFFFFF8E1);

  // UI Element Colors
  static const Color divider = grey200;
  static const Color shadow = Color(0x1A000000);
  static const Color favorite = Color(0xFFE91E63);
  static const Color favoriteBorder = Color(0xFFF06292);
}
