import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semesta/app/bindings/post_bindings.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/app/routes/router.dart';
import 'package:semesta/ui/components/layouts/_layout_page.dart';
import 'package:semesta/ui/widgets/custom_image.dart';
import 'package:semesta/ui/widgets/loading_animated.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _initApp();
    super.initState();
  }

  Future<void> _initApp() async {
    await Future.delayed(Duration(seconds: 2));
    AppRouter.appReady.value = true;
    PostBindings().dependencies();
    // await analytics.logAppOpen();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
      content: Center(
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(milliseconds: 600),
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(image: setImage('logo.png', true), height: 120.h),
              Text(
                'Semesta'.toUpperCase(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const LoadingAnimated(cupertino: true),
            ],
          ),
        ),
      ),
    );
  }
}
