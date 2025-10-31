import 'dart:async';
import 'dart:io';

import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_event.dart';
import 'package:coffee_app/src/core/design_system/app_colors.dart';
import 'package:coffee_app/src/core/design_system/app_spacing.dart';
import 'package:coffee_app/src/core/design_system/app_text_styles.dart';
import 'package:coffee_app/src/core/widgets/full_screen_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget for displaying coffee images.
class CoffeeImageWidget<T extends Coffee> extends StatelessWidget {
  /// Creates a coffee image widget.
  const CoffeeImageWidget({
    required this.coffee,
    required this.onRefresh,
    super.key,
  });

  /// The coffee to display.
  final Coffee? coffee;

  /// Callback for refresh action.
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    if (coffee == null) {
      return _EmptyState(onRefresh: onRefresh);
    }

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: AppSpacing.lg,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              child: _CoffeeImage(
                imageUrl: coffee!.imageUrl,
                onTap: () => _showFullImage(context, coffee!.imageUrl),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _ActionButtons(
          coffee: coffee!,
          onRefresh: onRefresh,
        ),
      ],
    );
  }

  Future<void> _showFullImage(BuildContext context, String imagePath) async {
    await FullScreenImageViewer.show(context, imagePath);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.coffee,
            size: 64,
            color: Colors.brown,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRefresh,
            child: const Text('Get Your First Coffee'),
          ),
        ],
      ),
    );
  }
}

class _CoffeeImage extends StatelessWidget {
  const _CoffeeImage({
    required this.imageUrl,
    required this.onTap,
  });

  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isFilePath = imageUrl.startsWith('/');

    Widget imageWidget;

    if (isFilePath) {
      imageWidget = Image.file(
        File(imageUrl),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const _ErrorWidget(),
      );
    } else {
      imageWidget = Image.network(
        imageUrl,
        fit: BoxFit.contain,
        // Optimize memory usage by decoding at display size
        cacheWidth: 800,
        cacheHeight: 800,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => const _ErrorWidget(),
      );
    }

    return InkWell(
      onTap: onTap,
      child: imageWidget,
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.broken_image,
            size: AppSpacing.iconXLarge,
            color: AppColors.grey500,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.failedToLoadImage,
            style: AppTextStyles.bodyText,
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.coffee,
    required this.onRefresh,
  });

  final Coffee coffee;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.newCoffee),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.paddingSmall,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.paddingSmall),
        FloatingActionButton(
          mini: true,
          onPressed: () {
            context.read<CoffeeBloc>().add(
                  CoffeeFavoriteToggled(coffee),
                );
          },
          backgroundColor: AppColors.surface.withValues(alpha: 0.9),
          child: Icon(
            coffee.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: coffee.isFavorite ? AppColors.favorite : AppColors.grey500,
          ),
        ),
      ],
    );
  }
}
