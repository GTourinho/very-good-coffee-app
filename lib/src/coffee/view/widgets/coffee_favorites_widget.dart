import 'dart:io';

import 'package:coffee_repository/src/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template coffee_favorites_widget}
/// Widget displaying a list of favorite coffee images.
/// {@endtemplate}
class CoffeeFavoritesWidget extends StatelessWidget {
  /// {@macro coffee_favorites_widget}
  const CoffeeFavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoffeeBloc, CoffeeState>(
      builder: (context, state) {
        var favoriteCoffees = <Coffee>[];

        if (state is CoffeeLoadSuccess) {
          favoriteCoffees = state.favoriteCoffees;
        } else if (state is CoffeeLoadFailure) {
          return const _ErrorState();
        }

        if (favoriteCoffees.isEmpty) {
          return const _EmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoriteCoffees.length,
          itemBuilder: (context, index) {
            final coffee = favoriteCoffees[index];
            return _FavoriteCard(coffee: coffee);
          },
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            'Could not load your favorite coffees. Please try again.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No favorite coffees yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the heart icon on any coffee to add it to favorites',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.coffee});

  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: _CoffeeImage(imageUrl: coffee.imageUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Coffee #${coffee.id}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<CoffeeBloc>().add(
                          CoffeeFavoriteToggled(coffee),
                        );
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Remove from favorites',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoffeeImage extends StatelessWidget {
  const _CoffeeImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final isFilePath = imageUrl.startsWith('/');
    
    if (isFilePath) {
      return Image.file(
        File(imageUrl),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.broken_image, size: 48),
            ),
          );
        },
      );
    } else {
      return Image.network(
        imageUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        // Optimize memory - decode at thumbnail size
        cacheWidth: 400,
        cacheHeight: 300,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.broken_image, size: 48),
            ),
          );
        },
      );
    }
  }
}
