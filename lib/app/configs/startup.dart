import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:semesta/app/routes/router.dart';
import 'package:semesta/app/functions/theme_manager.dart';
import 'package:toastification/toastification.dart';

class Startup extends StatelessWidget {
  const Startup({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Android
        statusBarBrightness: Brightness.light, // iOS
      ),
    );
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Semesta App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: context.watch<ThemeManager>().themeMode,
        routerConfig: AppRouter().router,
      ),
    );
  }
}
