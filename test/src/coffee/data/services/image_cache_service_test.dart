import 'dart:io';
import 'dart:typed_data';

import 'package:coffee_app/src/coffee/data/services/http_client.dart';
import 'package:coffee_app/src/coffee/data/services/image_cache_service.dart';
import 'package:coffee_app/src/coffee/data/services/image_cache_service_impl.dart';
import 'package:coffee_app/src/coffee/data/services/image_processor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockSimpleHttpClient extends Mock implements SimpleHttpClient {}

class MockImageProcessor extends Mock implements ImageProcessor {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue(Uint8List(0));
  });

  late ImageCacheServiceImpl imageCacheService;
  late Directory tempDir;
  late MockSimpleHttpClient mockHttpClient;
  late MockImageProcessor mockImageProcessor;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('image_cache_test');
    mockHttpClient = MockSimpleHttpClient();
    mockImageProcessor = MockImageProcessor();
    imageCacheService = ImageCacheServiceImpl(
      httpClient: mockHttpClient,
      imageProcessor: mockImageProcessor,
      getDirectory: () async => tempDir,
    );
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('ImageCacheServiceImpl', () {
    test('creates service with default dependencies', () {
      final service = ImageCacheServiceImpl();

      expect(service, isA<ImageCacheServiceImpl>());
    });

    test('creates service with custom dependencies', () {
      final service = ImageCacheServiceImpl(
        httpClient: mockHttpClient,
        imageProcessor: mockImageProcessor,
        getDirectory: () async => tempDir,
      );

      expect(service, isA<ImageCacheServiceImpl>());
    });
  });

  group('ImageCacheService', () {
    group('cacheImage', () {
      test(
        'returns existing path if imageUrl is already a file path',
        () async {
          const filePath = '/path/to/image.jpg';

          final result = await imageCacheService.cacheImage(filePath);

          expect(result.success, isTrue);
          expect(result.filePath, equals(filePath));
          verifyNever(() => mockHttpClient.get(any()));
          verifyNever(() => mockImageProcessor.compressImage(any(), any()));
        },
      );

      test('downloads and caches network image successfully', () async {
        const imageUrl = 'https://example.com/test.jpg';
        const fileName = 'test.jpg';
        final originalBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        final compressedBytes = Uint8List.fromList([6, 7, 8, 9, 10]);

        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response.bytes(originalBytes, 200));
        when(() => mockImageProcessor.compressImage(originalBytes, 85))
            .thenAnswer((_) async => compressedBytes);

        final result = await imageCacheService.cacheImage(imageUrl);

        expect(result.success, isTrue);
        expect(result.filePath, equals('cached:$fileName'));
        verify(() => mockHttpClient.get(Uri.parse(imageUrl))).called(1);
        verify(() => mockImageProcessor.compressImage(originalBytes, 85))
            .called(1);

        // Verify file was written
        final expectedFile = File('${tempDir.path}/coffee_images/$fileName');
        expect(expectedFile.existsSync(), isTrue);
        expect(expectedFile.readAsBytesSync(), equals(compressedBytes));
      });

      test('handles HTTP error response', () async {
        const imageUrl = 'https://example.com/test.jpg';

        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        final result = await imageCacheService.cacheImage(imageUrl);

        expect(result.success, isFalse);
        expect(result.errorType, ImageCacheErrorType.http);
        expect(result.errorMessage, contains('Failed to download image'));
        verify(() => mockHttpClient.get(Uri.parse(imageUrl))).called(1);
        verifyNever(() => mockImageProcessor.compressImage(any(), any()));
      });

      test('handles network exceptions', () async {
        const imageUrl = 'https://example.com/test.jpg';

        when(() => mockHttpClient.get(any()))
            .thenThrow(const SocketException('Network error'));

        final result = await imageCacheService.cacheImage(imageUrl);

        expect(result.success, isFalse);
        expect(result.errorType, ImageCacheErrorType.network);
        expect(result.errorMessage, contains('Network error'));
        verify(() => mockHttpClient.get(Uri.parse(imageUrl))).called(1);
        verifyNever(() => mockImageProcessor.compressImage(any(), any()));
      });

      test('handles HTTP exceptions', () async {
        const imageUrl = 'https://example.com/test.jpg';

        when(() => mockHttpClient.get(any()))
            .thenThrow(const HttpException('HTTP error'));

        final result = await imageCacheService.cacheImage(imageUrl);

        expect(result.success, isFalse);
        expect(result.errorType, ImageCacheErrorType.server);
        expect(result.errorMessage, contains('Server error'));
        verify(() => mockHttpClient.get(Uri.parse(imageUrl))).called(1);
        verifyNever(() => mockImageProcessor.compressImage(any(), any()));
      });

      test('handles unknown exceptions', () async {
        const imageUrl = 'https://example.com/test.jpg';

        when(() => mockHttpClient.get(any()))
            .thenThrow(Exception('Unknown error'));

        final result = await imageCacheService.cacheImage(imageUrl);

        expect(result.success, isFalse);
        expect(result.errorType, ImageCacheErrorType.unknown);
        expect(result.errorMessage, contains('unexpected error'));
        verify(() => mockHttpClient.get(Uri.parse(imageUrl))).called(1);
        verifyNever(() => mockImageProcessor.compressImage(any(), any()));
      });

      test('handles image processing exceptions', () async {
        const imageUrl = 'https://example.com/test.jpg';
        final originalBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response.bytes(originalBytes, 200));
        when(() => mockImageProcessor.compressImage(originalBytes, 85))
            .thenThrow(Exception('Processing failed'));

        final result = await imageCacheService.cacheImage(imageUrl);

        expect(result.success, isFalse);
        expect(result.errorType, ImageCacheErrorType.unknown);
        expect(result.errorMessage, contains('unexpected error'));
        verify(() => mockHttpClient.get(Uri.parse(imageUrl))).called(1);
        verify(() => mockImageProcessor.compressImage(originalBytes, 85))
            .called(1);
      });

      test('handles empty imageUrl', () async {
        const emptyUrl = '';

        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        final result = await imageCacheService.cacheImage(emptyUrl);

        expect(result.success, isFalse);
        expect(result.errorType, ImageCacheErrorType.http);
        verify(() => mockHttpClient.get(any())).called(1);
      });

      test('handles directory access exceptions', () async {
        const imageUrl = 'https://example.com/test.jpg';
        final originalBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        final compressedBytes = Uint8List.fromList([6, 7, 8, 9, 10]);

        final faultyService = ImageCacheServiceImpl(
          httpClient: mockHttpClient,
          imageProcessor: mockImageProcessor,
          getDirectory: () async => throw Exception('Directory access failed'),
        );

        when(() => mockHttpClient.get(any()))
            .thenAnswer((_) async => http.Response.bytes(originalBytes, 200));
        when(() => mockImageProcessor.compressImage(originalBytes, 85))
            .thenAnswer((_) async => compressedBytes);

        final result = await faultyService.cacheImage(imageUrl);

        expect(result.success, isFalse);
        expect(result.errorType, ImageCacheErrorType.unknown);
        expect(result.errorMessage, contains('unexpected error'));
        verify(() => mockHttpClient.get(Uri.parse(imageUrl))).called(1);
        verify(() => mockImageProcessor.compressImage(originalBytes, 85))
            .called(1);
      });
    });

    group('getCachedImagePath', () {
      test('returns file path when image exists in cache', () async {
        const fileName = 'test.jpg';
        const imageUrl = 'https://example.com/$fileName';
        final cacheDir = Directory('${tempDir.path}/coffee_images');
        await cacheDir.create(recursive: true);
        final file = File('${cacheDir.path}/$fileName');
        await file.writeAsBytes([1, 2, 3]);

        final result = await imageCacheService.getCachedImagePath(imageUrl);

        expect(result, equals(file.path));
      });

      test('returns null when image does not exist in cache', () async {
        const imageUrl = 'https://example.com/nonexistent.jpg';

        final result = await imageCacheService.getCachedImagePath(imageUrl);

        expect(result, isNull);
      });

      test('returns file path when image exists in cache with cached: prefix',
          () async {
        const fileName = 'test.jpg';
        final cacheDir = Directory('${tempDir.path}/coffee_images');
        await cacheDir.create(recursive: true);
        final file = File('${cacheDir.path}/$fileName');
        await file.writeAsBytes([1, 2, 3]);

        final result =
            await imageCacheService.getCachedImagePath('cached:$fileName');

        expect(result, equals(file.path));
      });

      test('returns null for cached: prefix when file does not exist',
          () async {
        final result = await imageCacheService
            .getCachedImagePath('cached:nonexistent.jpg');

        expect(result, isNull);
      });

      test('returns null for non-http and non-cached identifiers', () async {
        final result =
            await imageCacheService.getCachedImagePath('invalid-identifier');

        expect(result, isNull);
      });

      test('returns null for identifiers starting with other protocols',
          () async {
        final result = await imageCacheService
            .getCachedImagePath('ftp://example.com/test.jpg');

        expect(result, isNull);
      });

      test(
        'returns null for identifiers that start with neither cached nor http',
        () async {
          final result = await imageCacheService
              .getCachedImagePath('file://local/path.jpg');

          expect(result, isNull);
        },
      );

      test('handles exceptions in getCachedImagePath gracefully', () async {
        final faultyService = ImageCacheServiceImpl(
          httpClient: mockHttpClient,
          imageProcessor: mockImageProcessor,
          getDirectory: () async {
            throw Exception('Directory access failed');
          },
        );

        final result =
            await faultyService.getCachedImagePath('cached:test.jpg');

        expect(result, isNull);
      });

      test('handles exceptions in getCachedImagePath for http URLs', () async {
        final faultyService = ImageCacheServiceImpl(
          httpClient: mockHttpClient,
          imageProcessor: mockImageProcessor,
          getDirectory: () async {
            throw Exception('Directory access failed');
          },
        );

        final result = await faultyService
            .getCachedImagePath('https://example.com/test.jpg');

        expect(result, isNull);
      });
    });

    group('deleteCachedImage', () {
      test('deletes cached image file when it exists', () async {
        const fileName = 'test.jpg';
        const imageUrl = 'https://example.com/$fileName';
        final cacheDir = Directory('${tempDir.path}/coffee_images');
        await cacheDir.create(recursive: true);
        final file = File('${cacheDir.path}/$fileName');
        await file.writeAsBytes([1, 2, 3]);

        await imageCacheService.deleteCachedImage(imageUrl);

        expect(file.existsSync(), isFalse);
      });

      test('does nothing when cached image does not exist', () async {
        const imageUrl = 'https://example.com/nonexistent.jpg';

        await expectLater(
          imageCacheService.deleteCachedImage(imageUrl),
          completes,
        );
      });

      test('handles exceptions when directory access fails', () async {
        final faultyService = ImageCacheServiceImpl(
          httpClient: mockHttpClient,
          imageProcessor: mockImageProcessor,
          getDirectory: () async {
            throw Exception('Directory access failed');
          },
        );

        expect(
          () async => faultyService.deleteCachedImage('test.jpg'),
          throwsException,
        );
      });

      test('deletes cached image with URL format', () async {
        const fileName = 'test.jpg';
        final cacheDir = Directory('${tempDir.path}/coffee_images');
        await cacheDir.create(recursive: true);
        final file = File('${cacheDir.path}/$fileName');
        await file.writeAsBytes([1, 2, 3]);

        await imageCacheService
            .deleteCachedImage('https://example.com/$fileName');

        expect(file.existsSync(), isFalse);
      });

      test('handles deletion of non-existent file gracefully', () async {
        const imageUrl = 'https://example.com/nonexistent.jpg';

        await expectLater(
          imageCacheService.deleteCachedImage(imageUrl),
          completes,
        );
      });
    });

    group('ImageCacheErrorType', () {
      test('has all expected error types', () {
        const errorTypes = ImageCacheErrorType.values;

        expect(errorTypes, contains(ImageCacheErrorType.network));
        expect(errorTypes, contains(ImageCacheErrorType.http));
        expect(errorTypes, contains(ImageCacheErrorType.server));
        expect(errorTypes, contains(ImageCacheErrorType.filesystem));
        expect(errorTypes, contains(ImageCacheErrorType.unknown));
      });
    });

    group('default directory getter', () {
      test('uses default directory when no custom getter provided', () async {
        TestWidgetsFlutterBinding.ensureInitialized();

        final defaultService = ImageCacheServiceImpl(
          httpClient: mockHttpClient,
          imageProcessor: mockImageProcessor,
        );

        // Test getCachedImagePath with default directory getter
        final result =
            await defaultService.getCachedImagePath('cached:test.jpg');

        // Should return null (file doesn't exist) but not throw
        expect(result, isNull);
      });
    });
  });
}
