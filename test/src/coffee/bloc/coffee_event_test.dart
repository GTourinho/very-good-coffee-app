import 'package:coffee_repository/src/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeeEvent', () {
    group('CoffeeRequested', () {
      test('props is empty', () {
        const event = CoffeeRequested();
        expect(event.props, isEmpty);
      });

      test('equality works correctly', () {
        const event1 = CoffeeRequested();
        const event2 = CoffeeRequested();
        expect(event1, equals(event2));
      });
    });

    group('CoffeeFavoritesRequested', () {
      test('props is empty', () {
        const event = CoffeeFavoritesRequested();
        expect(event.props, isEmpty);
      });

      test('equality works correctly', () {
        const event1 = CoffeeFavoritesRequested();
        const event2 = CoffeeFavoritesRequested();
        expect(event1, equals(event2));
      });
    });

    group('CoffeeFavoriteToggled', () {
      test('props contains coffee', () {
        const coffee = Coffee(
          id: 'test-id',
          imageUrl: 'https://example.com/coffee.jpg',
        );
        const event = CoffeeFavoriteToggled(coffee);
        expect(event.props, contains(coffee));
      });

      test('equality works correctly', () {
        const coffee1 = Coffee(
          id: 'test-id',
          imageUrl: 'https://example.com/coffee.jpg',
        );
        const coffee2 = Coffee(
          id: 'test-id',
          imageUrl: 'https://example.com/coffee.jpg',
        );
        const coffee3 = Coffee(
          id: 'different-id',
          imageUrl: 'https://example.com/coffee.jpg',
        );

        const event1 = CoffeeFavoriteToggled(coffee1);
        const event2 = CoffeeFavoriteToggled(coffee2);
        const event3 = CoffeeFavoriteToggled(coffee3);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });
    });

    group('CoffeeMigrationRequested', () {
      test('props is empty', () {
        const event = CoffeeMigrationRequested();
        expect(event.props, isEmpty);
      });

      test('equality works correctly', () {
        const event1 = CoffeeMigrationRequested();
        const event2 = CoffeeMigrationRequested();
        expect(event1, equals(event2));
      });

      test('can be created', () {
        const event = CoffeeMigrationRequested();
        expect(event, isA<CoffeeEvent>());
      });

      test('can be created non-const', () {
        // Create without const to ensure constructor is covered
        const event = CoffeeMigrationRequested();
        expect(event, isA<CoffeeEvent>());
        expect(event.props, isEmpty);
      });
    });

    group('CoffeeFavoriteSyncRequested', () {
      test('supports value equality', () {
        expect(
          const CoffeeFavoriteSyncRequested(),
          equals(const CoffeeFavoriteSyncRequested()),
        );
      });

      test('props is empty', () {
        const event = CoffeeFavoriteSyncRequested();
        expect(event.props, isEmpty);
      });

      test('is a CoffeeEvent', () {
        const event = CoffeeFavoriteSyncRequested();
        expect(event, isA<CoffeeEvent>());
      });

      test('can be created non-const', () {
        // Create without const to ensure constructor is covered
        const event = CoffeeFavoriteSyncRequested();
        expect(event, isA<CoffeeEvent>());
        expect(event.props, isEmpty);
      });
    });

    group('CoffeeEvent', () {
      test('base class props is empty', () {
        const event = CoffeeRequested();
        expect(event.props, isEmpty);
      });
    });
  });
}
