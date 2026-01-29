import 'package:semesta/public/utils/type_def.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareStorage {
  static SharedPreferences? _instance;

  static Wait<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs => _instance!;

  Wait<void> setStorage(String key, String value) async {
    await prefs.setString(key, value);
  }

  String? getStorage(String key) => prefs.getString(key);
}
