import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/data/models/coffee_model.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/presentation/pages/favorites_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeeBloc extends Mock implements CoffeeBloc {}

void main() {
  group('FavoritesPage', () {
    late MockCoffeeBloc mockCoffeeBloc;

    setUp(() {
      mockCoffeeBloc = MockCoffeeBloc();
    });

    testWidgets('displays cached image when available', (tester) async {
      const coffee = CoffeeModel(
        id: 'test_id',
        imageUrl: 'https://example.com/test.jpg',
      );

      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(
          currentCoffee: coffee,
          favoriteCoffees: [coffee],
        ),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => Stream.value(
          const CoffeeLoadSuccess(
            currentCoffee: coffee,
            favoriteCoffees: [coffee],
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<CoffeeBloc>.value(
            value: mockCoffeeBloc,
            child: const FavoritesPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Coffee #test_id'), findsOneWidget);
    });

    testWidgets('shows empty state when no favorites', (tester) async {
      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(
          
        ),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => Stream.value(
          const CoffeeLoadSuccess(
            
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<CoffeeBloc>.value(
            value: mockCoffeeBloc,
            child: const FavoritesPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No favorite coffees yet'), findsOneWidget);
    });
  });
}
