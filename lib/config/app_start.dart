import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:semesta/config/startup.dart';
import 'package:semesta/public/functions/theme_manager.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: false,
      create: (ctx) => ThemeManager(),
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        ensureScreenSize: true,
        builder: (context, child) => const Startup(),
      ),
    );
  }
}
