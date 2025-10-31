import 'package:coffee_app/src/coffee/data/datasources/coffee_local_datasource_impl.dart';
import 'package:coffee_app/src/coffee/data/models/coffee_model.dart';
import 'package:coffee_app/src/coffee/data/services/image_cache_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockImageCacheService extends Mock implements ImageCacheService {}

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

          when(() => mockSharedPreferences.getStringList(any())).thenReturn([]);
          when(() => mockSharedPreferences.setStringList(any(), any()))
              .thenAnswer((_) async => true);
          when(() => mockImageCacheService.cacheImage(any())).thenAnswer(
              (_) async =>
                  ImageCacheResult.success('/path/to/cached/image.jpg'),);

          // act
          await dataSource.saveFavoriteCoffee(tCoffeeModel);

          // assert
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verify(
            () => mockSharedPreferences.setStringList(
              'favorite_coffees',
              any(),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test(
        'should save local coffee file without caching',
        () async {
          // arrange
          const tCoffeeModel = CoffeeModel(
            id: '1',
            imageUrl: '/path/to/local/image.jpg',
          );

          when(() => mockSharedPreferences.getStringList(any())).thenReturn([]);
          when(() => mockSharedPreferences.setStringList(any(), any()))
              .thenAnswer((_) async => true);

          // act
          await dataSource.saveFavoriteCoffee(tCoffeeModel);

          // assert
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verify(
            () => mockSharedPreferences.setStringList(
              'favorite_coffees',
              any(),
            ),
          ).called(1);
          verifyNever(() => mockImageCacheService.cacheImage(any()));
          verifyNoMoreInteractions(mockSharedPreferences);
          verifyNoMoreInteractions(mockImageCacheService);
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

      test(
        'should return empty list when getStringList returns null',
        () async {
          // arrange
          when(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .thenReturn(null);

          // act
          final result = await dataSource.getFavoriteCoffees();

          // assert
          expect(result, <CoffeeModel>[]);
        },
      );

      test(
        'should resolve cached: prefix to file path',
        () async {
          // arrange
          final jsonList = [
            '{"id":"1","imageUrl":"cached:coffee1.jpg","isFavorite":true,"originalUrl":"https://example.com/coffee1.jpg"}',
          ];

          when(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .thenReturn(jsonList);
          when(() => mockImageCacheService
                  .getCachedImagePath('cached:coffee1.jpg'),)
              .thenAnswer((_) async => '/path/to/cached/coffee1.jpg');

          // act
          final result = await dataSource.getFavoriteCoffees();

          // assert
          expect(result.length, 1);
          expect(result[0].imageUrl, '/path/to/cached/coffee1.jpg');
        },
      );

      test(
        'should fallback to original URL when cached file does not exist',
        () async {
          // arrange
          final jsonList = [
            '{"id":"1","imageUrl":"cached:coffee1.jpg","isFavorite":true,"originalUrl":"https://example.com/coffee1.jpg"}',
          ];

          when(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .thenReturn(jsonList);
          when(() => mockImageCacheService.getCachedImagePath(
              'cached:coffee1.jpg',),).thenAnswer((_) async => null);

          // act
          final result = await dataSource.getFavoriteCoffees();

          // assert
          expect(result.length, 1);
          expect(result[0].imageUrl, 'https://example.com/coffee1.jpg');
        },
      );

      test(
        'should skip invalid JSON entries',
        () async {
          // arrange
          final jsonList = [
            '{"id":"1","imageUrl":"https://example.com/coffee1.jpg","isFavorite":true}',
            'invalid json',
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
          verify(
            () => mockSharedPreferences.setStringList(
              'favorite_coffees',
              any(),
            ),
          ).called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test(
        'should handle removing coffee that does not exist',
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

          // act
          await dataSource.removeFavoriteCoffee('nonexistent-id');

          // assert
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verify(
            () => mockSharedPreferences.setStringList(
              'favorite_coffees',
              any(),
            ),
          ).called(1);
          verifyNever(() => mockImageCacheService.deleteCachedImage(any()));
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

      test(
        'should handle empty favorites list in isCoffeeFavorite',
        () async {
          // arrange
          when(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .thenReturn([]);

          // act
          final result = await dataSource.isCoffeeFavorite('any-id');

          // assert
          expect(result, false);
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test(
        'should save empty favorites list when all favorites are removed',
        () async {
          // arrange
          final jsonList = [
            '{"id":"1","imageUrl":"https://example.com/coffee1.jpg","isFavorite":true}',
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
          verify(
          () => mockSharedPreferences.setStringList(
                'favorite_coffees',
                [],
              ),
        ).called(1);
        },
      );

      test(
        'should handle getFavoriteCoffees with null SharedPreferences data',
        () async {
          // arrange
          when(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .thenReturn(null);

          // act
          final result = await dataSource.getFavoriteCoffees();

          // assert
          expect(result, isEmpty);
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test(
        'should handle malformed JSON in getFavoriteCoffees',
        () async {
          // arrange
          when(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .thenReturn(['invalid json', '{"id": "1", "imageUrl": "https://example.com/coffee.jpg"}']);

          // act
          final result = await dataSource.getFavoriteCoffees();

          // assert
          expect(result, hasLength(1));
          expect(result.first.id, equals('1'));
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );

      test(
        'should handle JSON decoding exception in getFavoriteCoffees',
        () async {
          // arrange
          when(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .thenReturn(['{invalid json}']);

          // act
          final result = await dataSource.getFavoriteCoffees();

          // assert
          expect(result, isEmpty);
          verify(() => mockSharedPreferences.getStringList('favorite_coffees'))
              .called(1);
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );
    });
  });
}
