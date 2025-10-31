import 'package:coffee_app/l10n/l10n.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_error_keys.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeeLoadFailureX', () {
    Widget createApp(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      );
    }

    testWidgets('returns localized message for loadCoffee', (tester) async {
      await tester.pumpWidget(
        createApp(
          Builder(
            builder: (context) {
              const state = CoffeeLoadFailure(CoffeeErrorKeys.loadCoffee);
              final message = state.getLocalizedMessage(context);
              return Text(message);
            },
          ),
        ),
      );

      expect(
        find.text('Could not load coffee. Please try again.'),
        findsOneWidget,
      );
    });

    testWidgets('returns localized message for loadFavorites', (tester) async {
      await tester.pumpWidget(
        createApp(
          Builder(
            builder: (context) {
              const state = CoffeeLoadFailure(CoffeeErrorKeys.loadFavorites);
              final message = state.getLocalizedMessage(context);
              return Text(message);
            },
          ),
        ),
      );

      expect(
        find.text('Could not load your favorite coffees. Please try again.'),
        findsOneWidget,
      );
    });

    testWidgets('returns error key as fallback for unknown key',
        (tester) async {
      await tester.pumpWidget(
        createApp(
          Builder(
            builder: (context) {
              const state = CoffeeLoadFailure('unknownErrorKey');
              final message = state.getLocalizedMessage(context);
              return Text(message);
            },
          ),
        ),
      );

      expect(find.text('unknownErrorKey'), findsOneWidget);
    });
  });

  group('CoffeeActionErrorX', () {
    Widget createApp(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      );
    }

    testWidgets('returns localized message for updateFavorites',
        (tester) async {
      await tester.pumpWidget(
        createApp(
          Builder(
            builder: (context) {
              const previousState = CoffeeLoadSuccess();
              const state = CoffeeActionError(
                errorKey: CoffeeErrorKeys.updateFavorites,
                previousState: previousState,
              );
              final message = state.getLocalizedMessage(context);
              return Text(message);
            },
          ),
        ),
      );

      expect(
        find.text('Oops! Could not update your favorites. Please try again'),
        findsOneWidget,
      );
    });

    testWidgets('returns error key as fallback for unknown key',
        (tester) async {
      await tester.pumpWidget(
        createApp(
          Builder(
            builder: (context) {
              const previousState = CoffeeLoadSuccess();
              const state = CoffeeActionError(
                errorKey: 'unknownActionError',
                previousState: previousState,
              );
              final message = state.getLocalizedMessage(context);
              return Text(message);
            },
          ),
        ),
      );

      expect(find.text('unknownActionError'), findsOneWidget);
    });
  });
}
