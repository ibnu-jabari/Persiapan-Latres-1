import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan informasi login di SharedPreferences.
class SessionService {
  static const String _keyEmail = 'email';
  static const String _keyLoggedIn = 'is_logged_in';
  static late SharedPreferences _prefs;

  /// Dipanggil sekali di main() sebelum runApp().
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isLoggedIn => _prefs.getBool(_keyLoggedIn) ?? false;

  static String get email => _prefs.getString(_keyEmail) ?? '';

  static Future<void> login(String email) async {
    await _prefs.setString(_keyEmail, email);
    await _prefs.setBool(_keyLoggedIn, true);
  }

  static Future<void> logout() async {
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyLoggedIn);
  }
}
