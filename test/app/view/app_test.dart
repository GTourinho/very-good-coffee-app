import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_repository/src/domain/usecases/get_favorite_coffees.dart';
import 'package:coffee_repository/src/domain/usecases/get_random_coffee.dart';
import 'package:coffee_repository/src/domain/usecases/toggle_favorite_coffee.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/view/pages/coffee_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockGetRandomCoffee extends Mock implements GetRandomCoffee {}

class MockGetFavoriteCoffees extends Mock implements GetFavoriteCoffees {}

class MockToggleFavoriteCoffee extends Mock implements ToggleFavoriteCoffee {}

void main() {
  group('App', () {
    late MockGetRandomCoffee mockGetRandomCoffee;
    late MockGetFavoriteCoffees mockGetFavoriteCoffees;
    late MockToggleFavoriteCoffee mockToggleFavoriteCoffee;

    setUp(() async {
      await GetIt.instance.reset();
      mockGetRandomCoffee = MockGetRandomCoffee();
      mockGetFavoriteCoffees = MockGetFavoriteCoffees();
      mockToggleFavoriteCoffee = MockToggleFavoriteCoffee();
      
      // Register CoffeeBloc in GetIt for the pages to use
      GetIt.instance.registerFactory<CoffeeBloc>(() => CoffeeBloc(
        getRandomCoffee: mockGetRandomCoffee,
        getFavoriteCoffees: mockGetFavoriteCoffees,
        toggleFavoriteCoffee: mockToggleFavoriteCoffee,
      ),);
    });

    tearDown(() async {
      await GetIt.instance.reset();
    });

    testWidgets('renders CoffeePage', (tester) async {
      when(() => mockGetRandomCoffee()).thenAnswer(
        (_) async => throw Exception('Test'),
      );
      when(() => mockGetFavoriteCoffees()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: CoffeePage(),
        ),
      );
      expect(find.byType(CoffeePage), findsOneWidget);
    });
  });
}
