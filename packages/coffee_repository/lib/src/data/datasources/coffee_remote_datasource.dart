import 'package:coffee_repository/src/data/models/coffee_model.dart';

/// {@template coffee_remote_datasource}
/// Interface for remote coffee data operations.
/// {@endtemplate}
typedef CoffeeRemoteDataSource = Future<CoffeeModel> Function();
