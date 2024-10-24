import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _tokenKey = 'token';
  static const _profileIdKey = 'profileId';
  static const _usernameKey = 'username';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveProfileId(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileIdKey, profileId);
  }

  static Future<String?> getProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileIdKey);
  }

  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }
}
