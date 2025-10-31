import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/data/models/coffee_model.dart';
import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/presentation/pages/coffee_page.dart';
import 'package:coffee_app/src/coffee/presentation/widgets/coffee_image_widget.dart';
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
      home: CoffeePage(),
    );
  }

  group('CoffeePage', () {
    testWidgets('renders initial state with welcome message', (tester) async {
      when(() => mockCoffeeBloc.state).thenReturn(const CoffeeInitial());
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // App title appears in AppBar and page content
      expect(find.text('Very Good Coffee App'), findsAtLeastNWidgets(1));
      expect(find.text('Get Your First Coffee'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      when(() => mockCoffeeBloc.state)
          .thenReturn(const CoffeeLoadInProgress());
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows CoffeeImageWidget when coffee is loaded',
        (tester) async {
      const testCoffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/coffee.jpg',
      );

      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(currentCoffee: testCoffee),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CoffeeImageWidget<CoffeeModel>), findsOneWidget);
    });

    testWidgets('shows empty state when no coffee in success state',
        (tester) async {
      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // App title appears in AppBar and page content
      expect(find.text('Very Good Coffee App'), findsAtLeastNWidgets(1));
      expect(find.text('Get Your First Coffee'), findsOneWidget);
    });

    testWidgets('shows error state with error message', (tester) async {
      const errorMessage = 'Test error message';
      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadFailure(errorMessage),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Oops! Something went wrong'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('shows snackbar when CoffeeLoadFailure is emitted',
        (tester) async {
      const errorMessage = 'Test error';
      when(() => mockCoffeeBloc.state).thenReturn(const CoffeeInitial());
      whenListen(
        mockCoffeeBloc,
        Stream.fromIterable([
          const CoffeeLoadFailure(errorMessage),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsAtLeastNWidgets(1));
    });

    testWidgets('shows snackbar when CoffeeActionError is emitted',
        (tester) async {
      const errorMessage = 'Action error';
      const previousState = CoffeeLoadSuccess(
        currentCoffee: Coffee(
          id: 'test',
          imageUrl: 'https://example.com/test.jpg',
        ),
      );

      when(() => mockCoffeeBloc.state).thenReturn(previousState);
      whenListen(
        mockCoffeeBloc,
        Stream.fromIterable([
          const CoffeeActionError(
            error: errorMessage,
            previousState: previousState,
          ),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('dispatches CoffeeRequested when get coffee button is tapped',
        (tester) async {
      when(() => mockCoffeeBloc.state).thenReturn(const CoffeeInitial());
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Get Your First Coffee'));
      verify(() => mockCoffeeBloc.add(const CoffeeRequested())).called(1);
    });

    testWidgets(
      'dispatches CoffeeRequested when retry button is tapped in error state',
      (tester) async {
      const errorMessage = 'Test error';
      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadFailure(errorMessage),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Try Again'));
      verify(() => mockCoffeeBloc.add(const CoffeeRequested())).called(1);
    });

    testWidgets(
      'dispatches CoffeeRequested when button is tapped in empty success state',
      (tester) async {
      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Get Your First Coffee'));
      verify(() => mockCoffeeBloc.add(const CoffeeRequested())).called(1);
    });

    testWidgets(
      'shows previous state content when CoffeeActionError is emitted',
      (tester) async {
      const testCoffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/coffee.jpg',
      );
      const previousState = CoffeeLoadSuccess(currentCoffee: testCoffee);

      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeActionError(
          error: 'Action error',
          previousState: previousState,
        ),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Should show the coffee image widget from previous state
      expect(find.byType(CoffeeImageWidget<CoffeeModel>), findsOneWidget);
    });

    testWidgets(
      'dispatches CoffeeRequested when refresh is tapped on coffee image',
      (tester) async {
      const testCoffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/coffee.jpg',
      );

      when(() => mockCoffeeBloc.state).thenReturn(
        const CoffeeLoadSuccess(currentCoffee: testCoffee),
      );
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Find and tap the "New Coffee" refresh button
      await tester.tap(find.text('New Coffee'));
      
      // Verify CoffeeRequested event was dispatched
      verify(() => mockCoffeeBloc.add(const CoffeeRequested())).called(1);
    });
  });
}
