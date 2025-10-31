import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocalizations Coverage', () {
    testWidgets('exercises all localization strings', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(),
        ),
      );

      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
      
      // Exercise all available localization strings
      expect(l10n.appTitle, isNotEmpty);
      expect(l10n.getYourFirstCoffee, isNotEmpty);
      expect(l10n.oopsSomethingWentWrong, isNotEmpty);
      expect(l10n.tryAgain, isNotEmpty);
      expect(l10n.favoriteCoffees, isNotEmpty);
      expect(l10n.settings, isNotEmpty);
      expect(l10n.failedToLoadImage, isNotEmpty);
      
      // Test that strings are not null or empty
      for (final locale in AppLocalizations.supportedLocales) {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(),
          ),
        );
        
        final localizedL10n = AppLocalizations.of(
          tester.element(find.byType(Scaffold)),
        );
        expect(localizedL10n.appTitle, isNotEmpty);
        expect(localizedL10n.getYourFirstCoffee, isNotEmpty);
        expect(localizedL10n.oopsSomethingWentWrong, isNotEmpty);
        expect(localizedL10n.tryAgain, isNotEmpty);
        expect(localizedL10n.favoriteCoffees, isNotEmpty);
        expect(localizedL10n.settings, isNotEmpty);
        expect(localizedL10n.failedToLoadImage, isNotEmpty);
      }
    });
  });
}
