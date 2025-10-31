import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/domain/usecases/get_favorite_coffees.dart';
import 'package:coffee_app/src/coffee/domain/usecases/get_random_coffee.dart';
import 'package:coffee_app/src/coffee/domain/usecases/toggle_favorite_coffee.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/pages/coffee_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetRandomCoffee extends Mock implements GetRandomCoffee {}

class MockGetFavoriteCoffees extends Mock implements GetFavoriteCoffees {}

class MockToggleFavoriteCoffee extends Mock implements ToggleFavoriteCoffee {}

void main() {
  group('App', () {
    late MockGetRandomCoffee mockGetRandomCoffee;
    late MockGetFavoriteCoffees mockGetFavoriteCoffees;
    late MockToggleFavoriteCoffee mockToggleFavoriteCoffee;

    setUp(() {
      mockGetRandomCoffee = MockGetRandomCoffee();
      mockGetFavoriteCoffees = MockGetFavoriteCoffees();
      mockToggleFavoriteCoffee = MockToggleFavoriteCoffee();
    });

    testWidgets('renders CoffeePage', (tester) async {
      when(() => mockGetRandomCoffee()).thenAnswer(
        (_) async => throw Exception('Test'),
      );
      when(() => mockGetFavoriteCoffees()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider(
            create: (_) => CoffeeBloc(
              getRandomCoffee: mockGetRandomCoffee,
              getFavoriteCoffees: mockGetFavoriteCoffees,
              toggleFavoriteCoffee: mockToggleFavoriteCoffee,
            ),
            child: Builder(
              builder: (context) {
                return CoffeePage(
                  coffeeBloc: context.read<CoffeeBloc>(),
                );
              },
            ),
          ),
        ),
      );
      expect(find.byType(CoffeePage), findsOneWidget);
    });
  });
}
