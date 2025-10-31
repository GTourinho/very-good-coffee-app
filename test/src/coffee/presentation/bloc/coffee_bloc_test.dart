import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/src/coffee/data/services/image_cache_service.dart';
import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/domain/usecases/get_favorite_coffees.dart';
import 'package:coffee_app/src/coffee/domain/usecases/get_random_coffee.dart';
import 'package:coffee_app/src/coffee/domain/usecases/toggle_favorite_coffee.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_error_keys.dart';
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
        const CoffeeLoadFailure(
          CoffeeErrorKeys.loadCoffee,
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
          (_) async => (
            const Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
            ImageCacheResult.success('cached:test.jpg'),
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
        // Optimistic update
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
          favoriteCoffees: [
            Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
          ],
        ),
        // Sync with actual state (empty because mock returns empty list)
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
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
      'reverts to previous state and shows error when toggle favorite '
      'throws exception',
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
        // Optimistic update - adds to favorites
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
          favoriteCoffees: [
            Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
          ],
        ),
        // Revert to original state due to error
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        ),
        // Error state for snackbar
        isA<CoffeeActionError>().having(
          (e) => e.errorKey,
          'error',
          'couldNotUpdateFavorites',
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'Handles getFavoriteCoffees failure in toggle favorite '
      'after optimistic update.',
      build: () {
        when(() => mockToggleFavoriteCoffee(any())).thenAnswer(
          (_) async => (
            const Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
            ImageCacheResult.success('cached:test.jpg'),
          ),
        );
        when(() => mockGetFavoriteCoffees()).thenThrow(
          Exception('Failed to sync favorites'),
        );

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
        // Optimistic update - adds to favorites
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
          favoriteCoffees: [
            Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
          ],
        ),
        // Revert to original state due to sync error
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        ),
        // Error state for snackbar
        isA<CoffeeActionError>().having(
          (e) => e.errorKey,
          'error',
          'couldNotUpdateFavorites',
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'emits CoffeeLoadFailure when CoffeeFavoritesRequested fails',
      build: () {
        when(() => mockGetFavoriteCoffees()).thenThrow(
          Exception('Failed to load favorites'),
        );

        return CoffeeBloc(
          getRandomCoffee: mockGetRandomCoffee,
          getFavoriteCoffees: mockGetFavoriteCoffees,
          toggleFavoriteCoffee: mockToggleFavoriteCoffee,
        );
      },
      act: (bloc) => bloc.add(const CoffeeFavoritesRequested()),
      expect: () => [
        const CoffeeLoadFailure(
          CoffeeErrorKeys.loadFavorites,
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'handles toggle favorite exception when toggleFavoriteCoffee throws',
      build: () {
        when(() => mockToggleFavoriteCoffee(any()))
            .thenThrow(Exception('Toggle failed'));
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
        // Optimistic update
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
          favoriteCoffees: [
            Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
          ],
        ),
        // Revert to original state due to exception
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        ),
        // Error state for snackbar
        isA<CoffeeActionError>().having(
          (e) => e.errorKey,
          'error',
          'couldNotUpdateFavorites',
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'handles toggle favorite when getFavoriteCoffees throws during sync',
      build: () {
        when(() => mockToggleFavoriteCoffee(any())).thenAnswer(
          (_) async => (
            const Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
            ImageCacheResult.success('cached:test.jpg'),
          ),
        );
        when(() => mockGetFavoriteCoffees()).thenThrow(
          Exception('Sync failed'),
        );

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
        // Optimistic update
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
          favoriteCoffees: [
            Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
          ],
        ),
        // Revert to original state due to sync error
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        ),
        // Error state for snackbar
        isA<CoffeeActionError>().having(
          (e) => e.errorKey,
          'error',
          'couldNotUpdateFavorites',
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'handles exception in toggle favorite when toggleFavoriteCoffee throws',
      build: () {
        when(() => mockToggleFavoriteCoffee(any()))
            .thenThrow(Exception('Toggle operation failed'));
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
        // Optimistic update
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
          favoriteCoffees: [
            Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
          ],
        ),
        // Revert to original state due to exception
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        ),
        // Error state for snackbar
        isA<CoffeeActionError>().having(
          (e) => e.errorKey,
          'error',
          'couldNotUpdateFavorites',
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'handles exception in _onCoffeeFavoritesRequested',
      build: () {
        when(() => mockGetFavoriteCoffees())
            .thenThrow(Exception('Failed to get favorites'));

        return CoffeeBloc(
          getRandomCoffee: mockGetRandomCoffee,
          getFavoriteCoffees: mockGetFavoriteCoffees,
          toggleFavoriteCoffee: mockToggleFavoriteCoffee,
        );
      },
      act: (bloc) => bloc.add(const CoffeeFavoritesRequested()),
      expect: () => [
        const CoffeeLoadFailure(
          CoffeeErrorKeys.loadFavorites,
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'emits CoffeeLoadSuccess when CoffeeFavoritesRequested is added '
      'and state is not CoffeeLoadSuccess',
      build: () {
        final favorites = [
          const Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee1.jpg',
            isFavorite: true,
          ),
          const Coffee(
            id: '2',
            imageUrl: 'https://example.com/coffee2.jpg',
            isFavorite: true,
          ),
        ];
        when(() => mockGetFavoriteCoffees()).thenAnswer((_) async => favorites);

        return CoffeeBloc(
          getRandomCoffee: mockGetRandomCoffee,
          getFavoriteCoffees: mockGetFavoriteCoffees,
          toggleFavoriteCoffee: mockToggleFavoriteCoffee,
        );
      },
      act: (bloc) => bloc.add(const CoffeeFavoritesRequested()),
      expect: () => [
        const CoffeeLoadSuccess(
          favoriteCoffees: [
            Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee1.jpg',
              isFavorite: true,
            ),
            Coffee(
              id: '2',
              imageUrl: 'https://example.com/coffee2.jpg',
              isFavorite: true,
            ),
          ],
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'removes coffee from favorites when toggling favorite off',
      build: () {
        when(() => mockToggleFavoriteCoffee(any())).thenAnswer(
          (_) async => (
            const Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
            ),
            ImageCacheResult.success('cached:test.jpg'),
          ),
        );
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
          isFavorite: true,
        ),
        favoriteCoffees: [
          Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
        ],
      ),
      act: (bloc) => bloc.add(
        const CoffeeFavoriteToggled(
          Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
        ),
      ),
      expect: () => [
        // Optimistic update - removes from favorites
        //  (sync state is same, no duplicate)
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'does not add duplicate when coffee already in favorites',
      build: () {
        when(() => mockToggleFavoriteCoffee(any())).thenAnswer(
          (_) async => (
            const Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
            ImageCacheResult.success('cached:test.jpg'),
          ),
        );
        when(() => mockGetFavoriteCoffees()).thenAnswer(
          (_) async => [
            const Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
          ],
        );

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
        favoriteCoffees: [
          Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
        ],
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
        // Optimistic update - coffee already in list,
        //  no duplicate (sync state is same, no duplicate emit)
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
          favoriteCoffees: [
            Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
          ],
        ),
      ],
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'reverts state and shows error when cache result fails',
      build: () {
        when(() => mockToggleFavoriteCoffee(any())).thenAnswer(
          (_) async => (
            const Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
            ImageCacheResult.error(
              ImageCacheErrorType.network,
              'couldNotUpdateFavorites',
            ),
          ),
        );
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
        // Optimistic update
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
            isFavorite: true,
          ),
          favoriteCoffees: [
            Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
          ],
        ),
        // Revert to original state due to cache error
        const CoffeeLoadSuccess(
          currentCoffee: Coffee(
            id: '1',
            imageUrl: 'https://example.com/coffee.jpg',
          ),
        ),
        // Error state for snackbar with cache error message
        isA<CoffeeActionError>()
            .having(
              (e) => e.errorKey,
              'error',
              'couldNotUpdateFavorites',
            )
            .having(
              (e) => e.previousState,
              'previousState',
              const CoffeeLoadSuccess(
                currentCoffee: Coffee(
                  id: '1',
                  imageUrl: 'https://example.com/coffee.jpg',
                ),
              ),
            ),
      ],
    );

    group('CoffeeFavoriteSyncRequested', () {
      blocTest<CoffeeBloc, CoffeeState>(
        'syncs current coffee favorite status with favorites list',
        build: () {
          when(() => mockGetFavoriteCoffees()).thenAnswer(
            (_) async => [
              const Coffee(
                id: '1',
                imageUrl: 'https://example.com/coffee.jpg',
                isFavorite: true,
              ),
            ],
          );

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
        act: (bloc) => bloc.add(const CoffeeFavoriteSyncRequested()),
        expect: () => [
          const CoffeeLoadSuccess(
            currentCoffee: Coffee(
              id: '1',
              imageUrl: 'https://example.com/coffee.jpg',
              isFavorite: true,
            ),
            favoriteCoffees: [
              Coffee(
                id: '1',
                imageUrl: 'https://example.com/coffee.jpg',
                isFavorite: true,
              ),
            ],
          ),
        ],
      );

      blocTest<CoffeeBloc, CoffeeState>(
        'handles sync gracefully when get favorites throws exception',
        build: () {
          when(() => mockGetFavoriteCoffees()).thenThrow(
            Exception(
              'Network error',
            ),
          );

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
        act: (bloc) => bloc.add(const CoffeeFavoriteSyncRequested()),
        expect: () => <CoffeeState>[], // No state change on sync failure
      );

      blocTest<CoffeeBloc, CoffeeState>(
        'does nothing when current coffee is null',
        build: () {
          when(() => mockGetFavoriteCoffees()).thenAnswer((_) async => []);

          return CoffeeBloc(
            getRandomCoffee: mockGetRandomCoffee,
            getFavoriteCoffees: mockGetFavoriteCoffees,
            toggleFavoriteCoffee: mockToggleFavoriteCoffee,
          );
        },
        seed: () => const CoffeeLoadSuccess(
          
        ),
        act: (bloc) => bloc.add(const CoffeeFavoriteSyncRequested()),
        expect: () => <CoffeeState>[], // No state change when current coffee is
      );
    });
  });
}
