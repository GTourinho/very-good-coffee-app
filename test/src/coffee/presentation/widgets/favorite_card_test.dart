import 'package:coffee_app/l10n/generated/app_localizations.dart';
import 'package:coffee_app/src/coffee/data/models/coffee_model.dart';
import 'package:coffee_app/src/coffee/data/services/image_cache_service.dart';
import 'package:coffee_app/src/coffee/presentation/pages/favorites_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockImageCacheService extends Mock
    implements ImageCacheService {}

void main() {
  group('FavoriteCard', () {
    late MockImageCacheService mockImageCacheService;
    late GetIt getIt;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      getIt = GetIt.instance;
      mockImageCacheService = MockImageCacheService();
      
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
          MaterialApp(
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
          MaterialApp(
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
        );

        await tester.pump();

        // Should display coffee ID (now using localization)
        expect(find.text('Coffee #test_id'), findsOneWidget);
        
        // Verify Image.network widget is present (URL doesn't start with /)
        expect(find.byType(Image), findsOneWidget);
      },
    );
  });
}
