/// Result of image cache operation
class ImageCacheResult {
  /// Creates an image cache result.
  const ImageCacheResult({
    this.success = false,
    this.filePath,
    this.errorType,
    this.errorMessage,
  });

  /// Creates a successful result.
  factory ImageCacheResult.success(String filePath) => ImageCacheResult(
        success: true,
        filePath: filePath,
      );

  /// Creates an error result.
  factory ImageCacheResult.error(
    ImageCacheErrorType errorType,
    String errorMessage,
  ) =>
      ImageCacheResult(
        errorType: errorType,
        errorMessage: errorMessage,
      );

  /// Whether the operation was successful.
  final bool success;

  /// The cached file path if successful.
  final String? filePath;

  /// The type of error if failed.
  final ImageCacheErrorType? errorType;

  /// The error message if failed.
  final String? errorMessage;
}

/// Types of errors that can occur during image caching
enum ImageCacheErrorType {
  /// Network connectivity issue
  network,

  /// HTTP request failed (non-200 status)
  http,

  /// Server returned an error
  server,

  /// File system operation failed
  filesystem,

  /// Unknown error occurred
  unknown,
}

/// Abstract interface for image cache service
abstract class ImageCacheService {
  /// Caches an image from URL.
  Future<ImageCacheResult> cacheImage(String imageUrl);

  /// Deletes a cached image.
  Future<void> deleteCachedImage(String imageUrl);

  /// Gets the full file path for a cached image identifier.
  Future<String?> getCachedImagePath(String imageIdentifier);
}
