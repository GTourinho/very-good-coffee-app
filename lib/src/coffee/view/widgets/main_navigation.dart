import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/view/pages/coffee_page.dart';
import 'package:coffee_app/src/coffee/view/pages/favorites_page.dart';
import 'package:coffee_app/src/core/design_system/app_colors.dart';
import 'package:coffee_app/src/core/design_system/app_spacing.dart';
import 'package:coffee_app/src/settings/view/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main navigation widget for the app.
class MainNavigation extends StatelessWidget {
  /// Creates a main navigation widget.
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return const CoffeePage();
  }
}

/// Bottom navigation bar widget to be used in all pages
class AppBottomNavigation extends StatelessWidget {
  /// Creates bottom navigation bar
  const AppBottomNavigation({
    required this.currentIndex,
    super.key,
  });

  /// Current selected index
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: AppSpacing.lg,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) async {
          if (index == 0 && currentIndex != 0) {
            // Go back to home
            Navigator.of(context).popUntil((route) => route.isFirst);
            // Sync favorite status after returning to home
            // Only trigger if CoffeeBloc is available in the widget tree
            if (context.mounted) {
              try {
                context
                    .read<CoffeeBloc>()
                    .add(const CoffeeFavoriteSyncRequested());
              } on Object catch (_) {
                // CoffeeBloc not available in current context, ignore
                // Catches both ProviderNotFoundException and Exception
              }
            }
          } else if (index == 1 && currentIndex != 1) {
            // Navigate to Favorites
            if (currentIndex == 0) {
              // Push Favorites on top of Home
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const FavoritesPage(),
                ),
              );
              // Sync favorite status when returning from favorites
              if (context.mounted) {
                try {
                  context
                      .read<CoffeeBloc>()
                      .add(const CoffeeFavoriteSyncRequested());
                } on Object catch (_) {
                  // CoffeeBloc not available, ignore
                  // Catches both ProviderNotFoundException and Exception
                }
              }
            } else {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => const FavoritesPage(),
                ),
              );
            }
          } else if (index == 2 && currentIndex != 2) {
            // Navigate to Settings
            if (currentIndex == 0) {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SettingsPage(),
                ),
              );
              // Sync favorite status when returning from settings
              if (context.mounted) {
                try {
                  context
                      .read<CoffeeBloc>()
                      .add(const CoffeeFavoriteSyncRequested());
                } on Object catch (_) {
                  // CoffeeBloc not available, ignore
                  // Catches both ProviderNotFoundException and Exception
                }
              }
            } else {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => const SettingsPage(),
                ),
              );
            }
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.coffee),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: l10n.favorites,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
