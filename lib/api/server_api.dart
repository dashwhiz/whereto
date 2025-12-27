import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_headers.dart';
import 'api_status_codes.dart';
import '../utils/operation_scope.dart';
import '../services/logging_service.dart';

/// Central API client for all server communications
/// Connectivity is checked automatically in scope() wrapper
class ServerAPI {
  ServerAPI({this.baseUrl = 'https://api.example.com'});

  final String baseUrl;

  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    final uri = _buildUri(endpoint, queryParams);
    log.apiRequest('GET', uri.toString());
    final response = await http.get(
      uri,
      headers: headers ?? ApiHeaders.jsonHeaders,
    );
    return _handleResponse(response, uri.toString());
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final uri = _buildUri(endpoint);
    log.apiRequest('POST', uri.toString(), body: body);
    final response = await http.post(
      uri,
      headers: headers ?? ApiHeaders.jsonHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response, uri.toString());
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final uri = _buildUri(endpoint);
    log.apiRequest('PUT', uri.toString(), body: body);
    final response = await http.put(
      uri,
      headers: headers ?? ApiHeaders.jsonHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response, uri.toString());
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(endpoint);
    log.apiRequest('DELETE', uri.toString());
    final response = await http.delete(
      uri,
      headers: headers ?? ApiHeaders.jsonHeaders,
    );
    return _handleResponse(response, uri.toString());
  }

  /// Build URI with query parameters
  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$baseUrl$path').replace(queryParameters: queryParams);
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response, String url) {
    if (ApiStatusCodes.isSuccess(response.statusCode)) {
      log.apiResponse(url, response.statusCode);
      if (response.body.isEmpty) {
        return {};
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body;
    } else {
      // Extract error message from response if available
      String? errorMessage;
      try {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage =
            errorBody['message'] as String? ?? errorBody['error'] as String?;
      } catch (_) {
        errorMessage = response.body;
      }

      log.apiResponse(url, response.statusCode, body: errorMessage);

      throw ErrorListenerException(
        response.statusCode,
        errorMessage,
        response.headers,
      );
    }
  }

  // Example API endpoints - customize for your project

  /// Example: Login endpoint
  Future<Map<String, dynamic>> login(String email, String password) {
    return post('/auth/login', body: {'email': email, 'password': password});
  }

  /// Example: Get user profile
  Future<Map<String, dynamic>> getUserProfile(String token) {
    return get('/user/profile', headers: ApiHeaders.authorizedHeaders(token));
  }
}
