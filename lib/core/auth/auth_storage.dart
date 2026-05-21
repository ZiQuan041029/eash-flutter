import 'package:shared_preferences/shared_preferences.dart';

/// Persists the Sanctum token so authenticated API routes work after login/register.
abstract final class AuthStorage {
  static const String _keyToken = 'auth_token';

  static Future<void> saveToken(String token) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setString(_keyToken, token);
  }

  static Future<String?> getToken() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final String? t = p.getString(_keyToken);
    if (t == null || t.isEmpty) {
      return null;
    }
    return t;
  }

  static Future<void> clearToken() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.remove(_keyToken);
  }
}
