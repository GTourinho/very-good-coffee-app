// We can ignore this here because we don't need a 
// comment for each individual property
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// {@template app_spacing}
/// Centralized spacing and size values for the coffee app.
/// {@endtemplate}
class AppSpacing {
  const AppSpacing._();

  // Base spacing unit (4px)
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  // Specific spacing values
  static const double spacing2 = 8;
  static const double spacing4 = 16;
  static const double spacing8 = 32;
  static const double spacing12 = 48;
  static const double spacing16 = 64;
  static const double spacing20 = 80;
  static const double spacing24 = 96;

  // Padding values
  static const double paddingTiny = 4;
  static const double paddingSmall = 8;
  static const double paddingMedium = 16;
  static const double paddingLarge = 24;
  static const double paddingXLarge = 32;

  // Margin values
  static const double marginTiny = 4;
  static const double marginSmall = 8;
  static const double marginMedium = 16;
  static const double marginLarge = 24;
  static const double marginXLarge = 32;

  // Border radius values
  static const double radiusSmall = 4;
  static const double radiusMedium = 8;
  static const double radiusLarge = 12;
  static const double radiusXLarge = 16;
  static const double radiusXXLarge = 24;

  // Icon sizes
  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double iconXLarge = 48;

  // Button dimensions
  static const double buttonHeightSmall = 32;
  static const double buttonHeightMedium = 40;
  static const double buttonHeightLarge = 48;

  // Card dimensions
  static const double cardElevation = 2;
  static const double cardRadius = 12;

  // Image dimensions
  static const double imageThumbnailSize = 48;
  static const double imageSmallSize = 96;
  static const double imageMediumSize = 192;
  static const double imageLargeSize = 384;

  // Screen dimensions helpers
  static const double maxWidthMobile = 600;
  static const double maxWidthTablet = 1024;
  static const double maxWidthDesktop = 1440;

  // Common spacing combinations
  static const EdgeInsets paddingAllSmall = EdgeInsets.all(paddingSmall);
  static const EdgeInsets paddingAllMedium = EdgeInsets.all(paddingMedium);
  static const EdgeInsets paddingAllLarge = EdgeInsets.all(paddingLarge);

  static const EdgeInsets paddingHorizontalSmall =
      EdgeInsets.symmetric(horizontal: paddingSmall);
  static const EdgeInsets paddingHorizontalMedium =
      EdgeInsets.symmetric(horizontal: paddingMedium);
  static const EdgeInsets paddingHorizontalLarge =
      EdgeInsets.symmetric(horizontal: paddingLarge);

  static const EdgeInsets paddingVerticalSmall =
      EdgeInsets.symmetric(vertical: paddingSmall);
  static const EdgeInsets paddingVerticalMedium =
      EdgeInsets.symmetric(vertical: paddingMedium);
  static const EdgeInsets paddingVerticalLarge =
      EdgeInsets.symmetric(vertical: paddingLarge);

  static const EdgeInsets marginAllSmall = EdgeInsets.all(marginSmall);
  static const EdgeInsets marginAllMedium = EdgeInsets.all(marginMedium);
  static const EdgeInsets marginAllLarge = EdgeInsets.all(marginLarge);

  static const EdgeInsets marginHorizontalSmall =
      EdgeInsets.symmetric(horizontal: marginSmall);
  static const EdgeInsets marginHorizontalMedium =
      EdgeInsets.symmetric(horizontal: marginMedium);
  static const EdgeInsets marginHorizontalLarge =
      EdgeInsets.symmetric(horizontal: marginLarge);

  static const EdgeInsets marginVerticalSmall =
      EdgeInsets.symmetric(vertical: marginSmall);
  static const EdgeInsets marginVerticalMedium =
      EdgeInsets.symmetric(vertical: marginMedium);
  static const EdgeInsets marginVerticalLarge =
      EdgeInsets.symmetric(vertical: marginLarge);
}

/// {@template app_sizes}
/// Size constants for various UI elements.
/// {@endtemplate}
class AppSizes {
  const AppSizes._();

  // Screen breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // Container sizes
  static const double containerSmall = 100;
  static const double containerMedium = 200;
  static const double containerLarge = 400;

  // Avatar sizes
  static const double avatarSmall = 32;
  static const double avatarMedium = 48;
  static const double avatarLarge = 64;

  // Divider thickness
  static const double dividerThin = 0.5;
  static const double dividerNormal = 1;
  static const double dividerThick = 2;

  // Stroke widths
  static const double strokeThin = 1;
  static const double strokeMedium = 2;
  static const double strokeThick = 3;

  // Minimum touch targets
  static const double minTouchTarget = 44;
  static const double minTouchTargetSmall = 32;
}
