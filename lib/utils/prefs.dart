import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const String _isLoggedIn = 'isLoggedIn';

  
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedIn, value);
  }

  /// GET LOGIN STATUS
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedIn) ?? false;
  }

 
}
