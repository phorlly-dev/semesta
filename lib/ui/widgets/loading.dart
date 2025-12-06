import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/ui/widgets/custom_image.dart';
import 'package:semesta/ui/widgets/loader.dart';

class Loading extends StatelessWidget {
  final String title;
  const Loading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 600),
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImage(image: setImage('logo.png', true), height: 120.h),
            Text(
              title.toUpperCase(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Loader(),
          ],
        ),
      ),
    );
  }
}
