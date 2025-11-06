import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semesta/app/routes/router.dart';
import 'package:semesta/app/themes/theme_app.dart';
import 'package:semesta/app/utils/theme_manager.dart';

class Startup extends StatelessWidget {
  const Startup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Semesta App',
      debugShowCheckedModeBanner: false,
      theme: getAppTheme,
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ThemeManager>().themeMode,
      routerConfig: AppRouter().router,
    );
  }
}
