import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/domain/usecases/get_favorite_coffees.dart';
import 'package:coffee_app/src/coffee/domain/usecases/get_random_coffee.dart';
import 'package:coffee_app/src/coffee/domain/usecases/toggle_favorite_coffee.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetRandomCoffee extends Mock implements GetRandomCoffee {}

class MockGetFavoriteCoffees extends Mock implements GetFavoriteCoffees {}

class MockToggleFavoriteCoffee extends Mock implements ToggleFavoriteCoffee {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const Coffee(
        id: 'test',
        imageUrl: 'https://example.com/test.jpg',
      ),
    );
  });

  group('CoffeeBloc', () {
    late MockGetRandomCoffee mockGetRandomCoffee;
    late MockGetFavoriteCoffees mockGetFavoriteCoffees;
    late MockToggleFavoriteCoffee mockToggleFavoriteCoffee;

    setUp(() {
      mockGetRandomCoffee = MockGetRandomCoffee();
      mockGetFavoriteCoffees = MockGetFavoriteCoffees();
      mockToggleFavoriteCoffee = MockToggleFavoriteCoffee();
    });

    blocTest<CoffeeBloc, CoffeeState>(
      'emits [CoffeeLoadInProgress, CoffeeLoadSuccess] when '
      'CoffeeRequested is added',
      build: () {
        when(() => mockGetRandomCoffee()).thenAnswer(
          (_) async => const Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        );
        when(() => mockGetFavoriteCoffees()).thenAnswer((_) async => []);

        return CoffeeBloc(
          getRandomCoffee: mockGetRandomCoffee,
          getFavoriteCoffees: mockGetFavoriteCoffees,
          toggleFavoriteCoffee: mockToggleFavoriteCoffee,
        );
      },
      act: (bloc) => bloc.add(const CoffeeRequested()),
      expect: () => [
        const CoffeeLoadInProgress(),
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        ),
      ],
      verify: (_) {
        verify(() => mockGetRandomCoffee()).called(1);
        verify(() => mockGetFavoriteCoffees()).called(1);
      },
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'emits [CoffeeLoadInProgress, CoffeeLoadFailure] when '
      'CoffeeRequested fails',
      build: () {
        when(() => mockGetRandomCoffee()).thenThrow(
          Exception(
            'Server error',
          ),
        );

        return CoffeeBloc(
          getRandomCoffee: mockGetRandomCoffee,
          getFavoriteCoffees: mockGetFavoriteCoffees,
          toggleFavoriteCoffee: mockToggleFavoriteCoffee,
        );
      },
      act: (bloc) => bloc.add(const CoffeeRequested()),
      expect: () => [
        const CoffeeLoadInProgress(),
        const CoffeeLoadFailure(
          'Oops! Could not load a coffee image. Please try again.',
        ),
      ],
      verify: (_) {
        verify(() => mockGetRandomCoffee()).called(1);
        verifyNever(() => mockGetFavoriteCoffees());
      },
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'emits updated CoffeeLoadSuccess when CoffeeFavoriteToggled is added',
      build: () {
        when(() => mockGetRandomCoffee()).thenAnswer(
          (_) async => const Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        );
        when(() => mockGetFavoriteCoffees()).thenAnswer((_) async => []);
        when(() => mockToggleFavoriteCoffee(any())).thenAnswer(
          (_) async => const Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
        );

        return CoffeeBloc(
          getRandomCoffee: mockGetRandomCoffee,
          getFavoriteCoffees: mockGetFavoriteCoffees,
          toggleFavoriteCoffee: mockToggleFavoriteCoffee,
        );
      },
      act: (bloc) async {
        bloc.add(const CoffeeRequested());
        await Future<void>.delayed(const Duration(milliseconds: 100));
        bloc.add(
          const CoffeeFavoriteToggled(
            Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
            ),
          ),
        );
      },
      expect: () => [
        const CoffeeLoadInProgress(),
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        ),
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'emits updated CoffeeLoadSuccess when CoffeeFavoritesRequested is added',
      build: () {
        when(() => mockGetRandomCoffee()).thenAnswer(
          (_) async => const Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        );
        when(() => mockGetFavoriteCoffees()).thenAnswer((_) async => []);

        return CoffeeBloc(
          getRandomCoffee: mockGetRandomCoffee,
          getFavoriteCoffees: mockGetFavoriteCoffees,
          toggleFavoriteCoffee: mockToggleFavoriteCoffee,
        );
      },
      act: (bloc) => bloc
        ..add(const CoffeeRequested())
        ..add(const CoffeeFavoritesRequested()),
      expect: () => [
        const CoffeeLoadInProgress(),
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'emits CoffeeActionError then restores state when toggle favorite fails',
      build: () {
        when(() => mockToggleFavoriteCoffee(any()))
            .thenThrow(Exception('Failed to toggle'));
        when(() => mockGetFavoriteCoffees()).thenAnswer((_) async => []);

        return CoffeeBloc(
          getRandomCoffee: mockGetRandomCoffee,
          getFavoriteCoffees: mockGetFavoriteCoffees,
          toggleFavoriteCoffee: mockToggleFavoriteCoffee,
        );
      },
      seed: () => const CoffeeLoadSuccess(
        currentCoffee: Coffee(
          id: '1',
          imageUrl: 'https://example.com/coffee.jpg',
        ),
      ),
      act: (bloc) => bloc.add(
        const CoffeeFavoriteToggled(
          Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        ),
      ),
      expect: () => [
        isA<CoffeeActionError>().having(
          (state) => state.error,
          'error',
          'Oops! Could not update your favorites. Please try again.',
        ),
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        ),
      ],
    );
  });
}
