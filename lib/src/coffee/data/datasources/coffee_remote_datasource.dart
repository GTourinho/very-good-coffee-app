import 'package:coffee_app/src/coffee/data/models/coffee_model.dart';

/// {@template coffee_remote_datasource}
/// Interface for remote coffee data operations.
/// {@endtemplate}
typedef CoffeeRemoteDataSource = Future<CoffeeModel> Function();
