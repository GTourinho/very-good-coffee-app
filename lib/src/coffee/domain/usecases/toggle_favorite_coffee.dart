import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/domain/repositories/coffee_repository.dart';

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
  /// Returns the updated [Coffee] entity.
  Future<Coffee> call(Coffee coffee) async {
    if (coffee.isFavorite) {
      await _repository.removeFavoriteCoffee(coffee.id);
      return coffee.copyWith(isFavorite: false);
    } else {
      await _repository.saveFavoriteCoffee(coffee);
      return coffee.copyWith(isFavorite: true);
    }
  }
}
