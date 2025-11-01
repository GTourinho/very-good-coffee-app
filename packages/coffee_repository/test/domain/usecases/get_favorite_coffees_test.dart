import 'package:coffee_repository/src/domain/entities/coffee.dart';
import 'package:coffee_repository/src/domain/repositories/coffee_repository.dart';
import 'package:coffee_repository/src/domain/usecases/get_favorite_coffees.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  group('GetFavoriteCoffees', () {
    late MockCoffeeRepository mockRepository;
    late GetFavoriteCoffees usecase;

    setUp(() {
      mockRepository = MockCoffeeRepository();
      usecase = GetFavoriteCoffees(mockRepository);
    });

    final tCoffees = [
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

    test(
      'should get favorite coffees from the repository',
      () async {
        // arrange
        when(() => mockRepository.getFavoriteCoffees())
            .thenAnswer((_) async => tCoffees);

        // act
        final result = await usecase();

        // assert
        expect(result, tCoffees);
        verify(() => mockRepository.getFavoriteCoffees()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
