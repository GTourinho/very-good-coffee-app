import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_app/src/core/design_system/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template theme_cubit}
/// Cubit for managing the app's theme (coffee roast selection).
/// {@endtemplate}
class ThemeCubit extends Cubit<CoffeeRoast> {
  /// {@macro theme_cubit}
  ThemeCubit({
    Future<SharedPreferences> Function()? preferencesGetter,
  })  : _preferencesGetter =
            preferencesGetter ?? SharedPreferences.getInstance,
        super(CoffeeRoast.mediumRoast) {
    // Load theme asynchronously without awaiting in constructor
    unawaited(_loadTheme());
  }

  final Future<SharedPreferences> Function() _preferencesGetter;

  static const _themeKey = 'coffee_roast_theme';

  /// Loads the saved theme from shared preferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await _preferencesGetter();
      final savedTheme = prefs.getString(_themeKey);
      
      if (savedTheme != null) {
        final roast = CoffeeRoast.values.firstWhere(
          (r) => r.name == savedTheme,
          orElse: () => CoffeeRoast.mediumRoast,
        );
        emit(roast);
      }
    } on Exception catch (_) {
      // If loading fails, keep default theme
    }
  }

  /// Changes the theme to the specified roast
  Future<void> setTheme(CoffeeRoast roast) async {
    try {
      final prefs = await _preferencesGetter();
      await prefs.setString(_themeKey, roast.name);
      emit(roast);
    } on Exception catch (_) {
      // If saving fails, still emit the theme
      emit(roast);
    }
  }
}
