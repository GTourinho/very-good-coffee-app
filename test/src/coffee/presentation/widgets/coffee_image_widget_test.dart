import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/presentation/widgets/coffee_image_widget.dart';
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

  Widget createWidgetUnderTest({
    required VoidCallback onRefresh,
    Coffee? coffee,
  }) {
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
        home: Scaffold(
          body: CoffeeImageWidget<Coffee>(
            coffee: coffee,
            onRefresh: onRefresh,
          ),
        ),
      ),
    );
  }

  group('CoffeeImageWidget', () {
    testWidgets('shows empty state when coffee is null', (tester) async {
      var refreshCalled = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          onRefresh: () => refreshCalled = true,
        ),
      );

      expect(find.byIcon(Icons.coffee), findsOneWidget);
      expect(find.text('Get Your First Coffee'), findsOneWidget);

      await tester.tap(find.text('Get Your First Coffee'));
      expect(refreshCalled, isTrue);
    });

    testWidgets('shows coffee image with network URL', (tester) async {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/coffee.jpg',
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          onRefresh: () {},
          coffee: coffee,
        ),
      );

      expect(find.byType(Image), findsWidgets);
      expect(find.text('New Coffee'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('shows coffee image with file path', (tester) async {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: '/path/to/image.jpg',
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          onRefresh: () {},
          coffee: coffee,
        ),
      );

      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('shows filled heart when coffee is favorite', (tester) async {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/coffee.jpg',
        isFavorite: true,
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          onRefresh: () {},
          coffee: coffee,
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('calls onRefresh when New Coffee button is tapped',
        (tester) async {
      var refreshCalled = false;
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/coffee.jpg',
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          onRefresh: () => refreshCalled = true,
          coffee: coffee,
        ),
      );

      await tester.tap(find.text('New Coffee'));
      expect(refreshCalled, isTrue);
    });

    testWidgets('dispatches CoffeeFavoriteToggled when heart is tapped',
        (tester) async {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/coffee.jpg',
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          onRefresh: () {},
          coffee: coffee,
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite_border));
      verify(() => mockCoffeeBloc.add(const CoffeeFavoriteToggled(coffee)))
          .called(1);
    });
  });
}
