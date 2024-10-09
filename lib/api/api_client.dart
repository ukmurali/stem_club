import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:developer' as developer;

class ApiClient {
  final http.Client _client = http.Client();
  final Duration _timeoutDuration = const Duration(seconds: 30);

  Future<http.Response> get(String url, {Map<String, String>? headers, Map<String, String>? queryParameters}) async {
    try {
      final response = await _client
          .get(
            Uri.parse(url).replace(queryParameters: queryParameters),
            headers: headers,
          )
          .timeout(_timeoutDuration);

      return response;
    } catch (e) {
      // Handle timeout or network errors
      developer.log('GET request error: $e');
      throw Exception('Network request failed');
    }
  }

  Future<http.Response> post(String url,
      {Map<String, String>? headers, dynamic body}) async {
    try {
      final apiUrl = Uri.parse(url);
      final response = await http
          .post(
            apiUrl,
            headers: headers,
            body: body,
          );
      return response;
    } catch (e) {
      // Handle timeout or network errors
      developer.log('POST request error: $e');
      throw Exception('Network request failed: $e');
    }
  }

  // Add other methods like PUT, DELETE if needed
}