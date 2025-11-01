import 'dart:convert';

import 'package:coffee_repository/src/data/models/coffee_model.dart';
import 'package:http/http.dart' as http;

/// Remote data source implementation for coffee.
class CoffeeRemoteDataSourceImpl {
  /// Creates a remote data source.
  const CoffeeRemoteDataSourceImpl({required this.client});

  /// HTTP client instance.
  final http.Client client;

  /// Fetches a random coffee.
  Future<CoffeeModel> call() async {
    final response = await client.get(
      Uri.parse('https://coffee.alexflipnote.dev/random.json'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Oops! Could not fetch a coffee image. '
        'Please check your internet connection.',
      );
    }

    try {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return CoffeeModel.fromApiResponse(jsonResponse);
    } on Exception {
      throw Exception(
        'Oops! Something went wrong while loading your coffee. '
        'Please try again.',
      );
    }
  }
}
