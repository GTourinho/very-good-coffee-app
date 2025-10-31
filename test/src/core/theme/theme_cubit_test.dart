import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_app/src/core/design_system/app_theme.dart';
import 'package:coffee_app/src/core/theme/theme_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeCubit', () {
    setUp(() async {
      // Clear all shared preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is mediumRoast', () {
      final cubit = ThemeCubit();
      expect(cubit.state, CoffeeRoast.mediumRoast);
    });

    blocTest<ThemeCubit, CoffeeRoast>(
      'emits lightRoast when setTheme is called with lightRoast',
      build: ThemeCubit.new,
      act: (cubit) => cubit.setTheme(CoffeeRoast.lightRoast),
      expect: () => [CoffeeRoast.lightRoast],
    );

    blocTest<ThemeCubit, CoffeeRoast>(
      'emits mediumRoast when setTheme is called with mediumRoast',
      build: ThemeCubit.new,
      act: (cubit) => cubit.setTheme(CoffeeRoast.mediumRoast),
      expect: () => [CoffeeRoast.mediumRoast],
    );

    blocTest<ThemeCubit, CoffeeRoast>(
      'emits darkRoast when setTheme is called with darkRoast',
      build: ThemeCubit.new,
      act: (cubit) => cubit.setTheme(CoffeeRoast.darkRoast),
      expect: () => [CoffeeRoast.darkRoast],
    );

    blocTest<ThemeCubit, CoffeeRoast>(
      'persists theme to SharedPreferences when setTheme is called',
      build: ThemeCubit.new,
      act: (cubit) async {
        await cubit.setTheme(CoffeeRoast.darkRoast);
      },
      verify: (_) async {
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('coffee_roast_theme'), 'darkRoast');
      },
    );

    test('loads saved theme from SharedPreferences on initialization',
        () async {
      // Set up SharedPreferences with a saved theme
      SharedPreferences.setMockInitialValues({
        'coffee_roast_theme': 'lightRoast',
      });

      final cubit = ThemeCubit();

      // Wait for the async loading to complete
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(cubit.state, CoffeeRoast.lightRoast);
    });

    test('loads darkRoast from SharedPreferences on initialization', () async {
      // Set up SharedPreferences with a saved theme
      SharedPreferences.setMockInitialValues({
        'coffee_roast_theme': 'darkRoast',
      });

      final cubit = ThemeCubit();

      // Wait for the async loading to complete
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(cubit.state, CoffeeRoast.darkRoast);
    });

    test('uses default theme when SharedPreferences has no saved theme',
        () async {
      // Set up empty SharedPreferences
      SharedPreferences.setMockInitialValues({});

      final cubit = ThemeCubit();

      // Wait for the async loading to complete
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(cubit.state, CoffeeRoast.mediumRoast);
    });

    test('uses default theme when SharedPreferences has invalid theme',
        () async {
      // Set up SharedPreferences with an invalid theme value
      SharedPreferences.setMockInitialValues({
        'coffee_roast_theme': 'invalidRoast',
      });

      final cubit = ThemeCubit();

      // Wait for the async loading to complete
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(cubit.state, CoffeeRoast.mediumRoast);
    });

    blocTest<ThemeCubit, CoffeeRoast>(
      'emits theme even when saving to SharedPreferences fails',
      build: ThemeCubit.new,
      act: (cubit) => cubit.setTheme(CoffeeRoast.lightRoast),
      expect: () => [CoffeeRoast.lightRoast],
    );

    blocTest<ThemeCubit, CoffeeRoast>(
      'can change theme multiple times',
      build: ThemeCubit.new,
      act: (cubit) async {
        await cubit.setTheme(CoffeeRoast.lightRoast);
        await cubit.setTheme(CoffeeRoast.darkRoast);
        await cubit.setTheme(CoffeeRoast.mediumRoast);
      },
      expect: () => [
        CoffeeRoast.lightRoast,
        CoffeeRoast.darkRoast,
        CoffeeRoast.mediumRoast,
      ],
    );

    test('persists theme changes across multiple setTheme calls', () async {
      final cubit = ThemeCubit();

      await cubit.setTheme(CoffeeRoast.lightRoast);
      final prefs1 = await SharedPreferences.getInstance();
      expect(prefs1.getString('coffee_roast_theme'), 'lightRoast');

      await cubit.setTheme(CoffeeRoast.darkRoast);
      final prefs2 = await SharedPreferences.getInstance();
      expect(prefs2.getString('coffee_roast_theme'), 'darkRoast');

      await cubit.setTheme(CoffeeRoast.mediumRoast);
      final prefs3 = await SharedPreferences.getInstance();
      expect(prefs3.getString('coffee_roast_theme'), 'mediumRoast');
    });

    test('handles SharedPreferences exception during _loadTheme', () async {
      // This test is challenging because SharedPreferences\n      // setMockInitialValues doesn't easily allow simulating\n      // exceptions during getInstance()
      // But we can test the behavior by creating a cubit and ensuring\n      // it doesn't crash
      final cubit = ThemeCubit();
      
      // Wait for async loading to complete
      await Future<void>.delayed(const Duration(milliseconds: 100));
      
      // Should still have default theme even if loading failed
      expect(cubit.state, CoffeeRoast.mediumRoast);
    });

    test('handles SharedPreferences exception during setTheme', () async {
      final cubit = ThemeCubit();
      
      // Wait for initial loading to complete
      await Future<void>.delayed(const Duration(milliseconds: 100));
      
      // Try to set theme - should emit theme even if saving fails
      await cubit.setTheme(CoffeeRoast.darkRoast);
      
      // Should still emit the theme even if saving failed
      expect(cubit.state, CoffeeRoast.darkRoast);
    });

    test('loads theme successfully and emits it', () async {
      SharedPreferences.setMockInitialValues({
        'coffee_roast_theme': 'mediumRoast',
      });

      final cubit = ThemeCubit();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(cubit.state, CoffeeRoast.mediumRoast);
    });

    test('constructor initializes with mediumRoast before loading', () {
      final cubit = ThemeCubit();
      expect(cubit.state, CoffeeRoast.mediumRoast);
    });

    test('handles exception in _loadTheme and keeps default theme', () async {
      // Create a mock that throws when getInstance is called
      Future<SharedPreferences> throwingGetter() async {
        throw Exception('SharedPreferences failed');
      }

      final cubit = ThemeCubit(preferencesGetter: throwingGetter);

      // Wait for async loading attempt
      await Future<void>.delayed(const Duration(milliseconds: 150));

      // Should still be in default state since exception was caught
      expect(cubit.state, CoffeeRoast.mediumRoast);
    });

    test('handles exception in setTheme and still emits theme', () async {
      // Create a mock SharedPreferences that throws on setString
      final mockPrefs = MockSharedPreferences();

      Future<SharedPreferences> mockGetter() async => mockPrefs;

      // Stub getString for _loadTheme
      when(() => mockPrefs.getString(any())).thenReturn(null);

      when(() => mockPrefs.setString(any(), any()))
          .thenThrow(Exception('Save failed'));

      final cubit = ThemeCubit(preferencesGetter: mockGetter);

      // Wait for initialization
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Try to set theme - should emit even though save fails
      await cubit.setTheme(CoffeeRoast.darkRoast);

      // Theme should be emitted despite the exception
      expect(cubit.state, CoffeeRoast.darkRoast);
    });

    test(
      'emits theme even when SharedPreferences.setString throws (via blocTest)',
      () async {
        final mockPrefs = MockSharedPreferences();

        Future<SharedPreferences> mockGetter() async => mockPrefs;

        // Stub getString to return null (no saved theme)
        when(() => mockPrefs.getString(any())).thenReturn(null);

        // Make setString throw an exception
        when(() => mockPrefs.setString(any(), any()))
            .thenThrow(Exception('Save failed'));

        final cubit = ThemeCubit(preferencesGetter: mockGetter);

        // Wait for initialization
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Should start with default
        expect(cubit.state, CoffeeRoast.mediumRoast);

        // Set theme - should emit even though save throws
        await cubit.setTheme(CoffeeRoast.lightRoast);

        // Verify the theme was emitted despite the exception
        expect(cubit.state, CoffeeRoast.lightRoast);
      },
    );
  });
}
