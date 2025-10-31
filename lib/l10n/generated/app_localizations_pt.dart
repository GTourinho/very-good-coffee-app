// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Aplicativo de Café Muito Bom';

  @override
  String get favorites => 'Favoritos';

  @override
  String get home => 'Início';

  @override
  String get favoriteCoffees => 'Cafés Favoritos';

  @override
  String get getYourFirstCoffee => 'Pegue Seu Primeiro Café';

  @override
  String get newCoffee => 'Novo Café';

  @override
  String get tryAgain => 'Tentar Novamente';

  @override
  String get noFavoriteCoffees => 'Ainda não há cafés favoritos';

  @override
  String get noFavoriteCoffeesDescription =>
      'Toque no ícone de coração em qualquer café para adicioná-lo aos favoritos';

  @override
  String get oopsSomethingWentWrong => 'Ops! Algo deu errado';

  @override
  String get couldNotLoadCoffees =>
      'Não foi possível carregar seus cafés favoritos. Por favor, tente novamente.';

  @override
  String get couldNotLoadCoffee =>
      'Não foi possível carregar o café. Por favor, tente novamente.';

  @override
  String get couldNotUpdateFavorites =>
      'Ops! Não foi possível atualizar seus favoritos. Por favor, tente novamente';

  @override
  String coffee(String id) {
    return 'Café #$id';
  }

  @override
  String get zoomHint => 'Belisque para ampliar';

  @override
  String get loading => 'Carregando...';

  @override
  String get failedToLoadImage => 'Falha ao carregar imagem';

  @override
  String get settings => 'Configurações';

  @override
  String get themeSettings => 'Configurações de Tema';

  @override
  String get chooseYourRoast => 'Escolha seu tostado de café favorito';

  @override
  String get lightRoast => 'Tostado Claro';

  @override
  String get lightRoastDescription => 'Brilhante, fresco e cremoso';

  @override
  String get mediumRoast => 'Tostado Médio';

  @override
  String get mediumRoastDescription => 'Equilibrado, quente e convidativo';

  @override
  String get darkRoast => 'Tostado Escuro';

  @override
  String get darkRoastDescription => 'Forte, rico e aconchegante';
}
