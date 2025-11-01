import 'package:coffee_repository/src/domain/entities/coffee.dart';
import 'package:coffee_repository/src/domain/repositories/coffee_repository.dart';

/// {@template get_random_coffee}
/// Use case for getting a random coffee image.
/// {@endtemplate}
class GetRandomCoffee {
  /// {@macro get_random_coffee}
  const GetRandomCoffee(this._repository);

  final CoffeeRepository _repository;

  /// Gets a random coffee image from the repository.
  /// 
  /// Returns a [Coffee] entity.
  /// Throws an [Exception] if the request fails.
  Future<Coffee> call() async {
    return _repository.getRandomCoffee();
  }
}
