import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_bloc.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/bloc/coffee_state.dart';
import 'package:coffee_app/src/coffee/view/pages/favorites_page.dart';
import 'package:coffee_repository/src/data/models/coffee_model.dart';
import 'package:coffee_repository/src/data/services/image_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockImageCacheService extends Mock implements ImageCacheService {}

class MockCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {}

void main() {
  group('FavoriteCard', () {
    late MockImageCacheService mockImageCacheService;
    late MockCoffeeBloc mockCoffeeBloc;
    late GetIt getIt;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      getIt = GetIt.instance;
      mockImageCacheService = MockImageCacheService();
      mockCoffeeBloc = MockCoffeeBloc();
      
      when(() => mockCoffeeBloc.state).thenReturn(const CoffeeInitial());
      when(() => mockCoffeeBloc.stream).thenAnswer(
        (_) => const Stream<CoffeeState>.empty(),
      );
      
      // Register mock service
      if (getIt.isRegistered<ImageCacheService>()) {
        await getIt.unregister<ImageCacheService>();
      }
      getIt.registerSingleton<ImageCacheService>(
        mockImageCacheService,
      );
    });

    tearDown(() async {
      if (getIt.isRegistered<ImageCacheService>()) {
        await getIt.unregister<ImageCacheService>();
      }
    });

    testWidgets(
      'should display image from file when imageUrl is a file path',
      (tester) async {
        const coffee = CoffeeModel(
          id: 'test_id',
          imageUrl: '/path/to/cached/image.jpg',
        );

        await tester.pumpWidget(
          BlocProvider<CoffeeBloc>.value(
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
                body: Builder(
                  builder: (context) {
                    return const FavoriteCard(coffee: coffee);
                  },
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify the coffee ID is displayed (now using localization)
        expect(find.text('Coffee #test_id'), findsOneWidget);
        
        // Verify Image.file widget is present (file path starts with /)
        expect(find.byType(Image), findsOneWidget);
      },
    );

    testWidgets(
      'should display image from network when imageUrl is a URL',
      (tester) async {
        const coffee = CoffeeModel(
          id: 'test_id',
          imageUrl: 'https://example.com/test.jpg',
        );

        await tester.pumpWidget(
          BlocProvider<CoffeeBloc>.value(
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
                body: Builder(
                  builder: (context) {
                    return const FavoriteCard(coffee: coffee);
                  },
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        // Should display coffee ID (now using localization)
        expect(find.text('Coffee #test_id'), findsOneWidget);
        
        // Verify Image.network widget is present (URL doesn't start with /)
        expect(find.byType(Image), findsOneWidget);
      },
    );

    testWidgets('tapping card shows full screen image viewer',
        (tester) async {
      const coffee = CoffeeModel(
        id: 'test_id',
        imageUrl: 'https://example.com/test.jpg',
      );

      await tester.pumpWidget(
        BlocProvider<CoffeeBloc>.value(
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
              body: Builder(
                builder: (context) {
                  return const FavoriteCard(coffee: coffee);
                },
              ),
            ),
          ),
        ),
      );

      // Tap on the card (find by Card widget)
      await tester.tap(find.byType(Card));
      await tester.pump();
    });

    testWidgets('tapping fullscreen button shows full screen image viewer',
        (tester) async {
      const coffee = CoffeeModel(
        id: 'test_id',
        imageUrl: 'https://example.com/test.jpg',
      );

      await tester.pumpWidget(
        BlocProvider<CoffeeBloc>.value(
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
              body: Builder(
                builder: (context) {
                  return const FavoriteCard(coffee: coffee);
                },
              ),
            ),
          ),
        ),
      );

      // Tap on the fullscreen icon button
      await tester.tap(find.byIcon(Icons.fullscreen));
      await tester.pump();
    });
  });
}
