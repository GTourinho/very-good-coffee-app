import 'dart:typed_data';

/// Abstraction for image processing to enable better testing
// ignore: one_member_abstracts
abstract class ImageProcessor {
  /// Compresses image bytes with given quality
  Future<Uint8List> compressImage(Uint8List bytes, int quality);
}
