import 'package:coffee_app/src/coffee/data/datasources/coffee_local_datasource_impl.dart';
import 'package:coffee_app/src/coffee/data/models/coffee_model.dart';
import 'package:coffee_app/src/coffee/data/services/image_cache_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockImageCacheService extends Mock
    implements ImageCacheService {}

void main() {
  group('CoffeeLocalDataSourceImpl', () {
    late MockSharedPreferences mockSharedPreferences;
    late MockImageCacheService mockImageCacheService;
    late CoffeeLocalDataSourceImpl dataSource;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      mockImageCacheService = MockImageCacheService();
      dataSource = CoffeeLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences,
        imageCacheService: mockImageCacheService,
      );
    });

    group('saveFavoriteCoffee', () {
      test(
        'should save coffee to favorites',
        () async {
          // arrange
          const tCoffeeModel = CoffeeModel(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          );

          when(() => mockSharedPreferences.getStringList(any()))
              .thenReturn([]);
          when(() => mockSharedPreferences.setStringList(any(), any()))
              .thenAnswer((_) async => true);
          when(() => mockImageCacheService.cacheImage(any()))
              .thenAnswer((_) async => '/path/to/cached/image.jpg');

          // act
          await dataSource.saveFavoriteCoffee(tCoffeeModel);

          // assert
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verify(() => mockSharedPreferences.setStringList(
                'favorite_coffees',
                any(),
              ),).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );
    });

    group('getFavoriteCoffees', () {
      test(
        'should return list of favorite coffees when there are favorites',
        () async {
          // arrange
          final jsonList = [
            '{"id":"1","imageUrl":"https://example.com/coffee1.jpg","isFavorite":true}',
            '{"id":"2","imageUrl":"https://example.com/coffee2.jpg","isFavorite":true}',
          ];

          when(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .thenReturn(jsonList);

          // act
          final result = await dataSource.getFavoriteCoffees();

          // assert
          expect(result.length, 2);
          expect(result[0].id, '1');
          expect(result[1].id, '2');
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test(
        'should return empty list when there are no favorites',
        () async {
          // arrange
          when(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .thenReturn([]);

          // act
          final result = await dataSource.getFavoriteCoffees();

          // assert
          expect(result, <CoffeeModel>[]);
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );
    });

    group('removeFavoriteCoffee', () {
      test(
        'should remove coffee from favorites',
        () async {
          // arrange
          final jsonList = [
            '{"id":"1","imageUrl":"https://example.com/coffee1.jpg","isFavorite":true}',
            '{"id":"2","imageUrl":"https://example.com/coffee2.jpg","isFavorite":true}',
          ];

          when(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .thenReturn(jsonList);
          when(() => mockSharedPreferences.setStringList(any(), any()))
              .thenAnswer((_) async => true);
          when(() => mockImageCacheService.deleteCachedImage(any()))
              .thenAnswer((_) async {});

          // act
          await dataSource.removeFavoriteCoffee('1');

          // assert
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verify(() => mockSharedPreferences.setStringList(
                'favorite_coffees',
                any(),
              ),).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );
    });

    group('isCoffeeFavorite', () {
      test(
        'should return true when coffee is in favorites',
        () async {
          // arrange
          final jsonList = [
            '{"id":"1","imageUrl":"https://example.com/coffee1.jpg","isFavorite":true}',
            '{"id":"2","imageUrl":"https://example.com/coffee2.jpg","isFavorite":true}',
          ];

          when(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .thenReturn(jsonList);

          // act
          final result = await dataSource.isCoffeeFavorite('1');

          // assert
          expect(result, true);
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test(
        'should return false when coffee is not in favorites',
        () async {
          // arrange
          final jsonList = [
            '{"id":"1","imageUrl":"https://example.com/coffee1.jpg","isFavorite":true}',
            '{"id":"2","imageUrl":"https://example.com/coffee2.jpg","isFavorite":true}',
          ];

          when(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .thenReturn(jsonList);

          // act
          final result = await dataSource.isCoffeeFavorite('3');

          // assert
          expect(result, false);
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );
    });
  });
}
