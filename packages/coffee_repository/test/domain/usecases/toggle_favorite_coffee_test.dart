import 'package:coffee_repository/src/data/services/image_cache_service.dart';
import 'package:coffee_repository/src/domain/entities/coffee.dart';
import 'package:coffee_repository/src/domain/repositories/coffee_repository.dart';
import 'package:coffee_repository/src/domain/usecases/toggle_favorite_coffee.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const Coffee(
        id: 'test',
        imageUrl: 'https://example.com/test.jpg',
      ),
    );
  });

  group('ToggleFavoriteCoffee', () {
    late MockCoffeeRepository mockRepository;
    late ToggleFavoriteCoffee usecase;

    setUp(() {
      mockRepository = MockCoffeeRepository();
      usecase = ToggleFavoriteCoffee(mockRepository);
    });

    const tCoffee = Coffee(
      id: '1',
      imageUrl: 'https://example.com/coffee.jpg',
    );

    const tFavoriteCoffee = Coffee(
      id: '1',
      imageUrl: 'https://example.com/coffee.jpg',
      isFavorite: true,
    );

    test(
      'should save coffee as favorite when it is not favorite',
      () async {
        // arrange
        when(() => mockRepository.saveFavoriteCoffee(any()))
            .thenAnswer((_) async => ImageCacheResult.success('/path/to/image'));
        when(() => mockRepository.removeFavoriteCoffee(any()))
            .thenAnswer((_) async {});

        // act
        final result = await usecase(tCoffee);

        // assert
        expect(result.$1, tFavoriteCoffee);
        expect(result.$2.success, true);
        verify(() => mockRepository.saveFavoriteCoffee(tCoffee)).called(1);
        verifyNever(() => mockRepository.removeFavoriteCoffee(any()));
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should remove coffee from favorites when it is favorite',
      () async {
        // arrange
        when(() => mockRepository.saveFavoriteCoffee(any()))
            .thenAnswer((_) async => ImageCacheResult.success('/path/to/image'));
        when(() => mockRepository.removeFavoriteCoffee(any()))
            .thenAnswer((_) async {});

        // act
        final result = await usecase(tFavoriteCoffee);

        // assert
        expect(result.$1, tCoffee);
        expect(result.$2.success, true);
        verifyNever(() => mockRepository.saveFavoriteCoffee(any()));
        verify(() => mockRepository.removeFavoriteCoffee('1')).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
