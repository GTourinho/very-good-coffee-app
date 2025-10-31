import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:equatable/equatable.dart';

/// {@template coffee_event}
/// Abstract class for all coffee events.
/// {@endtemplate}
abstract class CoffeeEvent extends Equatable {
  /// {@macro coffee_event}
  const CoffeeEvent();

  @override
  List<Object?> get props => [];
}

/// {@template coffee_requested}
/// Event triggered when a new random coffee is requested.
/// {@endtemplate}
class CoffeeRequested extends CoffeeEvent {
  /// {@macro coffee_requested}
  const CoffeeRequested();
}

/// {@template coffee_favorites_requested}
/// Event triggered when favorite coffees are requested.
/// {@endtemplate}
class CoffeeFavoritesRequested extends CoffeeEvent {
  /// {@macro coffee_favorites_requested}
  const CoffeeFavoritesRequested();
}

/// {@template coffee_favorite_toggled}
/// Event triggered when a coffee's favorite status is toggled.
/// {@endtemplate}
class CoffeeFavoriteToggled extends CoffeeEvent {
  /// {@macro coffee_favorite_toggled}
  const CoffeeFavoriteToggled(this.coffee);

  /// The coffee entity to toggle favorite status for.
  final Coffee coffee;

  @override
  List<Object?> get props => [coffee];
}
