import '../api/api_headers.dart';
import '../api/server_api.dart';
import '../models/user.dart';

/// User repository example
/// Handles all user-related data operations
class UserRepository {
  UserRepository(this._serverAPI);

  final ServerAPI _serverAPI;

  /// Fetch user profile
  Future<User> getUserProfile(String token) async {
    final response = await _serverAPI.getUserProfile(token);
    return User.fromJson(response);
  }

  /// Example: Update user profile
  Future<User> updateUserProfile({
    required String token,
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    final response = await _serverAPI.put(
      '/user/$userId',
      headers: ApiHeaders.authorizedHeaders(token),
      body: updates,
    );
    return User.fromJson(response);
  }

  // Add more repository methods as needed
}
