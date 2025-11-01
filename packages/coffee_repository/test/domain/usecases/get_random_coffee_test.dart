import 'package:coffee_repository/src/domain/entities/coffee.dart';
import 'package:coffee_repository/src/domain/repositories/coffee_repository.dart';
import 'package:coffee_repository/src/domain/usecases/get_random_coffee.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  group('GetRandomCoffee', () {
    late MockCoffeeRepository mockRepository;
    late GetRandomCoffee usecase;

    setUp(() {
      mockRepository = MockCoffeeRepository();
      usecase = GetRandomCoffee(mockRepository);
    });

    const tCoffee = Coffee(
      id: '1',
      imageUrl: 'https://example.com/coffee.jpg',
    );

    test(
      'should get coffee from the repository',
      () async {
        // arrange
        when(() => mockRepository.getRandomCoffee())
            .thenAnswer((_) async => tCoffee);

        // act
        final result = await usecase();

        // assert
        expect(result, tCoffee);
        verify(() => mockRepository.getRandomCoffee()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
