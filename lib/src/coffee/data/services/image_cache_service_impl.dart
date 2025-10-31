import 'dart:io';

import 'package:coffee_app/src/coffee/data/services/http_client.dart';
import 'package:coffee_app/src/coffee/data/services/image_cache_service.dart';
import 'package:coffee_app/src/coffee/data/services/image_processor.dart';
import 'package:coffee_app/src/coffee/data/services/image_processor_impl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Implementation of ImageCacheService with injected dependencies
/// for better testability.
class ImageCacheServiceImpl implements ImageCacheService {
  /// Creates an image cache service.
  ImageCacheServiceImpl({
    SimpleHttpClient? httpClient,
    ImageProcessor? imageProcessor,
    Future<Directory> Function()? getDirectory,
  })  : _httpClient = httpClient ?? SimpleHttpClient(http.Client()),
        _imageProcessor = imageProcessor ?? const ImageProcessorImpl(),
        _getDirectory = getDirectory;

  final SimpleHttpClient _httpClient;
  final ImageProcessor _imageProcessor;
  final Future<Directory> Function()? _getDirectory;

  static const int _jpegQuality = 85;

  Future<Directory> get _directory async {
    final getDir = _getDirectory;
    if (getDir != null) {
      return getDir();
    }
    return getApplicationDocumentsDirectory();
  }

  @override
  Future<ImageCacheResult> cacheImage(String imageUrl) async {
    try {
      // Check if it's already a cached file path
      if (imageUrl.startsWith('/')) {
        return ImageCacheResult.success(imageUrl);
      }

      final response = await _httpClient.get(Uri.parse(imageUrl));

      if (response.statusCode != 200) {
        return ImageCacheResult.error(
          ImageCacheErrorType.http,
          'Failed to download image. Please try again.',
        );
      }

      final bytes = response.bodyBytes;
      final compressedBytes =
          await _imageProcessor.compressImage(bytes, _jpegQuality);

      final directory = await _directory;
      final fileName = imageUrl.split('/').last;
      final file = File('${directory.path}/coffee_images/$fileName');

      await file.parent.create(recursive: true);
      await file.writeAsBytes(compressedBytes);

      return ImageCacheResult.success('cached:$fileName');
    } on SocketException {
      return ImageCacheResult.error(
        ImageCacheErrorType.network,
        'Network error. Please check your connection.',
      );
    } on HttpException {
      return ImageCacheResult.error(
        ImageCacheErrorType.server,
        'Server error. Please try again later.',
      );
    } on Exception {
      return ImageCacheResult.error(
        ImageCacheErrorType.unknown,
        'An unexpected error occurred.',
      );
    }
  }

  @override
  Future<void> deleteCachedImage(String imageUrl) async {
    final directory = await _directory;
    final fileName = imageUrl.split('/').last;
    final file = File('${directory.path}/coffee_images/$fileName');

    if (file.existsSync()) {
      await file.delete(recursive: true);
    }
  }

  @override
  Future<String?> getCachedImagePath(String imageIdentifier) async {
    try {
      final directory = await _directory;

      // Handle cached format: 'cached:filename'
      if (imageIdentifier.startsWith('cached:')) {
        final fileName =
            imageIdentifier.substring(7); // Remove 'cached:' prefix
        final file = File('${directory.path}/coffee_images/$fileName');
        if (file.existsSync()) {
          return file.path;
        }
        return null;
      }

      // Handle network URLs - check if already cached
      if (imageIdentifier.startsWith('http')) {
        final fileName = imageIdentifier.split('/').last;
        final file = File('${directory.path}/coffee_images/$fileName');
        if (file.existsSync()) {
          return file.path;
        }
        return null;
      }

      return null;
    } on Exception {
      return null;
    }
  }
}
