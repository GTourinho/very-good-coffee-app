// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Muy Buena App de Café';

  @override
  String get favorites => 'Favoritos';

  @override
  String get home => 'Inicio';

  @override
  String get favoriteCoffees => 'Cafés Favoritos';

  @override
  String get getYourFirstCoffee => 'Obtén tu Primer Café';

  @override
  String get newCoffee => 'Nuevo Café';

  @override
  String get tryAgain => 'Intentar de Nuevo';

  @override
  String get noFavoriteCoffees => 'No hay cafés favoritos aún';

  @override
  String get noFavoriteCoffeesDescription =>
      'Toca el ícono del corazón en cualquier café para agregarlo a favoritos';

  @override
  String get oopsSomethingWentWrong => '¡Ups! Algo salió mal';

  @override
  String get couldNotLoadCoffees =>
      'No se pudieron cargar tus cafés favoritos. Por favor intenta de nuevo.';

  @override
  String get couldNotLoadCoffee =>
      'No se pudo cargar el café. Por favor intenta de nuevo.';

  @override
  String get couldNotUpdateFavorites =>
      '¡Ups! No se pudieron actualizar tus favoritos. Por favor intenta de nuevo';

  @override
  String coffee(String id) {
    return 'Café #$id';
  }

  @override
  String get zoomHint => 'Pellizca para hacer zoom';

  @override
  String get loading => 'Cargando...';

  @override
  String get failedToLoadImage => 'Error al cargar la imagen';
}
