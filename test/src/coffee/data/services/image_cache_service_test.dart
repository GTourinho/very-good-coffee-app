// Using sync File.exists() for tearDown simplicity in tests
// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:coffee_app/src/coffee/data/services/image_cache_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ImageCacheService imageCacheService;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('image_cache_test');
    imageCacheService = ImageCacheService(
      getDirectory: () async => tempDir,
    );
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('ImageCacheService', () {
    group('cacheImage', () {
      test(
        'returns existing path if imageUrl is already a file path',
        () async {
        const filePath = '/path/to/image.jpg';

        final result = await imageCacheService.cacheImage(filePath);

        expect(result, equals(filePath));
      });
    });

    group('getCachedImagePath', () {
      test('returns file path when image exists in cache', () async {
        const fileName = 'test.jpg';
        final cacheDir = Directory('${tempDir.path}/coffee_images');
        await cacheDir.create(recursive: true);
        final file = File('${cacheDir.path}/$fileName');
        await file.writeAsBytes([1, 2, 3]);

        final result = await imageCacheService.getCachedImagePath(
          'https://example.com/$fileName',
        );

        expect(result, equals(file.path));
      });

      test('returns null when image does not exist in cache', () async {
        const imageUrl = 'https://example.com/nonexistent.jpg';

        final result = await imageCacheService.getCachedImagePath(imageUrl);

        expect(result, isNull);
      });
    });

    group('deleteCachedImage', () {
      test('deletes cached image file when it exists', () async {
        const fileName = 'test.jpg';
        final cacheDir = Directory('${tempDir.path}/coffee_images');
        await cacheDir.create(recursive: true);
        final file = File('${cacheDir.path}/$fileName');
        await file.writeAsBytes([1, 2, 3]);

        await imageCacheService.deleteCachedImage(
          'https://example.com/$fileName',
        );

        expect(await file.exists(), isFalse);
      });

      test('does nothing when cached image does not exist', () async {
        const imageUrl = 'https://example.com/nonexistent.jpg';

        await expectLater(
          imageCacheService.deleteCachedImage(imageUrl),
          completes,
        );
      });
    });

    group('clearCache', () {
      test('deletes entire cache directory', () async {
        final cacheDir = Directory('${tempDir.path}/coffee_images');
        await cacheDir.create(recursive: true);
        final file = File('${cacheDir.path}/test.jpg');
        await file.writeAsBytes([1, 2, 3]);

        await imageCacheService.clearCache();

        expect(await cacheDir.exists(), isFalse);
      });
    });
  });
}
