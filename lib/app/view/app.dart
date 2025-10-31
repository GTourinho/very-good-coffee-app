import 'package:coffee_app/l10n/l10n.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/widgets/main_navigation.dart';
import 'package:coffee_app/src/core/design_system/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

/// Main app widget.
class App extends StatelessWidget {
  /// Creates the app.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme().merge(
          AppTheme.light.textTheme,
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (_) => GetIt.instance<CoffeeBloc>(),
        child: MainNavigation(),
      ),
    );
  }
}
