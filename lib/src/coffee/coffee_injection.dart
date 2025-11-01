import 'package:coffee_app/src/coffee/bloc/coffee_bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// {@template coffee_injection}
/// Dependency injection setup for the coffee feature.
/// {@endtemplate}
class CoffeeInjection {
  /// {@macro coffee_injection}
  static Future<void> init(GetIt getIt) async {
    // External dependencies
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt..registerLazySingleton(() => sharedPreferences)
    ..registerLazySingleton(http.Client.new)

    // Services
    ..registerLazySingleton<ImageCacheService>(
      ImageCacheServiceImpl.new,
    )

    // Data sources
    ..registerLazySingleton<CoffeeRemoteDataSource>(
      () => CoffeeRemoteDataSourceImpl(client: getIt()).call,
    )
    ..registerLazySingleton<CoffeeLocalDataSource>(
      () => CoffeeLocalDataSourceImpl(
        sharedPreferences: getIt(),
        imageCacheService: getIt(),
      ),
    )

    // Repository
    ..registerLazySingleton<CoffeeRepository>(
      () => CoffeeRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
      ),
    )

    // Use cases
    ..registerLazySingleton(
      () => GetRandomCoffee(getIt()),
    )
    ..registerLazySingleton(
      () => GetFavoriteCoffees(getIt()),
    )
    ..registerLazySingleton(
      () => ToggleFavoriteCoffee(getIt()),
    )

    // BLoC
    ..registerFactory(
      () => CoffeeBloc(
        getRandomCoffee: getIt(),
        getFavoriteCoffees: getIt(),
        toggleFavoriteCoffee: getIt(),
      ),
    );
  }
}
