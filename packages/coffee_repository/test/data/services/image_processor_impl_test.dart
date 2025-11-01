import 'dart:typed_data';

import 'package:coffee_repository/src/data/services/image_processor_impl.dart';
import 'package:test/test.dart';
import 'package:image/image.dart' as img;

void main() {
  late ImageProcessorImpl imageProcessor;

  setUp(() {
    imageProcessor = const ImageProcessorImpl();
  });

  group('ImageProcessorImpl', () {
    test('creates processor instance', () {
      expect(imageProcessor, isA<ImageProcessorImpl>());
    });

    test('returns original bytes when image cannot be decoded', () async {
      final invalidBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

      final result = await imageProcessor.compressImage(invalidBytes, 85);

      expect(result, equals(invalidBytes));
    });

    test('compresses small image without resizing', () async {
      // Create a small image (100x100)
      final image = img.Image(width: 100, height: 100);
      img.fill(image, color: img.ColorRgb8(255, 0, 0));
      final bytes = Uint8List.fromList(img.encodePng(image));

      final result = await imageProcessor.compressImage(bytes, 85);

      expect(result, isNotEmpty);
      expect(result, isNot(equals(bytes)));

      // Verify result is a valid JPEG
      final decodedResult = img.decodeImage(result);
      expect(decodedResult, isNotNull);
      expect(decodedResult!.width, equals(100));
      expect(decodedResult.height, equals(100));
    });

    test('resizes and compresses large image (width > 800)', () async {
      // Create a large image (1000x600)
      final image = img.Image(width: 1000, height: 600);
      img.fill(image, color: img.ColorRgb8(0, 255, 0));
      final bytes = Uint8List.fromList(img.encodePng(image));

      final result = await imageProcessor.compressImage(bytes, 85);

      expect(result, isNotEmpty);

      // Verify result is resized
      final decodedResult = img.decodeImage(result);
      expect(decodedResult, isNotNull);
      expect(decodedResult!.width, equals(800));
      expect(decodedResult.height, lessThanOrEqualTo(600));
    });

    test('resizes and compresses large image (height > 800)', () async {
      // Create a large image (600x1000)
      final image = img.Image(width: 600, height: 1000);
      img.fill(image, color: img.ColorRgb8(0, 0, 255));
      final bytes = Uint8List.fromList(img.encodePng(image));

      final result = await imageProcessor.compressImage(bytes, 85);

      expect(result, isNotEmpty);

      // Verify result is resized
      final decodedResult = img.decodeImage(result);
      expect(decodedResult, isNotNull);
      expect(decodedResult!.width, lessThanOrEqualTo(600));
      expect(decodedResult.height, equals(800));
    });

    test('resizes and compresses very large image (both dimensions > 800)',
        () async {
      // Create a very large image (1200x1200)
      final image = img.Image(width: 1200, height: 1200);
      img.fill(image, color: img.ColorRgb8(255, 255, 0));
      final bytes = Uint8List.fromList(img.encodePng(image));

      final result = await imageProcessor.compressImage(bytes, 85);

      expect(result, isNotEmpty);

      // Verify result is resized
      final decodedResult = img.decodeImage(result);
      expect(decodedResult, isNotNull);
      expect(decodedResult!.width, lessThanOrEqualTo(800));
      expect(decodedResult.height, lessThanOrEqualTo(800));
    });

    test('handles exactly 800x800 image without resizing', () async {
      // Create an image exactly at max dimensions
      final image = img.Image(width: 800, height: 800);
      img.fill(image, color: img.ColorRgb8(255, 0, 255));
      final bytes = Uint8List.fromList(img.encodePng(image));

      final result = await imageProcessor.compressImage(bytes, 85);

      expect(result, isNotEmpty);

      // Verify result maintains dimensions
      final decodedResult = img.decodeImage(result);
      expect(decodedResult, isNotNull);
      expect(decodedResult!.width, equals(800));
      expect(decodedResult.height, equals(800));
    });

    test('applies different quality settings', () async {
      final image = img.Image(width: 100, height: 100);
      img.fill(image, color: img.ColorRgb8(255, 0, 0));
      final bytes = Uint8List.fromList(img.encodePng(image));

      final result85 = await imageProcessor.compressImage(bytes, 85);
      final result50 = await imageProcessor.compressImage(bytes, 50);
      final result10 = await imageProcessor.compressImage(bytes, 10);

      // Lower quality should result in smaller file size
      expect(result50.length, lessThan(result85.length));
      expect(result10.length, lessThan(result50.length));
    });

    test('returns original bytes on exception during processing', () async {
      // This test verifies the exception handling in the catch block
      // Using empty bytes should cause an exception
      final emptyBytes = Uint8List(0);

      final result = await imageProcessor.compressImage(emptyBytes, 85);

      expect(result, equals(emptyBytes));
    });
  });
}
