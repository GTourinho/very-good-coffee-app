import 'package:coffee_repository/src/data/services/image_cache_service.dart';
import 'package:coffee_repository/src/domain/entities/coffee.dart';
import 'package:coffee_repository/src/domain/repositories/coffee_repository.dart';

/// {@template toggle_favorite_coffee}
/// Use case for toggling a coffee image's favorite status.
/// {@endtemplate}
class ToggleFavoriteCoffee {
  /// {@macro toggle_favorite_coffee}
  const ToggleFavoriteCoffee(this._repository);

  final CoffeeRepository _repository;

  /// Toggles the favorite status of a coffee image.
  /// 
  /// Takes a [coffee] entity and updates its favorite status.
  /// Returns a tuple containing the updated [Coffee] entity and 
  /// the [ImageCacheResult].
  Future<(Coffee, ImageCacheResult)> call(Coffee coffee) async {
    if (coffee.isFavorite) {
      await _repository.removeFavoriteCoffee(coffee.id);
      return (coffee.copyWith(isFavorite: false), ImageCacheResult.success(''));
    } else {
      final cacheResult = await _repository.saveFavoriteCoffee(coffee);
      return (coffee.copyWith(isFavorite: true), cacheResult);
    }
  }
}
