import 'dart:typed_data';

import 'package:coffee_repository/src/data/services/image_processor.dart';
import 'package:image/image.dart' as img;

/// Implementation using the image package
class ImageProcessorImpl implements ImageProcessor {
  /// Creates an image processor implementation
  const ImageProcessorImpl();

  static const int _maxImageWidth = 800;
  static const int _maxImageHeight = 800;

  @override
  Future<Uint8List> compressImage(Uint8List bytes, int quality) async {
    try {
      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) {
        return bytes;
      }

      // Only resize if image is larger than max dimensions
      if (originalImage.width <= _maxImageWidth &&
          originalImage.height <= _maxImageHeight) {
        // Image is already small enough, just compress
        final compressedBytes = img.encodeJpg(
          originalImage,
          quality: quality,
        );
        return compressedBytes;
      }

      final resizedImage = img.copyResize(
        originalImage,
        width:
            originalImage.width > _maxImageWidth ? _maxImageWidth : null,
        height: originalImage.height > _maxImageHeight
            ? _maxImageHeight
            : null,
        interpolation: img.Interpolation.average,
      );

      final compressedBytes = img.encodeJpg(
        resizedImage,
        quality: quality,
      );

      return compressedBytes;
    // We need to ignore this because the catch might be an Error
    // And we can safely just return original bytes if so
    // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      return bytes;
    }
  }
}
