// coverage:ignore-file
import 'dart:async';
import 'dart:io';

import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// Full-screen image viewer with zoom capabilities
class FullScreenImageViewer extends StatelessWidget {
  /// Creates a full-screen image viewer
  const FullScreenImageViewer({
    required this.imagePath,
    super.key,
  });

  /// Path to the image (URL or file path)
  final String imagePath;

  /// Show the full-screen image viewer
  static Future<void> show(
    BuildContext context,
    String imagePath,
  ) async {
    if (!context.mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => FullScreenImageViewer(imagePath: imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: imagePath.startsWith('http')
          ? PhotoView(
              imageProvider: NetworkImage(imagePath),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              onTapUp: (context, details, controllerValue) {
                Navigator.of(context).pop();
              },
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
              errorBuilder: (context, error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.failedToLoadImage,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          : PhotoView(
              imageProvider: FileImage(File(imagePath)),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              onTapUp: (context, details, controllerValue) {
                Navigator.of(context).pop();
              },
              errorBuilder: (context, error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.failedToLoadImage,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
