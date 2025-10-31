import 'package:coffee_app/src/coffee/data/models/coffee_model.dart';
import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:flutter_test/flutter_test.dart';

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
  });
}
