import 'user_model.dart';

class AuthRepository {
  Future<bool> registerUser(UserProfile user) async {
    // Simulate network delay / API call
    await Future.delayed(const Duration(seconds: 1));
    return true; // Return success
  }
}
