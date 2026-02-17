import 'package:semesta/public/utils/type_def.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareStorage {
  static SharedPreferences? _instance;

  static AsWait init() async {
    _instance = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs => _instance!;

  AsWait set(String key, String value) async {
    await prefs.setString(key, value);
  }

  String? get(String key) => prefs.getString(key);
}
