import 'package:bloc/bloc.dart';
import 'package:coffee_app/src/coffee/domain/entities/coffee.dart';
import 'package:coffee_app/src/coffee/domain/usecases/get_favorite_coffees.dart';
import 'package:coffee_app/src/coffee/domain/usecases/get_random_coffee.dart';
import 'package:coffee_app/src/coffee/domain/usecases/toggle_favorite_coffee.dart';
import 'package:coffee_app/src/coffee/presentation/bloc/coffee_error_keys.dart';
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
    on<CoffeeFavoriteSyncRequested>(_onCoffeeFavoriteSyncRequested);
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
        const CoffeeLoadFailure(CoffeeErrorKeys.loadCoffee),
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
        const CoffeeLoadFailure(CoffeeErrorKeys.loadFavorites),
      );
    }
  }

  Future<void> _onCoffeeFavoriteToggled(
    CoffeeFavoriteToggled event,
    Emitter<CoffeeState> emit,
  ) async {
    // Store the current state to restore on error
    final previousState = state;

    try {
      // Immediately emit optimistic state for fast UI feedback
      final currentState = state;
      if (currentState is CoffeeLoadSuccess) {
        // Update the current coffee's favorite status optimistically
        final updatedCoffee = event.coffee.copyWith(
          isFavorite: !event.coffee.isFavorite,
        );

        // Update favorites list optimistically
        final updatedFavorites = List<Coffee>.from(
          currentState.favoriteCoffees,
        );
        if (updatedCoffee.isFavorite) {
          // Add to favorites if not already there
          if (!updatedFavorites.any((c) => c.id == updatedCoffee.id)) {
            updatedFavorites.add(updatedCoffee);
          }
        } else {
          // Remove from favorites
          updatedFavorites.removeWhere((c) => c.id == updatedCoffee.id);
        }

        emit(
          CoffeeLoadSuccess(
            currentCoffee: updatedCoffee,
            favoriteCoffees: updatedFavorites,
          ),
        );
      }

      // Now perform the actual async operation
      final result = await _toggleFavoriteCoffee(event.coffee);
      final (updatedCoffee, cacheResult) = result;

      // Check if caching failed
      if (!cacheResult.success && cacheResult.errorMessage != null) {
        // Revert to previous state and emit action error for snackbar
        if (previousState is CoffeeLoadSuccess) {
          emit(previousState);
          emit(
            CoffeeActionError(
              errorKey: CoffeeErrorKeys.updateFavorites,
              previousState: previousState,
            ),
          );
        }
        return;
      }

      // Refresh favorites to sync with actual state
      final favorites = await _getFavoriteCoffees();

      if (currentState is CoffeeLoadSuccess) {
        // Update current coffee with actual favorite status
        final isFavorited = favorites.any((c) => c.id == event.coffee.id);
        final updatedCurrentCoffee = currentState.currentCoffee?.copyWith(
          isFavorite: isFavorited,
        );

        emit(
          CoffeeLoadSuccess(
            currentCoffee: updatedCurrentCoffee,
            favoriteCoffees: favorites,
          ),
        );
      }
    } on Exception {
      // Revert to previous state and emit action error for snackbar
      if (previousState is CoffeeLoadSuccess) {
        emit(previousState);
        emit(
          CoffeeActionError(
            errorKey: CoffeeErrorKeys.updateFavorites,
            previousState: previousState,
          ),
        );
      }
    }
  }

  Future<void> _onCoffeeFavoriteSyncRequested(
    CoffeeFavoriteSyncRequested event,
    Emitter<CoffeeState> emit,
  ) async {
    try {
      final favorites = await _getFavoriteCoffees();

      final currentState = state;
      if (currentState is CoffeeLoadSuccess &&
          currentState.currentCoffee != null) {
        // Update current coffee with actual favorite status from favorites list
        final isFavorited =
            favorites.any((c) => c.id == currentState.currentCoffee!.id);
        final updatedCurrentCoffee = currentState.currentCoffee!.copyWith(
          isFavorite: isFavorited,
        );

        emit(
          currentState.copyWith(
            currentCoffee: updatedCurrentCoffee,
            favoriteCoffees: favorites,
          ),
        );
      }
    } on Exception {
      // Don't emit error state for sync failures, just log silently
      // This is a background sync operation
    }
  }
}
