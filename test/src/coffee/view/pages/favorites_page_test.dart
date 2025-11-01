import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_error_keys.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/view/pages/favorites_page.dart';
import 'package:coffee_repository/src/data/models/coffee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {}

void main() {
  late MockCoffeeBloc mockCoffeeBloc;

  setUp(() async {
    await GetIt.instance.reset();
    mockCoffeeBloc = MockCoffeeBloc();
    GetIt.instance.registerFactory<CoffeeBloc>(() => mockCoffeeBloc);
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: FavoritesPage(),
    );
  }

  group('FavoritesPage', () {
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
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Coffee #test_id'), findsOneWidget);
    });

    testWidgets('shows empty state when no favorites', (tester) async {
      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No favorite coffees yet'), findsOneWidget);
    });

    testWidgets('shows error state when CoffeeLoadFailure', (tester) async {
      const errorMessage =
          'Could not load your favorite coffees. Please try again.';
      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadFailure(CoffeeErrorKeys.loadFavorites),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Oops! Something went wrong'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets(
      'shows loading indicator when not in success or failure state',
      (tester) async {
        when(() => mockCoffeeBloc.state).thenReturn(const CoffeeInitial());
        when(() => mockCoffeeBloc.stream).thenAnswer(
          (_) => const Stream<CoffeeState>.empty(),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('shows snackbar when CoffeeLoadFailure is emitted', (
      tester,
    ) async {
      const errorMessage =
          'Could not load your favorite coffees. Please try again.';
      when(() => mockCoffeeBloc.state).thenReturn(const CoffeeLoadSuccess());
      whenListen(
        mockCoffeeBloc,
        Stream.fromIterable([
          const CoffeeLoadFailure(CoffeeErrorKeys.loadFavorites),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsAtLeastNWidgets(1));
    });

    testWidgets('shows snackbar when CoffeeActionError is emitted', (
      tester,
    ) async {
      const errorMessage =
          'Oops! Could not update your favorites. Please try again';
      const previousState = CoffeeLoadSuccess(
        currentCoffee: CoffeeModel(
          id: 'test',
          imageUrl: 'https://example.com/test.jpg',
        ),
      );

      when(() => mockCoffeeBloc.state).thenReturn(previousState);
      whenListen(
        mockCoffeeBloc,
        Stream.fromIterable([
          const CoffeeActionError(
            errorKey: CoffeeErrorKeys.updateFavorites,
            previousState: previousState,
          ),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('dispatches CoffeeFavoritesRequested on load', (tester) async {
      when(() => mockCoffeeBloc.state).thenReturn(const CoffeeLoadSuccess());
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      verify(
        () => mockCoffeeBloc.add(const CoffeeFavoritesRequested()),
      ).called(1);
    });

    testWidgets(
      'dispatches CoffeeFavoriteToggled when delete button is tapped',
      (tester) async {
        const coffee = CoffeeModel(
          id: 'test_id',
          imageUrl: 'https://example.com/test.jpg',
          isFavorite: true,
        );

        when(() => mockCoffeeBloc.state).thenReturn(
          const CoffeeLoadSuccess(favoriteCoffees: [coffee]),
        );
        when(() => mockCoffeeBloc.stream).thenAnswer(
          (_) => const Stream<CoffeeState>.empty(),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        // Find and tap the delete button
        await tester.tap(find.byIcon(Icons.delete_outline));
        verify(
          () => mockCoffeeBloc.add(const CoffeeFavoriteToggled(coffee)),
        ).called(1);
      },
    );

    testWidgets('shows file-based image when imageUrl is file path', (
      tester,
    ) async {
      const coffee = CoffeeModel(
        id: 'test_id',
        imageUrl: '/path/to/local/image.jpg',
        isFavorite: true,
      );

      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(favoriteCoffees: [coffee]),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shows network image when imageUrl is URL', (tester) async {
      const coffee = CoffeeModel(
        id: 'test_id',
        imageUrl: 'https://example.com/test.jpg',
        isFavorite: true,
      );

      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(favoriteCoffees: [coffee]),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shows error UI when file image fails to load', (tester) async {
      const coffee = CoffeeModel(
        id: 'test_id',
        imageUrl: '/nonexistent/invalid/path/image.jpg',
        isFavorite: true,
      );

      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(favoriteCoffees: [coffee]),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Allow image to attempt loading and fail
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();

      // The error builder should show the broken image icon and text
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
      expect(find.text('Failed to load image'), findsOneWidget);
    });
  });
}
