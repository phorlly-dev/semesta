import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationPrefs {
  NotificationPrefs._();
  static late SharedPreferences _sp;
  static final _user = OneSignal.User;

  // keys
  static const _kUpdate = 'pref_update';
  static const _kPromo = 'pref_promo';
  static const _kPush = 'pref_push_enabled';

  // defaults on first install
  static const _dPush = true;
  static const _dUpdate = true;
  static const _dPromo = true;

  static Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
  }

  // getters (never null)
  static bool get pushOn => _sp.getBool(_kPush) ?? _dPush;
  static bool get update => _sp.getBool(_kUpdate) ?? _dUpdate;
  static bool get promo => _sp.getBool(_kPromo) ?? _dPromo;

  static Future<void> setPushOn(bool v) async {
    await _sp.setBool(_kPush, v);

    if (v) {
      await OneSignal.Notifications.requestPermission(true);
      await _user.pushSubscription.optIn();
    } else {
      await _user.pushSubscription.optOut();
    }
  }

  static Future<void> setUpdate(bool v) async {
    await _sp.setBool(_kUpdate, v);

    await toggleTag(_kUpdate, v);
  }

  static Future<void> setPromo(bool v) async {
    await _sp.setBool(_kPromo, v);

    await toggleTag(_kPromo, v);
  }

  /// Call this once at startup so the SDK matches stored settings.
  static Future<void> syncToOneSignal() async {
    await setUpdate(update);
    await setPromo(promo);
    await setPushOn(pushOn);
  }

  static Future<void> toggleTag(String key, bool value) async {
    if (value) {
      await _user.addTagWithKey(key, value);
    } else {
      await _user.removeTag(key);
    }
  }
}
