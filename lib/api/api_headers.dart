/// Common API headers
class ApiHeaders {
  /// Standard JSON headers
  static Map<String, String> get jsonHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Headers with authorization token
  static Map<String, String> authorizedHeaders(String token) => {
        ...jsonHeaders,
        'Authorization': 'Bearer $token',
      };

  /// Multipart form data headers
  static Map<String, String> get multipartHeaders => {
        'Content-Type': 'multipart/form-data',
      };
}
