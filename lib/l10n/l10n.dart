import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

export 'package:coffee_app/l10n/generated/app_localizations.dart';

/// Extension for easy localization access.
extension AppLocalizationsX on BuildContext {
  /// Gets the app localizations.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
