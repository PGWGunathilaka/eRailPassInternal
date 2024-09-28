import 'package:shared_preferences/shared_preferences.dart';

class TokenHolder {
  static final TokenHolder _singleton = TokenHolder._internal();

  static const String tokenKey = "TOKEN";

  SharedPreferences? prefs;

  factory TokenHolder() {
    return _singleton;
  }
  TokenHolder._internal();

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  String? getToken() {
    return prefs?.getString(tokenKey);
  }

  Future<void> setToken(String token) async {
    await prefs!.setString(tokenKey, token);
  }

  Future<void> clearToken() async {
    await prefs!.remove(tokenKey);
  }

}
