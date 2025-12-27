/// Common HTTP status codes
class ApiStatusCodes {
  // Success codes
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;

  // Client error codes
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int notAcceptable = 406;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;

  // Server error codes
  static const int serverError = 500;
  static const int notImplemented = 501;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;

  /// Check if status code is successful (2xx)
  static bool isSuccess(int code) => code >= 200 && code < 300;

  /// Check if status code is client error (4xx)
  static bool isClientError(int code) => code >= 400 && code < 500;

  /// Check if status code is server error (5xx)
  static bool isServerError(int code) => code >= 500 && code < 600;
}
