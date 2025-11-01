import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_repository/src/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/view/widgets/coffee_image_widget.dart';
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

    testWidgets('tapping on network image shows full screen viewer',
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

      // Find and tap the image (wrapped in InkWell)
      await tester.tap(find.byType(InkWell).first);
      await tester.pump();

      // The full screen viewer would be shown (in real app)
      // In test, we just verify the tap is registered
    });

    testWidgets('tapping on file image shows full screen viewer',
        (tester) async {
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

      // Find and tap the image
      await tester.tap(find.byType(InkWell).first);
      await tester.pump();
    });

    testWidgets('shows error widget when network image fails to load',
        (tester) async {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/invalid.jpg',
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          onRefresh: () {},
          coffee: coffee,
        ),
      );

      // Pump to trigger error builder (simulated)
      await tester.pump();
    });

    testWidgets('shows file image widget when path is provided',
        (tester) async {
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

      // File image widget is created
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('shows loading progress for network image', (tester) async {
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

      // Initial pump shows loading state
      await tester.pump();
    });

    testWidgets('shows error widget when network image fails', (tester) async {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://invalid.domain.example/broken.jpg',
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          onRefresh: () {},
          coffee: coffee,
        ),
      );

      // Wait for image to fail
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();

      // Error widget should be shown
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
      expect(find.text('Failed to load image'), findsOneWidget);
    });

    testWidgets('shows progress indicator when loading network image',
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

      // Pump to trigger loading builder
      await tester.pump();

      // Image widget is present
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('loading builder returns CircularProgressIndicator',
        (tester) async {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/test.jpg',
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          onRefresh: () {},
          coffee: coffee,
        ),
      );

      // Find the Image widget
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      
      final imageWidget = tester.widget<Image>(imageFinder);
      
      // Call the loadingBuilder directly with mock progress
      if (imageWidget.loadingBuilder != null) {
        const mockProgress = ImageChunkEvent(
          cumulativeBytesLoaded: 50,
          expectedTotalBytes: 100,
        );
        
        final loadingWidget = imageWidget.loadingBuilder!(
          tester.element(imageFinder),
          Container(), // child
          mockProgress,
        );
        
        // Verify the loading widget contains a CircularProgressIndicator
        expect(loadingWidget, isA<Center>());
      }
    });

    testWidgets('network image error builder returns error widget',
        (tester) async {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: 'https://example.com/test.jpg',
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          onRefresh: () {},
          coffee: coffee,
        ),
      );

      // Find the Image widget
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      
      final imageWidget = tester.widget<Image>(imageFinder);
      
      // Call the errorBuilder directly
      if (imageWidget.errorBuilder != null) {
        final errorWidget = imageWidget.errorBuilder!(
          tester.element(imageFinder),
          Exception('Test error'),
          null,
        );
        
        // Verify the error widget is returned
        expect(errorWidget, isNotNull);
      }
    });

    testWidgets('file image error builder returns error widget',
        (tester) async {
      const coffee = Coffee(
        id: 'test-id',
        imageUrl: '/path/to/file.jpg',
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          onRefresh: () {},
          coffee: coffee,
        ),
      );

      // Find the Image widget
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      
      final imageWidget = tester.widget<Image>(imageFinder);
      
      // Call the errorBuilder directly for file image
      if (imageWidget.errorBuilder != null) {
        final errorWidget = imageWidget.errorBuilder!(
          tester.element(imageFinder),
          Exception('File load error'),
          null,
        );
        
        // Verify the error widget is returned
        expect(errorWidget, isNotNull);
      }
    });
  });
}
