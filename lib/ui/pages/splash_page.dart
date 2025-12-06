import 'package:flutter/material.dart';
import 'package:semesta/app/routes/router.dart';
import 'package:semesta/ui/components/global/_layout_page.dart';
import 'package:semesta/ui/widgets/loading.dart';

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
    // await analytics.logAppOpen();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage(content: Loading(title: 'Semesta'));
  }
}
