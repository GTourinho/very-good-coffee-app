// We can ignore this rule because we are using async io
// outside of the UI
// ignore_for_file: avoid_slow_async_io

import 'dart:io';
import 'dart:typed_data';

import 'package:coffee_app/src/core/services/user_feedback_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';


/// Service for caching images with user feedback.
class ImageCacheService {
  /// Creates an image cache service.
  ImageCacheService({Future<Directory> Function()? getDirectory})
      : _getDirectory = getDirectory;

  final Future<Directory> Function()? _getDirectory;

  static const int _maxImageWidth = 800;
  static const int _maxImageHeight = 800;
  static const int _jpegQuality = 85;

  Future<Directory> get _directory async {
    final getDir = _getDirectory;
    if (getDir != null) {
      return getDir();
    }
    return getApplicationDocumentsDirectory();
  }

  /// Caches an image from URL with user feedback.
  /// If context is null, caches silently without showing feedback.
  Future<String?> cacheImage(
    String imageUrl, {
    BuildContext? context,
  }) async {
    try {
      // Check if it's already a cached file path
      if (imageUrl.startsWith('/')) {
        return imageUrl; // Already cached, return the path
      }

      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode != 200) {
        if (context != null && context.mounted) {
          UserFeedbackService.showSnackBar(
            context,
            'Failed to download image. Please try again.',
            type: FeedbackType.error,
          );
        }
        return null;
      }

      final bytes = response.bodyBytes;
      final compressedBytes = await _compressImage(bytes);
      
      final directory = await _directory;
      final fileName = imageUrl.split('/').last;
      final file = File('${directory.path}/coffee_images/$fileName');

      await file.parent.create(recursive: true);
      await file.writeAsBytes(compressedBytes);
      
      return file.path;
    } on SocketException {
      if (context != null && context.mounted) {
        UserFeedbackService.showSnackBar(
          context,
          'Network error. Please check your connection.',
          type: FeedbackType.error,
        );
      }
      return null;
    } on HttpException {
      if (context != null && context.mounted) {
        UserFeedbackService.showSnackBar(
          context,
          'Server error. Please try again later.',
          type: FeedbackType.error,
        );
      }
      return null;
    } on Exception {
      if (context != null && context.mounted) {
        UserFeedbackService.showSnackBar(
          context,
          'An unexpected error occurred.',
          type: FeedbackType.error,
        );
      }
      return null;
    }
  }

  /// Compresses image bytes.
  Future<Uint8List> _compressImage(Uint8List bytes) async {
    try {
      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) {
        // Can't decode, return original bytes
        return bytes;
      }

      // Only resize if image is larger than max dimensions
      if (originalImage.width <= _maxImageWidth &&
          originalImage.height <= _maxImageHeight) {
        // Image is already small enough, just compress
        final compressedBytes = img.encodeJpg(
          originalImage,
          quality: _jpegQuality,
        );
        return compressedBytes;
      }

      final resizedImage = img.copyResize(
        originalImage,
        width: originalImage.width > _maxImageWidth ? _maxImageWidth : null,
        height: originalImage.height > _maxImageHeight ? _maxImageHeight : null,
        interpolation: img.Interpolation.average,
      );

      final compressedBytes = img.encodeJpg(
        resizedImage,
        quality: _jpegQuality,
      );

      return compressedBytes;
    } on Exception {
      // If compression fails, return original bytes
      return bytes;
    }
  }

  /// Clears all cached images with user feedback.
  /// If context is null, clears silently without showing feedback.
  Future<void> clearCache({BuildContext? context}) async {
    try {
      final directory = await _directory;
      final cacheDir = Directory('${directory.path}/coffee_images');

      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } on FileSystemException {
      if (context != null && context.mounted) {
        UserFeedbackService.showSnackBar(
          context,
          'Failed to clear cache. Please try again.',
          type: FeedbackType.error,
        );
      }
    } on Exception {
      if (context != null && context.mounted) {
        UserFeedbackService.showSnackBar(
          context,
          'An unexpected error occurred.',
          type: FeedbackType.error,
        );
      }
    }
  }

  /// Gets cached image path.
  Future<String?> getCachedImagePath(String imageUrl) async {
    final directory = await _directory;
    final fileName = imageUrl.split('/').last;
    final file = File('${directory.path}/coffee_images/$fileName');

    if (await file.exists()) {
      return file.path;
    }
    return null;
  }

  /// Deletes a cached image.
  Future<void> deleteCachedImage(String imageUrl) async {
    final directory = await _directory;
    final fileName = imageUrl.split('/').last;
    final file = File('${directory.path}/coffee_images/$fileName');

    if (await file.exists()) {
      await file.delete(recursive: true);
    }
  }
}
