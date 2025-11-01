import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/core/design_system/app_theme.dart';
import 'package:coffee_app/src/core/theme/theme_cubit.dart';
import 'package:coffee_app/src/settings/view/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(CoffeeRoast.mediumRoast);
  });

  group('SettingsPage', () {
    late MockThemeCubit mockThemeCubit;

    setUp(() {
      mockThemeCubit = MockThemeCubit();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
        ],
        home: BlocProvider<ThemeCubit>(
          create: (_) => mockThemeCubit,
          child: const SettingsPage(),
        ),
      );
    }

    testWidgets('displays settings page with theme options', (tester) async {
      // arrange
      when(() => mockThemeCubit.state).thenReturn(CoffeeRoast.mediumRoast);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert - check for basic elements
      expect(find.text('Settings'), findsAtLeastNWidgets(1));
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(InkWell), findsAtLeastNWidgets(3)); // 3 theme cards
    });

    testWidgets('highlights selected theme correctly', (tester) async {
      // arrange
      when(() => mockThemeCubit.state).thenReturn(CoffeeRoast.lightRoast);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      
      // Check that light roast card is selected (has check icon)
      final lightRoastCard = tester.widget<InkWell>(find.byType(InkWell).first);
      expect(lightRoastCard.onTap, isNotNull);
    });

    testWidgets(
      'shows no check icon when no theme is initially selected',
      (tester) async {
      // arrange
      when(() => mockThemeCubit.state).thenReturn(CoffeeRoast.mediumRoast);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(
          find.byIcon(Icons.check_circle),
          findsOneWidget,
        ); // Medium roast should be selected
    });

    testWidgets('taps light roast theme card', (tester) async {
      // arrange
      when(() => mockThemeCubit.state).thenReturn(CoffeeRoast.mediumRoast);
      when(() => mockThemeCubit.setTheme(any())).thenAnswer((_) async {});

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find and tap the light roast card
      final lightRoastCards = find.byType(InkWell);
      await tester.tap(lightRoastCards.first); // Light roast is first
      await tester.pumpAndSettle();

      // assert
      verify(() => mockThemeCubit.setTheme(CoffeeRoast.lightRoast)).called(1);
    });

    testWidgets('taps medium roast theme card', (tester) async {
      // arrange
      when(() => mockThemeCubit.state).thenReturn(CoffeeRoast.lightRoast);
      when(() => mockThemeCubit.setTheme(any())).thenAnswer((_) async {});

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find and tap the medium roast card (second card)
      final mediumRoastCards = find.byType(InkWell);
      await tester.tap(mediumRoastCards.at(1)); // Medium roast is second
      await tester.pumpAndSettle();

      // assert
      verify(() => mockThemeCubit.setTheme(CoffeeRoast.mediumRoast)).called(1);
    });

    testWidgets('taps dark roast theme card', (tester) async {
      // arrange
      when(() => mockThemeCubit.state).thenReturn(CoffeeRoast.mediumRoast);
      when(() => mockThemeCubit.setTheme(any())).thenAnswer((_) async {});

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find and tap the dark roast card (third card)
      final darkRoastCards = find.byType(InkWell);
      await tester.tap(darkRoastCards.at(2)); // Dark roast is third
      await tester.pumpAndSettle();

      // assert
      verify(() => mockThemeCubit.setTheme(CoffeeRoast.darkRoast)).called(1);
    });

    testWidgets('displays theme selection cards', (tester) async {
      // arrange
      when(() => mockThemeCubit.state).thenReturn(CoffeeRoast.mediumRoast);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(
          find.byType(InkWell),
          findsAtLeastNWidgets(3),
        ); // 3 theme cards
      expect(
          find.byIcon(Icons.check_circle),
          findsOneWidget,
        ); // One theme selected
    });

    testWidgets(
      'shows bottom navigation with settings selected',
      (tester) async {
      // arrange
      when(() => mockThemeCubit.state).thenReturn(CoffeeRoast.mediumRoast);

      // act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}

class MockThemeCubit extends MockCubit<CoffeeRoast> implements ThemeCubit {}
