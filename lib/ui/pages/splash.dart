import 'package:flutter/material.dart';
import 'package:semesta/app/routes/router.dart';
import 'package:semesta/ui/partials/_layout.dart';
import 'package:semesta/ui/widgets/loading.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(Duration(seconds: 2));
    AppRouter.appReady.value = true;
    // await analytics.logAppOpen();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(content: Loading(title: 'Semesta'));
  }
}
