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
  Future<void> saveFavoriteCoffee(CoffeeModel coffee) async {
    final favorites = await getFavoriteCoffees();
    
    favorites..removeWhere((c) => c.id == coffee.id)
    ..add(coffee);
    await _saveFavorites(favorites);
    
    unawaited(_cacheImageInBackground(coffee));
  }

  Future<void> _cacheImageInBackground(CoffeeModel coffee) async {
    try {
      final cachedPath = await imageCacheService.cacheImage(coffee.imageUrl);
      
      if (cachedPath != null) {
        final favorites = await getFavoriteCoffees();
        final coffeeWithCachedPath = CoffeeModel(
          id: coffee.id,
          imageUrl: cachedPath,
          isFavorite: coffee.isFavorite,
        );
        
        favorites..removeWhere((c) => c.id == coffee.id)
        ..add(coffeeWithCachedPath);
        
        await _saveFavorites(favorites);
      }
    } on Exception {
      // Silently fail - UI already updated with URL and 
      // cacheImage already showed error
    }
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
    
    return favoritesJson
        .map((jsonString) {
          try {
            final jsonData = json.decode(jsonString) as Map<String, dynamic>;
            return CoffeeModel(
              id: jsonData['id'] as String,
              imageUrl: jsonData['imageUrl'] as String,
              isFavorite: jsonData['isFavorite'] as bool? ?? true,
            );
          } on Exception {
            return null;
          }
        })
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
    final favoritesJson = favorites
        .map((coffee) => json.encode(coffee.toJson()))
        .toList();
    
    await sharedPreferences.setStringList(_favoritesKey, favoritesJson);
  }
}
