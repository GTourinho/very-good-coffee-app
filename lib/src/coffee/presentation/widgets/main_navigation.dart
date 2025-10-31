import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/pages/coffee_page.dart';
import 'package:coffee_app/src/coffee/presentation/pages/favorites_page.dart';
import 'package:coffee_app/src/core/design_system/app_colors.dart';
import 'package:coffee_app/src/core/design_system/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main navigation widget for the app.
class MainNavigation extends StatelessWidget {
  /// Creates a main navigation widget.
  MainNavigation({super.key}) : _currentIndex = ValueNotifier(0);

  final ValueNotifier<int> _currentIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final coffeeBloc = context.read<CoffeeBloc>();
    
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, currentIndex, _) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: [
              CoffeePage(coffeeBloc: coffeeBloc),
              const FavoritesPage(),
            ],
          ),
          bottomNavigationBar: Container(
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
              onTap: (index) {
                _currentIndex.value = index;
              },
              backgroundColor: AppColors.primary,
              selectedItemColor: AppColors.onPrimary,
              unselectedItemColor: AppColors.grey300,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.coffee),
                  label: l10n.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite),
                  label: l10n.favorites,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
