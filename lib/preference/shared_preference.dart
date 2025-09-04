import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String loginKey = "login";
  static const String tokenKey = "token";
  static const String userIdKey = 'user_id';
  static const String userNameKey = "user_name";
  static const String userEmailKey = "user_email";

  static Future<void> saveLogin(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginKey, isLoggedIn);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    print('Token saved: ${token.substring(0, 20)}...'); // Debug
  }

  static Future<void> saveUserData(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, name);
    await prefs.setString(userEmailKey, email);
  }

  static Future<bool?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey);
  }

  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userIdKey, userId);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);
    print(
      'Retrieved token: ${token != null ? "${token.substring(0, min(20, token.length))}..." : "null"}',
    ); // Debug
    return token;
  }

  static Future<void> removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(loginKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    print('Token cleared');
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('All preferences cleared');
  }

  // Helper function
  static int min(int a, int b) => a < b ? a : b;
}
