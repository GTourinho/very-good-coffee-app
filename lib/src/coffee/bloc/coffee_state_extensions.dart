import 'package:coffee_app/l10n/l10n.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_error_keys.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_state.dart';
import 'package:flutter/material.dart';

/// Extension to get localized error messages from error keys.
extension CoffeeLoadFailureX on CoffeeLoadFailure {
  /// Gets the localized error message for this failure state.
  String getLocalizedMessage(BuildContext context) {
    final l10n = context.l10n;
    switch (errorKey) {
      case CoffeeErrorKeys.loadCoffee:
        return l10n.couldNotLoadCoffee;
      case CoffeeErrorKeys.loadFavorites:
        return l10n.couldNotLoadCoffees;
      default:
        return errorKey; // Fallback to key if not mapped
    }
  }
}

/// Extension to get localized error messages from CoffeeActionError.
extension CoffeeActionErrorX on CoffeeActionError {
  /// Gets the localized error message for this action error.
  String getLocalizedMessage(BuildContext context) {
    final l10n = context.l10n;
    switch (errorKey) {
      case CoffeeErrorKeys.updateFavorites:
        return l10n.couldNotUpdateFavorites;
      default:
        return errorKey; // Fallback to key if not mapped
    }
  }
}
