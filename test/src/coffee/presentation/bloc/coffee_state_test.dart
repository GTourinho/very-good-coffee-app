import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeeState', () {
    group('CoffeeInitial', () {
      test('props is empty', () {
        const state = CoffeeInitial();
        expect(state.props, isEmpty);
      });

      test('equality works correctly', () {
        const state1 = CoffeeInitial();
        const state2 = CoffeeInitial();
        expect(state1, equals(state2));
      });
    });

    group('CoffeeLoadInProgress', () {
      test('props is empty', () {
        const state = CoffeeLoadInProgress();
        expect(state.props, isEmpty);
      });

      test('equality works correctly', () {
        const state1 = CoffeeLoadInProgress();
        const state2 = CoffeeLoadInProgress();
        expect(state1, equals(state2));
      });
    });

    group('CoffeeLoadSuccess', () {
      test('props contains currentCoffee and favoriteCoffees', () {
        const coffee = Coffee(
          id: 'test-id',
          imageUrl: 'https://example.com/coffee.jpg',
        );
        const state = CoffeeLoadSuccess(
          currentCoffee: coffee,
          favoriteCoffees: [coffee],
        );
        expect(state.props, containsAll([coffee, [coffee]]));
      });

      test('copyWith creates new state with updated values', () {
        const coffee1 = Coffee(
          id: 'coffee-1',
          imageUrl: 'https://example.com/coffee1.jpg',
        );
        const coffee2 = Coffee(
          id: 'coffee-2',
          imageUrl: 'https://example.com/coffee2.jpg',
        );

        const originalState = CoffeeLoadSuccess(
          currentCoffee: coffee1,
          favoriteCoffees: [coffee1],
        );

        final updatedState = originalState.copyWith(
          currentCoffee: coffee2,
          favoriteCoffees: [coffee2],
        );

        expect(updatedState.currentCoffee, equals(coffee2));
        expect(updatedState.favoriteCoffees, equals([coffee2]));
      });

      test('copyWith with no parameters returns same state', () {
        const coffee = Coffee(
          id: 'test-id',
          imageUrl: 'https://example.com/coffee.jpg',
        );
        const originalState = CoffeeLoadSuccess(
          currentCoffee: coffee,
        );

        final copiedState = originalState.copyWith();

        expect(copiedState, equals(originalState));
      });

      test('equality works correctly', () {
        const coffee = Coffee(
          id: 'test-id',
          imageUrl: 'https://example.com/coffee.jpg',
        );
        const state1 = CoffeeLoadSuccess(
          currentCoffee: coffee,
          favoriteCoffees: [coffee],
        );
        const state2 = CoffeeLoadSuccess(
          currentCoffee: coffee,
          favoriteCoffees: [coffee],
        );
        const state3 = CoffeeLoadSuccess(
          currentCoffee: coffee,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });

    group('CoffeeLoadFailure', () {
      test('props contains error', () {
        const state = CoffeeLoadFailure('Test error');
        expect(state.props, contains('Test error'));
      });

      test('equality works correctly', () {
        const state1 = CoffeeLoadFailure('Error');
        const state2 = CoffeeLoadFailure('Error');
        const state3 = CoffeeLoadFailure('Different error');

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });

    group('CoffeeActionError', () {
      test('props contains error and previousState', () {
        const coffee = Coffee(
          id: 'test-id',
          imageUrl: 'https://example.com/coffee.jpg',
        );
        const previousState = CoffeeLoadSuccess(currentCoffee: coffee);
        const state = CoffeeActionError(
          error: 'Action error',
          previousState: previousState,
        );
        expect(state.props, containsAll(['Action error', previousState]));
      });

      test('equality works correctly', () {
        const coffee = Coffee(
          id: 'test-id',
          imageUrl: 'https://example.com/coffee.jpg',
        );
        const previousState1 = CoffeeLoadSuccess(currentCoffee: coffee);
        const previousState2 = CoffeeLoadSuccess(currentCoffee: coffee);

        const state1 = CoffeeActionError(
          error: 'Error',
          previousState: previousState1,
        );
        const state2 = CoffeeActionError(
          error: 'Error',
          previousState: previousState2,
        );
        const state3 = CoffeeActionError(
          error: 'Different error',
          previousState: previousState1,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });
  });
}
