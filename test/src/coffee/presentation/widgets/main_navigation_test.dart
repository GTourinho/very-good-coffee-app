import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/presentation/pages/coffee_page.dart';
import 'package:coffee_app/src/coffee/presentation/pages/favorites_page.dart';
import 'package:coffee_app/src/coffee/presentation/widgets/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {}

void main() {
  late MockCoffeeBloc mockCoffeeBloc;

  setUp(() {
    mockCoffeeBloc = MockCoffeeBloc();
    when(() => mockCoffeeBloc.state).thenReturn(const CoffeeInitial());
    when(() => mockCoffeeBloc.stream).thenAnswer(
      (_) => const Stream<CoffeeState>.empty(),
    );
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<CoffeeBloc>.value(
      value: mockCoffeeBloc,
      child: MaterialApp(
        localizationsDelegates: const [
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
    testWidgets('renders CoffeePage by default', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CoffeePage), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('has navigation bar with two tabs', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.coffee), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
    });

    testWidgets('navigates to FavoritesPage when Favorites tab is tapped',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CoffeePage), findsOneWidget);
      expect(find.byType(FavoritesPage), findsNothing);

      await tester.tap(find.text('Favorites'));
      await tester.pump();

      expect(find.byType(CoffeePage), findsNothing);
      expect(find.byType(FavoritesPage), findsOneWidget);
    });

    testWidgets('navigates back to CoffeePage when Home tab is tapped',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate to Favorites
      await tester.tap(find.text('Favorites'));
      await tester.pump();

      expect(find.byType(FavoritesPage), findsOneWidget);

      // Navigate back to Home
      await tester.tap(find.text('Home'));
      await tester.pump();

      expect(find.byType(CoffeePage), findsOneWidget);
      expect(find.byType(FavoritesPage), findsNothing);
    });

    testWidgets('updates selected index when tabs are tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final bottomNavBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNavBar.currentIndex, equals(0));

      await tester.tap(find.text('Favorites'));
      await tester.pump();

      final updatedBottomNavBar =
          tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(updatedBottomNavBar.currentIndex, equals(1));
    });
  });
}
