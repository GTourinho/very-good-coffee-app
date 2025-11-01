import 'package:coffee_repository/src/data/datasources/coffee_local_datasource.dart';
import 'package:coffee_repository/src/data/datasources/coffee_remote_datasource.dart';
import 'package:coffee_repository/src/data/models/coffee_model.dart';
import 'package:coffee_repository/src/data/repositories/coffee_repository_impl.dart';
import 'package:coffee_repository/src/data/services/image_cache_service.dart';
import 'package:coffee_repository/src/domain/entities/coffee.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDataSource extends Mock implements CoffeeLocalDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CoffeeModel(
        id: 'test',
        imageUrl: 'https://example.com/test.jpg',
      ),
    );
  });

  group('CoffeeRepositoryImpl', () {
    late MockLocalDataSource mockLocalDataSource;
    late CoffeeRepositoryImpl repository;
    late CoffeeRemoteDataSource mockRemoteDataSource;

    setUp(() {
      mockLocalDataSource = MockLocalDataSource();
      mockRemoteDataSource = () async => throw UnimplementedError();
      repository = CoffeeRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
      );
    });

    group('getRandomCoffee', () {
      test(
        'should return coffee with favorite status from remote and local data '
        'sources',
        () async {
          // arrange
          const tCoffeeModel = CoffeeModel(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          );
          const tCoffee = Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          );

          mockRemoteDataSource = () async => tCoffeeModel;
          repository = CoffeeRepositoryImpl(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource,
          );
          
          when(() => mockLocalDataSource.isCoffeeFavorite(any()))
              .thenAnswer((_) async => true);

          // act
          final result = await repository.getRandomCoffee();

          // assert
          expect(result, tCoffee);
          verify(() => mockLocalDataSource.isCoffeeFavorite('1')).called(1);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );
    });

    group('getFavoriteCoffees', () {
      test(
        'should return list of favorite coffees from local data source',
        () async {
          // arrange
          final tCoffeeModels = [
            const CoffeeModel(
              id: '1',
              imageUrl: 'https://example.com/coffee1.jpg',
            ),
            const CoffeeModel(
              id: '2',
              imageUrl: 'https://example.com/coffee2.jpg',
            ),
          ];

          when(() => mockLocalDataSource.getFavoriteCoffees())
              .thenAnswer((_) async => tCoffeeModels);

          // act
          final result = await repository.getFavoriteCoffees();

          // assert
          expect(result.length, 2);
          expect(result[0].isFavorite, true);
          expect(result[1].isFavorite, true);
          verify(() => mockLocalDataSource.getFavoriteCoffees()).called(1);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );
    });

    group('saveFavoriteCoffee', () {
      test(
        'should save coffee to local data source',
        () async {
          // arrange
          const tCoffee = Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          );

          when(() => mockLocalDataSource.saveFavoriteCoffee(any()))
              .thenAnswer((_) async => ImageCacheResult.success('/path/to/image'));

          // act
          final result = await repository.saveFavoriteCoffee(tCoffee);

          // assert
          expect(result.success, true);
          expect(result.filePath, '/path/to/image');
          verify(() => mockLocalDataSource.saveFavoriteCoffee(
                CoffeeModel.fromEntity(tCoffee),
              ),).called(1);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );
    });

    group('removeFavoriteCoffee', () {
      test(
        'should remove coffee from local data source',
        () async {
          // arrange
          when(() => mockLocalDataSource.removeFavoriteCoffee(any()))
              .thenAnswer((_) async {});

          // act
          await repository.removeFavoriteCoffee('1');

          // assert
          verify(() => mockLocalDataSource.removeFavoriteCoffee('1'))
              .called(1);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );
    });

    group('isCoffeeFavorite', () {
      test(
        'should check if coffee is favorite from local data source',
        () async {
          // arrange
          when(() => mockLocalDataSource.isCoffeeFavorite(any()))
              .thenAnswer((_) async => true);

          // act
          final result = await repository.isCoffeeFavorite('1');

          // assert
          expect(result, true);
          verify(() => mockLocalDataSource.isCoffeeFavorite('1')).called(1);
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );
    });
  });
}
