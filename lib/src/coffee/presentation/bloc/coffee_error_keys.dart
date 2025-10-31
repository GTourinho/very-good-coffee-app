/// Localization keys for coffee-related errors.
///
/// These keys map to entries in the ARB files (app_en.arb, app_es.arb, etc.)
class CoffeeErrorKeys {
  // coverage:ignore-start
  const CoffeeErrorKeys._();
  // coverage:ignore-end

  /// Key for error when loading a single coffee fails.
  /// Maps to: "Could not load coffee. Please try again."
  static const String loadCoffee = 'couldNotLoadCoffee';

  /// Key for error when loading favorites list fails.
  /// Maps to: "Could not load your favorite coffees. Please try again."
  static const String loadFavorites = 'couldNotLoadCoffees';

  /// Key for error when updating favorites fails.
  /// Maps to: "Oops! Could not update your favorites. Please try again"
  static const String updateFavorites = 'couldNotUpdateFavorites';
}
