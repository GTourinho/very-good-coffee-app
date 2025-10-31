import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/presentation/pages/coffee_page.dart';
import 'package:coffee_app/src/coffee/presentation/pages/favorites_page.dart';
import 'package:coffee_app/src/coffee/presentation/widgets/main_navigation.dart';
import 'package:coffee_app/src/core/design_system/app_theme.dart';
import 'package:coffee_app/src/core/theme/theme_cubit.dart';
import 'package:coffee_app/src/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {}

class MockThemeCubit extends MockCubit<CoffeeRoast>
    implements ThemeCubit {}

void main() {
  late MockThemeCubit mockThemeCubit;
  late MockCoffeeBloc mockCoffeeBloc;

  setUp(() async {
    // Setup GetIt for test
    await GetIt.instance.reset();
    
    mockCoffeeBloc = MockCoffeeBloc();
    when(() => mockCoffeeBloc.state).thenReturn(const CoffeeInitial());
    when(() => mockCoffeeBloc.stream).thenAnswer(
      (_) => const Stream<CoffeeState>.empty(),
    );
    
    // Register CoffeeBloc in GetIt for the pages to use
    GetIt.instance.registerFactory<CoffeeBloc>(() => mockCoffeeBloc);

    mockThemeCubit = MockThemeCubit();
    when(() => mockThemeCubit.state).thenReturn(CoffeeRoast.mediumRoast);
    when(() => mockThemeCubit.stream).thenAnswer(
      (_) => const Stream<CoffeeRoast>.empty(),
    );
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
      ],
      child:  const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: MainNavigation(),
      ),
    );
  }

  group('MainNavigation', () {
    test('can be instantiated', () {
      // Non-const instantiation to cover constructor
      final navigation = MainNavigation(key: UniqueKey());
      expect(navigation, isA<Widget>());
    });

    testWidgets('can be instantiated and built', (tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: MainNavigation(key: UniqueKey()),
          ),
        ),
      );

      expect(find.byType(MainNavigation), findsOneWidget);
      expect(find.byType(CoffeePage), findsOneWidget);
    });

    testWidgets('renders CoffeePage by default', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CoffeePage), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('has navigation bar with three tabs', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.coffee), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('navigates to FavoritesPage when Favorites tab is tapped',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CoffeePage), findsOneWidget);
      expect(find.byType(FavoritesPage), findsNothing);

      await tester.tap(find.text('Favorites'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(FavoritesPage), findsOneWidget);
    });

    testWidgets('navigates back to CoffeePage when Home tab is tapped',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to Favorites
      await tester.tap(find.text('Favorites'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(FavoritesPage), findsOneWidget);

      // Navigate back to Home
      await tester.tap(find.text('Home'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CoffeePage), findsOneWidget);
    });

    testWidgets('updates selected index when tabs are tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final bottomNavBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.currentIndex, equals(0));

      await tester.tap(find.text('Favorites'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final updatedBottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar).last,
      );
      expect(updatedBottomNavBar.currentIndex, equals(1));
    });

    testWidgets('navigates to SettingsPage when Settings tab is tapped',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CoffeePage), findsOneWidget);
      expect(find.byType(SettingsPage), findsNothing);

      await tester.tap(find.text('Settings'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SettingsPage), findsOneWidget);
    });

    testWidgets('does not navigate when tapping the same tab', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Already on Home tab (index 0)
      expect(find.byType(CoffeePage), findsOneWidget);

      // Tap Home tab again
      await tester.tap(find.text('Home'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Should still be on CoffeePage (no navigation)
      expect(find.byType(CoffeePage), findsOneWidget);
    });

    testWidgets('navigates from Favorites to Settings', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to Favorites first
      await tester.tap(find.text('Favorites'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(FavoritesPage), findsOneWidget);

      // Now navigate to Settings (should use pushReplacement)
      await tester.tap(find.text('Settings'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.byType(FavoritesPage), findsNothing);
    });

    testWidgets('navigates from Settings to Favorites', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to Settings first
      await tester.tap(find.text('Settings'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SettingsPage), findsOneWidget);

      // Now navigate to Favorites (should use pushReplacement)
      await tester.tap(find.text('Favorites'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(FavoritesPage), findsOneWidget);
      expect(find.byType(SettingsPage), findsNothing);
    });

    testWidgets('does not navigate when tapping Favorites while on Favorites',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to Favorites first
      await tester.tap(find.text('Favorites'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(FavoritesPage), findsOneWidget);

      // Tap Favorites again
      await tester.tap(find.text('Favorites'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Should still be on FavoritesPage (no navigation)
      expect(find.byType(FavoritesPage), findsOneWidget);
    });

    testWidgets('does not navigate when tapping Settings while on Settings',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to Settings first
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SettingsPage), findsOneWidget);

      // Tap Settings again using the icon
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Should still be on SettingsPage (no navigation)
      expect(find.byType(SettingsPage), findsOneWidget);
    });

    testWidgets(
        'handles missing CoffeeBloc gracefully when navigation triggers sync',
        (tester) async {
      // Reset GetIt to ensure CoffeeBloc is not available
      await GetIt.instance.reset();
      
      // Create a simple scaffold without CoffeeBloc provider
      await tester.pumpWidget(
        BlocProvider<ThemeCubit>.value(
          value: mockThemeCubit,
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Test Page')),
                  body: ElevatedButton(
                    onPressed: () {
                      // Push a page with navigation bar
                      // ignore: discarded_futures
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const Scaffold(
                            body: Center(child: Text('Second Page')),
                            bottomNavigationBar:
                                AppBottomNavigation(currentIndex: 1),
                          ),
                        ),
                      );
                    },
                    child: const Text('Go to page 2'),
                  ),
                  bottomNavigationBar:
                      const AppBottomNavigation(currentIndex: 0),
                );
              },
            ),
          ),
        ),
      );

      // Navigate to second page
      await tester.tap(find.text('Go to page 2'));
      await tester.pumpAndSettle();

      // Tap Home button - this should trigger the catch block
      // because CoffeeBloc is not available
      await tester.tap(find.text('Home'));
      await tester.pump();

      // The app should not crash - exception should be caught
      final dynamic exception = tester.takeException();
      expect(exception, isNull);
      
      // Re-register for other tests
      GetIt.instance.registerFactory<CoffeeBloc>(() => mockCoffeeBloc);
    });
  });
}
