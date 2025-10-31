import 'dart:async';
import 'dart:convert';

import 'package:coffee_app/src/coffee/data/datasources/coffee_local_datasource.dart';
import 'package:coffee_app/src/coffee/data/models/coffee_model.dart';
import 'package:coffee_app/src/coffee/data/services/image_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source implementation for coffee.
class CoffeeLocalDataSourceImpl implements CoffeeLocalDataSource {
  /// Creates a local data source.
  const CoffeeLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.imageCacheService,
  });

  /// Shared preferences instance.
  final SharedPreferences sharedPreferences;

  /// Image cache service instance.
  final ImageCacheService imageCacheService;

  static const String _favoritesKey = 'favorite_coffees';

  @override
  Future<ImageCacheResult> saveFavoriteCoffee(CoffeeModel coffee) async {
    final favorites = await getFavoriteCoffees();

    // Store original URL if this is a network URL and
    // originalUrl is not already set
    final coffeeToSave =
        coffee.imageUrl.startsWith('http') && coffee.originalUrl == null
            ? coffee.copyWith(originalUrl: coffee.imageUrl)
            : coffee;

    favorites
      ..removeWhere((c) => c.id == coffee.id)
      ..add(coffeeToSave);
    await _saveFavorites(favorites);

    // Cache image if it's a network URL
    if (coffeeToSave.imageUrl.startsWith('http')) {
      return imageCacheService.cacheImage(coffeeToSave.imageUrl);
    }
    
    // Already a local file, return success
    return ImageCacheResult.success(coffeeToSave.imageUrl);
  }

  @override
  Future<void> removeFavoriteCoffee(String coffeeId) async {
    final favorites = await getFavoriteCoffees();

    final coffeeToRemoveIndex = favorites.indexWhere(
      (coffee) => coffee.id == coffeeId,
    );

    if (coffeeToRemoveIndex != -1) {
      final coffeeToRemove = favorites[coffeeToRemoveIndex];
      await imageCacheService.deleteCachedImage(coffeeToRemove.imageUrl);
    }

    favorites.removeWhere((coffee) => coffee.id == coffeeId);
    await _saveFavorites(favorites);
  }

  @override
  Future<List<CoffeeModel>> getFavoriteCoffees() async {
    final favoritesJson = sharedPreferences.getStringList(_favoritesKey) ?? [];

    final futures = favoritesJson.map((jsonString) async {
      try {
        final jsonData = json.decode(jsonString) as Map<String, dynamic>;
        var imageUrl = jsonData['imageUrl'] as String;
        final originalUrl = jsonData['originalUrl'] as String?;

        // Resolve cached image path at runtime (handles iOS sandbox changes)
        if (imageUrl.startsWith('cached:')) {
          final resolvedPath = await imageCacheService.getCachedImagePath(
            imageUrl,
          );
          if (resolvedPath != null) {
            imageUrl = resolvedPath;
          } else if (originalUrl != null) {
            // Cached file doesn't exist, fall back to original URL
            imageUrl = originalUrl;
          }
        }

        return CoffeeModel(
          id: jsonData['id'] as String,
          imageUrl: imageUrl,
          isFavorite: jsonData['isFavorite'] as bool? ?? true,
          originalUrl: originalUrl,
        );
      } on Exception {
        return null;
      }
    });

    final coffees = await Future.wait(futures);
    return coffees
        .where((coffee) => coffee != null)
        .cast<CoffeeModel>()
        .toList();
  }

  @override
  Future<bool> isCoffeeFavorite(String coffeeId) async {
    final favorites = await getFavoriteCoffees();
    return favorites.any((coffee) => coffee.id == coffeeId);
  }

  Future<void> _saveFavorites(List<CoffeeModel> favorites) async {
    final favoritesJson =
        favorites.map((coffee) => json.encode(coffee.toJson())).toList();

    await sharedPreferences.setStringList(_favoritesKey, favoritesJson);
  }
}
