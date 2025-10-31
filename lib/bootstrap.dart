import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:coffee_app/src/coffee/coffee_injection.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

/// Observer for bloc events.
class AppBlocObserver extends BlocObserver {
  /// Creates an app bloc observer.
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// Bootstraps the app with initialization.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Initialize dependency injection
  final getIt = GetIt.instance;
  await CoffeeInjection.init(getIt);

  // Add cross-flavor configuration here

  runApp(await builder());
}
