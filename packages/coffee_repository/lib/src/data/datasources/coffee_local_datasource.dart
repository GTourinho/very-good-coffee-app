import 'package:coffee_repository/src/data/models/coffee_model.dart';
import 'package:coffee_repository/src/data/services/image_cache_service.dart';

/// {@template coffee_local_datasource}
/// Interface for local coffee data operations.
/// {@endtemplate}
abstract class CoffeeLocalDataSource {
  /// Saves a coffee image as favorite.
  /// Returns ImageCacheResult indicating caching success or failure.
  Future<ImageCacheResult> saveFavoriteCoffee(CoffeeModel coffee);

  /// Removes a coffee image from favorites.
  Future<void> removeFavoriteCoffee(String coffeeId);

  /// Gets all favorite coffee images.
  Future<List<CoffeeModel>> getFavoriteCoffees();

  /// Checks if a coffee image is marked as favorite.
  Future<bool> isCoffeeFavorite(String coffeeId);
}
