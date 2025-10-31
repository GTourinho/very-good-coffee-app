// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Very Good Coffee App';

  @override
  String get favorites => 'Favorites';

  @override
  String get home => 'Home';

  @override
  String get favoriteCoffees => 'Favorite Coffees';

  @override
  String get getYourFirstCoffee => 'Get Your First Coffee';

  @override
  String get newCoffee => 'New Coffee';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noFavoriteCoffees => 'No favorite coffees yet';

  @override
  String get noFavoriteCoffeesDescription =>
      'Tap the heart icon on any coffee to add it to favorites';

  @override
  String get oopsSomethingWentWrong => 'Oops! Something went wrong';

  @override
  String get couldNotLoadCoffees =>
      'Could not load your favorite coffees. Please try again.';

  @override
  String get couldNotLoadCoffee => 'Could not load coffee. Please try again.';

  @override
  String get couldNotUpdateFavorites =>
      'Oops! Could not update your favorites. Please try again';

  @override
  String coffee(String id) {
    return 'Coffee #$id';
  }

  @override
  String get zoomHint => 'Pinch to zoom';

  @override
  String get loading => 'Loading...';

  @override
  String get failedToLoadImage => 'Failed to load image';
}
