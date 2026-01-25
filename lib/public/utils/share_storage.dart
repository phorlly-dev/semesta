import 'package:shared_preferences/shared_preferences.dart';

class ShareStorage {
  static SharedPreferences? _instance;

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs => _instance!;

  Future<void> setStorage(String key, String value) async {
    await prefs.setString(key, value);
  }

  String? getStorage(String key) => prefs.getString(key);
}
