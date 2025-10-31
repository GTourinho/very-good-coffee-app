import 'package:coffee_app/src/coffee/data/services/http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  late MockHttpClient mockClient;
  late SimpleHttpClient simpleHttpClient;

  setUp(() {
    mockClient = MockHttpClient();
    simpleHttpClient = SimpleHttpClient(mockClient);
  });

  group('SimpleHttpClient', () {
    test('creates instance with http client', () {
      expect(simpleHttpClient, isA<SimpleHttpClient>());
    });

    test('delegates get call to underlying http client', () async {
      final testUri = Uri.parse('https://example.com/test');
      final expectedResponse = http.Response('test body', 200);

      when(() => mockClient.get(testUri))
          .thenAnswer((_) async => expectedResponse);

      final response = await simpleHttpClient.get(testUri);

      expect(response, equals(expectedResponse));
      expect(response.statusCode, equals(200));
      expect(response.body, equals('test body'));
      verify(() => mockClient.get(testUri)).called(1);
    });

    test('propagates errors from underlying http client', () async {
      final testUri = Uri.parse('https://example.com/error');

      when(() => mockClient.get(testUri))
          .thenThrow(Exception('Network error'));

      expect(
        () => simpleHttpClient.get(testUri),
        throwsException,
      );

      verify(() => mockClient.get(testUri)).called(1);
    });

    test('handles successful response with different status codes', () async {
      final testUri = Uri.parse('https://example.com/notfound');
      final expectedResponse = http.Response('Not Found', 404);

      when(() => mockClient.get(testUri))
          .thenAnswer((_) async => expectedResponse);

      final response = await simpleHttpClient.get(testUri);

      expect(response.statusCode, equals(404));
      expect(response.body, equals('Not Found'));
      verify(() => mockClient.get(testUri)).called(1);
    });

    test('handles response with bytes', () async {
      final testUri = Uri.parse('https://example.com/image');
      final bytes = [1, 2, 3, 4, 5];
      final expectedResponse = http.Response.bytes(bytes, 200);

      when(() => mockClient.get(testUri))
          .thenAnswer((_) async => expectedResponse);

      final response = await simpleHttpClient.get(testUri);

      expect(response.statusCode, equals(200));
      expect(response.bodyBytes, equals(bytes));
      verify(() => mockClient.get(testUri)).called(1);
    });
  });
}
