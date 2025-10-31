import 'package:bloc/bloc.dart';
import 'package:coffee_app/src/coffee/domain/usecases/get_favorite_coffees.dart';
import 'package:coffee_app/src/coffee/domain/usecases/get_random_coffee.dart';
import 'package:coffee_app/src/coffee/domain/usecases/toggle_favorite_coffee.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_event.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_state.dart';

/// {@template coffee_bloc}
/// BLoC responsible for managing coffee state.
/// {@endtemplate}
class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  /// {@macro coffee_bloc}
  CoffeeBloc({
    required GetRandomCoffee getRandomCoffee,
    required GetFavoriteCoffees getFavoriteCoffees,
    required ToggleFavoriteCoffee toggleFavoriteCoffee,
  })  : _getRandomCoffee = getRandomCoffee,
        _getFavoriteCoffees = getFavoriteCoffees,
        _toggleFavoriteCoffee = toggleFavoriteCoffee,
        super(const CoffeeInitial()) {
    on<CoffeeRequested>(_onCoffeeRequested);
    on<CoffeeFavoritesRequested>(_onCoffeeFavoritesRequested);
    on<CoffeeFavoriteToggled>(_onCoffeeFavoriteToggled);
  }

  final GetRandomCoffee _getRandomCoffee;
  final GetFavoriteCoffees _getFavoriteCoffees;
  final ToggleFavoriteCoffee _toggleFavoriteCoffee;

  Future<void> _onCoffeeRequested(
    CoffeeRequested event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(const CoffeeLoadInProgress());

    try {
      final coffee = await _getRandomCoffee();
      final favorites = await _getFavoriteCoffees();

      emit(
        CoffeeLoadSuccess(
          currentCoffee: coffee,
          favoriteCoffees: favorites,
        ),
      );
    } on Exception {
      emit(
        const CoffeeLoadFailure(
          'Oops! Could not load a coffee image. Please try again.',
        ),
      );
    }
  }

  Future<void> _onCoffeeFavoritesRequested(
    CoffeeFavoritesRequested event,
    Emitter<CoffeeState> emit,
  ) async {
    try {
      final favorites = await _getFavoriteCoffees();

      if (state is CoffeeLoadSuccess) {
        emit(
          (state as CoffeeLoadSuccess).copyWith(
            favoriteCoffees: favorites,
          ),
        );
      } else {
        emit(
          CoffeeLoadSuccess(
            favoriteCoffees: favorites,
          ),
        );
      }
    } on Exception {
      emit(
        const CoffeeLoadFailure(
          'Oops! Could not load your favorite coffees. Please try again.',
        ),
      );
    }
  }

  Future<void> _onCoffeeFavoriteToggled(
    CoffeeFavoriteToggled event,
    Emitter<CoffeeState> emit,
  ) async {
    if (state is CoffeeLoadSuccess) {
      final currentState = state as CoffeeLoadSuccess;
      try {
        final updatedCoffee = await _toggleFavoriteCoffee(event.coffee);
        final favorites = await _getFavoriteCoffees();

        emit(
          currentState.copyWith(
            currentCoffee: updatedCoffee,
            favoriteCoffees: favorites,
          ),
        );
      } on Exception {
        // Emit error state with previous state to show snackbar but keep UI
        emit(
          CoffeeActionError(
            error: 'Oops! Could not update your favorites. Please try again.',
            previousState: currentState,
          ),
        );
        // Immediately restore previous state so UI doesn't change
        emit(currentState);
      }
    }
  }
}
