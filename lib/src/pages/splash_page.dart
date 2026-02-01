import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semesta/public/bindings/post_bindings.dart';
import 'package:semesta/public/extensions/extension.dart';
import 'package:semesta/public/utils/params.dart';
import 'package:semesta/routes/router.dart';
import 'package:semesta/src/components/layout/_page.dart';
import 'package:semesta/src/widgets/main/custom_image.dart';
import 'package:semesta/src/widgets/sub/direction_y.dart';
import 'package:semesta/src/widgets/sub/animated_loader.dart';

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
    PostBindings().dependencies();
    await Future.delayed(Duration(seconds: 2));
    AppRouter.appReady.value = true;
    // await analytics.logAppOpen();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      content: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 600),
        child: DirectionY(
          spacing: 16,
          alignment: Alignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImage(
              MediaSource.asset('logo.png'.asImage(true)),
              height: 120.h,
            ),
            Text(
              'Semesta'.toUpperCase(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const AnimatedLoader(cupertino: true),
          ],
        ),
      ),
    );
  }
}
