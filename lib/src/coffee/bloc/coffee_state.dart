import 'package:coffee_repository/src/domain/entities/coffee.dart';
import 'package:equatable/equatable.dart';

/// {@template coffee_state}
/// Abstract class for all coffee states.
/// {@endtemplate}
abstract class CoffeeState extends Equatable {
  /// {@macro coffee_state}
  const CoffeeState();

  @override
  List<Object?> get props => [];
}

/// {@template coffee_initial}
/// Initial state of the coffee bloc.
/// {@endtemplate}
class CoffeeInitial extends CoffeeState {
  /// {@macro coffee_initial}
  const CoffeeInitial();
}

/// {@template coffee_load_in_progress}
/// State indicating coffee data is being loaded.
/// {@endtemplate}
class CoffeeLoadInProgress extends CoffeeState {
  /// {@macro coffee_load_in_progress}
  const CoffeeLoadInProgress();
}

/// {@template coffee_load_success}
/// State indicating coffee data was loaded successfully.
/// {@endtemplate}
class CoffeeLoadSuccess extends CoffeeState {
  /// {@macro coffee_load_success}
  const CoffeeLoadSuccess({
    this.currentCoffee,
    this.favoriteCoffees = const [],
  });

  /// The currently displayed coffee image.
  final Coffee? currentCoffee;

  /// List of favorite coffee images.
  final List<Coffee> favoriteCoffees;

  @override
  List<Object?> get props => [currentCoffee, favoriteCoffees];

  /// Creates a copy of this state with updated values.
  CoffeeLoadSuccess copyWith({
    Coffee? currentCoffee,
    List<Coffee>? favoriteCoffees,
  }) {
    return CoffeeLoadSuccess(
      currentCoffee: currentCoffee ?? this.currentCoffee,
      favoriteCoffees: favoriteCoffees ?? this.favoriteCoffees,
    );
  }
}

/// {@template coffee_load_failure}
/// State indicating coffee data loading failed.
/// {@endtemplate}
class CoffeeLoadFailure extends CoffeeState {
  /// {@macro coffee_load_failure}
  const CoffeeLoadFailure(this.errorKey);

  /// The localization key for the error message.
  final String errorKey;

  @override
  List<Object?> get props => [errorKey];
}

/// {@template coffee_action_error}
/// State indicating a transient action error that should show a snackbar
/// but keep the current UI state intact.
/// {@endtemplate}
class CoffeeActionError extends CoffeeState {
  /// {@macro coffee_action_error}
  const CoffeeActionError({
    required this.errorKey,
    required this.previousState,
  });

  /// The localization key for the error message.
  final String errorKey;
  
  /// The previous success state to restore.
  final CoffeeLoadSuccess previousState;

  @override
  List<Object?> get props => [errorKey, previousState];
}
