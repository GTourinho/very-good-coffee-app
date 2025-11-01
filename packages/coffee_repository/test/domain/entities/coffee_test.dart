import 'package:coffee_repository/src/domain/entities/coffee.dart';
import 'package:test/test.dart';

void main() {
  group('Coffee', () {
    test('creates Coffee with required properties', () {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/coffee.jpg',
      );

      expect(coffee.id, equals('test-id'));
      expect(coffee.imageUrl, equals('https://example.com/coffee.jpg'));
      expect(coffee.isFavorite, isFalse);
    });

    test('creates Coffee with isFavorite set to true', () {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/coffee.jpg',
        isFavorite: true,
      );

      expect(coffee.id, equals('test-id'));
      expect(coffee.imageUrl, equals('https://example.com/coffee.jpg'));
      expect(coffee.isFavorite, isTrue);
    });

    test('copyWith creates new Coffee with updated values', () {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/coffee.jpg',
      );

      final updatedCoffee = coffee.copyWith(isFavorite: true);

      expect(updatedCoffee.id, equals(coffee.id));
      expect(updatedCoffee.imageUrl, equals(coffee.imageUrl));
      expect(updatedCoffee.isFavorite, isTrue);
    });

    test('copyWith with no parameters returns same Coffee', () {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/coffee.jpg',
      );

      final copiedCoffee = coffee.copyWith();

      expect(copiedCoffee, equals(coffee));
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

      expect(coffee1, equals(coffee2));
      expect(coffee1, isNot(equals(coffee3)));
    });

    test('props contains all properties', () {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/coffee.jpg',
        isFavorite: true,
      );

      expect(
        coffee.props,
        containsAll([coffee.id, coffee.imageUrl, coffee.isFavorite]),
      );
    });
  });
}
