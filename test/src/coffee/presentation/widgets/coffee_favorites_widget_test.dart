import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/presentation/widgets/coffee_favorites_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {}

void main() {
  late MockCoffeeBloc mockCoffeeBloc;

  setUp(() {
    mockCoffeeBloc = MockCoffeeBloc();
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<CoffeeBloc>.value(
      value: mockCoffeeBloc,
      child: const MaterialApp(
        home: Scaffold(
          body: CoffeeFavoritesWidget(),
        ),
      ),
    );
  }

  group('CoffeeFavoritesWidget', () {
    testWidgets('shows empty state when no favorites', (tester) async {
      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No favorite coffees yet'), findsOneWidget);
      expect(
        find.text('Tap the heart icon on any coffee to add it to favorites'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('shows error state when load fails', (tester) async {
      const errorMessage = 'Failed to load';
      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadFailure(errorMessage),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Oops! Something went wrong'), findsOneWidget);
      expect(
        find.text('Could not load your favorite coffees. Please try again.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows list of favorite coffees', (tester) async {
      final favoriteCoffees = [
        const Coffee(
          id: 'coffee-1',
          imageUrl: 'https://example.com/coffee1.jpg',
          isFavorite: true,
        ),
        const Coffee(
          id: 'coffee-2',
          imageUrl: 'https://example.com/coffee2.jpg',
          isFavorite: true,
        ),
      ];

      when(() => mockCoffeeBloc.state).thenReturn(
        CoffeeLoadSuccess(favoriteCoffees: favoriteCoffees),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Coffee #coffee-1'), findsOneWidget);
      expect(find.text('Coffee #coffee-2'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNWidgets(2));
      expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));
    });

    testWidgets('dispatches CoffeeFavoriteToggled when delete is tapped',
        (tester) async {
      const coffee = Coffee(
        id: 'coffee-1',
        imageUrl: 'https://example.com/coffee1.jpg',
        isFavorite: true,
      );

      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(favoriteCoffees: [coffee]),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.delete_outline).first);
      verify(() => mockCoffeeBloc.add(const CoffeeFavoriteToggled(coffee)))
          .called(1);
    });

    testWidgets('shows file-based images correctly', (tester) async {
      const coffee = Coffee(
        id: 'coffee-1',
        imageUrl: '/path/to/cached/image.jpg',
        isFavorite: true,
      );

      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(favoriteCoffees: [coffee]),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Coffee #coffee-1'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
