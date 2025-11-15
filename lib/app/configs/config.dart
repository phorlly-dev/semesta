import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:semesta/app/configs/app_start.dart';
import 'package:semesta/app/utils/logger.dart';
import 'package:semesta/app/configs/handle_error.dart';
import 'package:semesta/app/utils/share_storage.dart';
import 'package:semesta/core/controllers/auth_controller.dart';
import 'package:semesta/core/controllers/user_controller.dart';
import 'package:semesta/core/services/firebase_service.dart';

class AppConfigure {
  AppConfigure._();

  static void init() {
    BindingBase.debugZoneErrorsAreFatal = true;

    HandleError(
      callback: () async {
        // Must be FIRST inside the zone:
        WidgetsFlutterBinding.ensureInitialized();

        //Service
        await FirebaseService().init();

        //The error handler early
        onError();

        // Register GetX controllers, etc.
        Get.put(AuthController(), permanent: true);
        Get.put(UserController(), permanent: true);

        //ScreenUtil
        await ScreenUtil.ensureScreenSize();

        await ShareStorage.init();

        //Run app
        runApp(const AppStart());
      },
      onError: (error, stack) async {
        await FirebaseCrashlytics.instance.recordError(
          error,
          stack,
          printDetails: true,
        );
      },
    );
  }

  static void onError() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      HandleLogger.err('Caught by FlutterError', error: details.exception);
      HandleLogger.track('Info Logged', stack: details.stack);
    };
  }
}
