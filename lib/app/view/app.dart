import 'package:coffee_app/l10n/l10n.dart';
import 'package:coffee_app/src/coffee/view/widgets/main_navigation.dart';
import 'package:coffee_app/src/core/design_system/app_theme.dart';
import 'package:coffee_app/src/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// Main app widget.
class App extends StatelessWidget {
  /// Creates the app.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, CoffeeRoast>(
        builder: (context, roast) {
          final theme = AppTheme.getTheme(roast);
          
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme.copyWith(
              textTheme: GoogleFonts.poppinsTextTheme().merge(
                theme.textTheme,
              ),
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const MainNavigation(),
          );
        },
      ),
    );
  }
}
