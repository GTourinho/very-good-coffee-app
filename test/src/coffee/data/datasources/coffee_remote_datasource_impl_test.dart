import 'package:coffee_app/src/coffee/data/datasources/coffee_remote_datasource_impl.dart';
import 'package:coffee_app/src/coffee/data/models/coffee_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  group('CoffeeRemoteDataSourceImpl', () {
    late MockHttpClient mockHttpClient;
    late CoffeeRemoteDataSourceImpl dataSource;

    setUp(() {
      mockHttpClient = MockHttpClient();
      dataSource = CoffeeRemoteDataSourceImpl(client: mockHttpClient);
    });

    test(
      'should return CoffeeModel when the response code is 200 (success)',
      () async {
        // arrange
        const tCoffeeModel = CoffeeModel(
          id: 'random',
          imageUrl: 'https://coffee.alexflipnote.dev/random.jpg',
        );

        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response(
                  '{"id":"1","file":"https://coffee.alexflipnote.dev/random.jpg"}',
                  200,
                ),
              );

        // act
        final result = await dataSource();

        // assert
        expect(result, tCoffeeModel);
        verify(() => mockHttpClient.get(
              Uri.parse('https://coffee.alexflipnote.dev/random.json'),
            ),
          ).called(1);
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test(
      'should throw an Exception when the response code is 404 or other',
      () async {
        // arrange
        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        // assert
        expect(() => dataSource(), throwsA(isA<Exception>()));
        verify(() => mockHttpClient.get(
              Uri.parse('https://coffee.alexflipnote.dev/random.json'),
            ),
          ).called(1);
        verifyNoMoreInteractions(mockHttpClient);
      },
    );
  });
}
