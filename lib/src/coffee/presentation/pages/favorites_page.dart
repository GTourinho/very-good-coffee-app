import 'dart:async';
import 'dart:io';

import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/presentation/widgets/main_navigation.dart';
import 'package:coffee_app/src/core/design_system/app_colors.dart';
import 'package:coffee_app/src/core/design_system/app_spacing.dart';
import 'package:coffee_app/src/core/design_system/app_text_styles.dart';
import 'package:coffee_app/src/core/services/user_feedback_service.dart';
import 'package:coffee_app/src/core/widgets/full_screen_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Favorites page widget.
class FavoritesPage extends StatelessWidget {
  /// Creates a favorites page.
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<CoffeeBloc>(),
      child: _FavoritesPageContent(),
    );
  }
}

class _FavoritesPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    context.read<CoffeeBloc>().add(const CoffeeFavoritesRequested());

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favoriteCoffees),
      ),
      body: BlocListener<CoffeeBloc, CoffeeState>(
        listenWhen: (previous, current) =>
            current is CoffeeLoadFailure || current is CoffeeActionError,
        listener: (context, state) {
          if (state is CoffeeLoadFailure) {
            UserFeedbackService.showSnackBar(
              context,
              state.error,
              type: FeedbackType.error,
            );
          } else if (state is CoffeeActionError) {
            UserFeedbackService.showSnackBar(
              context,
              state.error,
              type: FeedbackType.error,
            );
          }
        },
        child: BlocBuilder<CoffeeBloc, CoffeeState>(
          builder: (context, state) {
          if (state is CoffeeLoadSuccess) {
            final favorites = state.favoriteCoffees;

            if (favorites.isEmpty) {
              return Center(
                child: Padding(
                  padding: AppSpacing.paddingHorizontalMedium,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        size: AppSpacing.xxxl,
                        color: AppColors.coffeeLight,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.noFavoriteCoffees,
                        style: AppTextStyles.sectionTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        l10n.noFavoriteCoffeesDescription,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: AppSpacing.paddingAllMedium,
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final coffee = favorites[index];
                return FavoriteCard(coffee: coffee);
              },
            );
          }

          if (state is CoffeeLoadFailure) {
            return Center(
              child: Padding(
                padding: AppSpacing.paddingHorizontalMedium,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: AppSpacing.iconXLarge,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.oopsSomethingWentWrong,
                      style: AppTextStyles.sectionTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      state.error,
                      style: AppTextStyles.bodyText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
    );
  }
}

/// Widget for displaying a favorite coffee card.
class FavoriteCard extends StatelessWidget {
  /// Creates a favorite coffee card.
  const FavoriteCard({required this.coffee, super.key});

  /// The coffee to display.
  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      elevation: AppSpacing.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: InkWell(
        onTap: () => _showFullImage(context),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: AppSpacing.imageLargeSize,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.cardRadius),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.cardRadius),
                ),
                child: _FavoriteImage(imageUrl: coffee.imageUrl),
              ),
            ),
            Padding(
              padding: AppSpacing.paddingAllMedium,
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: AppColors.favorite,
                    size: AppSpacing.iconSmall,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.coffee(coffee.id),
                      style: AppTextStyles.cardTitle,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showFullImage(context),
                    icon: const Icon(Icons.fullscreen),
                    tooltip: 'View Full Size',
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<CoffeeBloc>().add(
                            CoffeeFavoriteToggled(coffee),
                          );
                    },
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Remove from Favorites',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context) {
    unawaited(FullScreenImageViewer.show(context, coffee.imageUrl));
  }
}

class _FavoriteImage extends StatelessWidget {
  const _FavoriteImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final isFilePath = imageUrl.startsWith('/');

    if (isFilePath) {
      // Load from file
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return ColoredBox(
            color: AppColors.grey300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.broken_image,
                    size: AppSpacing.iconMedium,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Failed to load image',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // Load from network (fallback if caching didn't complete yet)
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return ColoredBox(
            color: AppColors.grey300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.broken_image,
                    size: AppSpacing.iconMedium,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Failed to load image',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
