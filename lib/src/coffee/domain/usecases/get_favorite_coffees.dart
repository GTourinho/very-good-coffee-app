import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/domain/repositories/coffee_repository.dart';

/// {@template get_favorite_coffees}
/// Use case for getting all favorite coffee images.
/// {@endtemplate}
class GetFavoriteCoffees {
  /// {@macro get_favorite_coffees}
  const GetFavoriteCoffees(this._repository);

  final CoffeeRepository _repository;

  /// Gets all favorite coffee images from the repository.
  /// 
  /// Returns a list of [Coffee] entities marked as favorite.
  Future<List<Coffee>> call() async {
    return _repository.getFavoriteCoffees();
  }
}
