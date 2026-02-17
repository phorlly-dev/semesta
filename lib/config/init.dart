import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semesta/public/bindings/global_bindings.dart';
import 'package:semesta/config/app_start.dart';
import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/utils/share_storage.dart';
import 'package:semesta/app/services/firebase_service.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AppInitialize {
  const AppInitialize._();

  static void load() {
    BindingBase.debugZoneErrorsAreFatal = true;

    runZonedGuarded(
      () async {
        // Must be FIRST inside the zone:
        WidgetsFlutterBinding.ensureInitialized();

        AssetPicker.registerObserve();
        // Enables logging with the photo_manager.
        PhotoManager.setLog(true);

        //Service
        await FirebaseService().init();

        // Register GetX controllers, etc.
        GlobalBindings().dependencies();

        //ScreenUtil
        await ScreenUtil.ensureScreenSize();

        await ShareStorage.init();

        //The error handler early
        _onError();

        //Run app
        runApp(const AppStart());
      },
      (error, stack) async {
        await FirebaseCrashlytics.instance.recordError(
          error,
          stack,
          printDetails: true,
        );
      },
    );
  }

  static void _onError() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      HandleLogger.error('Something went wrong.!', error: details.exception);
      HandleLogger.track('Info logged', stack: details.stack);
    };
  }
}
