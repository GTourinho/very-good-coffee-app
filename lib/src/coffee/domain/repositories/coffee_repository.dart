import 'package:coffee_app/src/coffee/data/services/image_cache_service.dart';
import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';

/// {@template coffee_repository}
/// Repository interface for coffee data.
/// {@endtemplate}
abstract class CoffeeRepository {
  /// Gets a random coffee image.
  /// 
  /// Returns a [Coffee] entity.
  /// Throws an [Exception] if the request fails.
  Future<Coffee> getRandomCoffee();

  /// Gets all favorite coffee images.
  /// 
  /// Returns a list of [Coffee] entities marked as favorite.
  Future<List<Coffee>> getFavoriteCoffees();

  /// Saves a coffee image as favorite.
  /// 
  /// Takes a [coffee] entity to save.
  /// Returns [ImageCacheResult] indicating caching success or failure.
  Future<ImageCacheResult> saveFavoriteCoffee(Coffee coffee);

  /// Removes a coffee image from favorites.
  /// 
  /// Takes a [coffeeId] to remove from favorites.
  Future<void> removeFavoriteCoffee(String coffeeId);

  /// Checks if a coffee image is marked as favorite.
  /// 
  /// Takes a [coffeeId] and returns true if it's favorite.
  Future<bool> isCoffeeFavorite(String coffeeId);
}
