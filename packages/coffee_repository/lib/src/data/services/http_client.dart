import 'package:http/http.dart' as http;

/// Implementation using the real http package
class SimpleHttpClient {
  /// Creates an HTTP client implementation
  const SimpleHttpClient(this._client);

  final http.Client _client;

  /// Makes an HTTP GET request to the specified URL
  Future<http.Response> get(Uri url) => _client.get(url);
}
