import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppColors {
  AppColors._();

  static const white = Color(0xFFFAFAFA);
  static const black = Color(0xFF131313);

  static const red = Color(0xFFCA0825);
  static const lightRed = Color(0xFFF44336);

  static const blueGrey = Color(0xFF607D8B);

  static const green = Color(0xFF21C13B);
  static const darkGreen = Color(0xFF4CAF50);

  static const yellow = Color(0xFFE7E20E);

  static const blue = Color(0xFF4373D9);
  static const darkBlue = Color(0xFF133E99);

  static const deepOrange = Color(0xFFFF5722);

  static const grey = Color(0xFF9E9E9E);
  static const darkGrey = Color(0xFF424242);

  // ➕ Added for standings clarity
  static const purple = Color(0xFF7E57C2); // 3rd place highlight
  static const lightGrey = Color(0xFFE0E0E0); // mid-table background

  static const greyColor = Color(0xFFC9CCD3);
  static const darkGreyColor = Color.fromARGB(255, 159, 159, 159);
  static const whiteColor = Color(0xFFFFFFFD);
  static const realWhiteColor = Color(0xFFFFFFFF);
  static const darkWhiteColor = Color(0xFFF7F8FA);
  static const blackColor = Color(0xFF121213);
  static const blueColor = Color(0xFF378BF7);
  static const lightBlueColor = Color(0xFF0064E0);
  static const darkBlueColor = Color(0xFF0E62C6);
  static const loginScreenColor = Color(0xFF171E2E);

  static const messengerBlue = Color(0xFF0584FE);
  static const messengerGrey = Color(0xFFF3F3F3);
  static const messengerDarkGrey = Color(0xFFA5ABB3);

  static const blueGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[darkBlue, blue],
  );

  static const redGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[lightRed, red],
  );
}
