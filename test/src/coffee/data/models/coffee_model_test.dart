import 'package:coffee_app/src/coffee/data/models/coffee_model.dart';
import 'package:coffee_app/src/coffee/data/services/image_cache_service.dart';
import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockImageCacheService extends Mock implements ImageCacheService {}

void main() {
  group('CoffeeModel', () {
    const tCoffeeModel = CoffeeModel(
      id: '1',
      imageUrl: 'https://example.com/coffee.jpg',
    );

    test(
      'should be a subclass of Coffee entity',
      () async {
        // assert
        expect(tCoffeeModel, isA<Coffee>());
      },
    );

    test(
      'should return a valid model from API JSON',
      () async {
        // arrange
        final jsonMap = {
          'id': '1',
          'file': 'https://example.com/1.jpg',
        };

        // act
        final result = CoffeeModel.fromApiResponse(jsonMap);

        // assert
        expect(result.id, '1');
        expect(result.imageUrl, 'https://example.com/1.jpg');
        expect(result.isFavorite, false);
      },
    );

    test(
      'should return a JSON map containing proper data',
      () async {
        // act
        final result = tCoffeeModel.toJson();

        // assert
        final expectedJsonMap = {
          'id': '1',
          'imageUrl': 'https://example.com/coffee.jpg',
          'isFavorite': false,
          'originalUrl': null,
        };
        expect(result, expectedJsonMap);
      },
    );

    test(
      'should create a model from entity',
      () async {
        // arrange
        const coffeeEntity = Coffee(
          id: '1',
          imageUrl: 'https://example.com/coffee.jpg',
          isFavorite: true,
        );

        // act
        final result = CoffeeModel.fromEntity(coffeeEntity);

        // assert
        expect(result.id, coffeeEntity.id);
        expect(result.imageUrl, coffeeEntity.imageUrl);
        expect(result.isFavorite, coffeeEntity.isFavorite);
      },
    );

    test(
      'should throw exception when API response has no file',
      () {
        // arrange
        final jsonMap = {'id': '1'};

        // assert
        expect(
          () => CoffeeModel.fromApiResponse(jsonMap),
          throwsException,
        );
      },
    );

    test(
      'should create model from JSON',
      () {
        // arrange
        final jsonMap = {
          'id': '1',
          'imageUrl': 'https://example.com/coffee.jpg',
          'isFavorite': true,
          'originalUrl': 'https://example.com/original.jpg',
        };

        // act
        final result = CoffeeModel.fromJson(jsonMap);

        // assert
        expect(result.id, '1');
        expect(result.imageUrl, 'https://example.com/coffee.jpg');
        expect(result.isFavorite, true);
        expect(result.originalUrl, 'https://example.com/original.jpg');
      },
    );

    test(
      'should create copy with updated values',
      () {
        // act
        final result = tCoffeeModel.copyWith(
          id: '2',
          isFavorite: true,
          originalUrl: 'https://example.com/original.jpg',
        );

        // assert
        expect(result.id, '2');
        expect(result.imageUrl, tCoffeeModel.imageUrl);
        expect(result.isFavorite, true);
        expect(result.originalUrl, 'https://example.com/original.jpg');
      },
    );

    test(
      'should create copy with no updated values',
      () {
        // act
        final result = tCoffeeModel.copyWith();

        // assert
        expect(result.id, tCoffeeModel.id);
        expect(result.imageUrl, tCoffeeModel.imageUrl);
        expect(result.isFavorite, tCoffeeModel.isFavorite);
        expect(result.originalUrl, tCoffeeModel.originalUrl);
      },
    );

    group('getDisplayImagePath', () {
      late MockImageCacheService mockImageCacheService;

      setUp(() {
        mockImageCacheService = MockImageCacheService();
      });

      test('returns cached path when available', () async {
        // arrange
        const cachedPath = '/path/to/cached/image.jpg';
        when(() => mockImageCacheService.getCachedImagePath(any()))
            .thenAnswer((_) async => cachedPath);

        // act
        final result = await tCoffeeModel.getDisplayImagePath(
          mockImageCacheService,
        );

        // assert
        expect(result, cachedPath);
      });

      test('returns original URL when cached path is null', () async {
        // arrange
        const model = CoffeeModel(
          id: '1',
          imageUrl: 'https://example.com/coffee.jpg',
          originalUrl: 'https://example.com/original.jpg',
        );
        when(() => mockImageCacheService.getCachedImagePath(any()))
            .thenAnswer((_) async => null);

        // act
        final result = await model.getDisplayImagePath(mockImageCacheService);

        // assert
        expect(result, 'https://example.com/original.jpg');
      });

      test('returns imageUrl when both cached and original are null', () async {
        // arrange
        when(() => mockImageCacheService.getCachedImagePath(any()))
            .thenAnswer((_) async => null);

        // act
        final result = await tCoffeeModel.getDisplayImagePath(
          mockImageCacheService,
        );

        // assert
        expect(result, tCoffeeModel.imageUrl);
      });
    });
  });
}
