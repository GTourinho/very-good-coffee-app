import 'package:coffee_repository/src/data/datasources/coffee_local_datasource.dart';
import 'package:coffee_repository/src/data/datasources/coffee_remote_datasource.dart';
import 'package:coffee_repository/src/data/models/coffee_model.dart';
import 'package:coffee_repository/src/data/services/image_cache_service.dart';
import 'package:coffee_repository/src/domain/entities/coffee.dart';
import 'package:coffee_repository/src/domain/repositories/coffee_repository.dart';

/// {@template coffee_repository_impl}
/// Implementation of [CoffeeRepository] using data sources.
/// {@endtemplate}
class CoffeeRepositoryImpl implements CoffeeRepository {
  /// {@macro coffee_repository_impl}
  const CoffeeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Remote data source for fetching coffee data.
  final CoffeeRemoteDataSource remoteDataSource;

  /// Local data source for favorite coffee storage.
  final CoffeeLocalDataSource localDataSource;

  @override
  Future<Coffee> getRandomCoffee() async {
    final coffeeModel = await remoteDataSource();
    final isFavorite = await localDataSource.isCoffeeFavorite(coffeeModel.id);
    
    return Coffee(
      id: coffeeModel.id,
      imageUrl: coffeeModel.imageUrl,
      isFavorite: isFavorite,
    );
  }

  @override
  Future<List<Coffee>> getFavoriteCoffees() async {
    final coffeeModels = await localDataSource.getFavoriteCoffees();
    return coffeeModels
        .map((model) => Coffee(
          id: model.id,
          imageUrl: model.imageUrl,
          isFavorite: true,
        ),)
        .toList();
  }

  @override
  Future<ImageCacheResult> saveFavoriteCoffee(Coffee coffee) async {
    final coffeeModel = CoffeeModel.fromEntity(coffee);
    return localDataSource.saveFavoriteCoffee(coffeeModel);
  }

  @override
  Future<void> removeFavoriteCoffee(String coffeeId) async {
    await localDataSource.removeFavoriteCoffee(coffeeId);
  }

  @override
  Future<bool> isCoffeeFavorite(String coffeeId) async {
    return localDataSource.isCoffeeFavorite(coffeeId);
  }
}
