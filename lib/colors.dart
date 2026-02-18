import 'package:flutter/material.dart';

class AppColors {
  static const int primaryColorValue = 0xff0060EB;
  static const int secondaryColorValue = 0xffE3FB20;

  static const Color primary = Color(primaryColorValue);

  static const Color error = Color(0xFFE52836);
  static const Color warning = Color(0xFFF6A609);
  static const Color success = Color(0xFF2AC769);

  static const MaterialColor primarySwatch =
      MaterialColor(primaryColorValue, <int, Color>{
        50: Color(0xffe6effd),
        100: Color(0xffd9e7fc),
        200: Color(0xffb0cef9),
        300: Color(primaryColorValue),
        400: Color(0xff0056d4),
        500: Color(0xff004dbc),
        600: Color(0xff0048b0),
        700: Color(0xff003a8d),
        800: Color(0xff002b6a),
        900: Color(0xff002252),
      });

  static const MaterialColor secondarySwatch =
      MaterialColor(secondaryColorValue, <int, Color>{
        50: Color(0xfffcffe9),
        100: Color(0xfffbfede),
        200: Color(0xfff6feba),
        300: Color(secondaryColorValue),
        400: Color(0xffcce21d),
        500: Color(0xffb6c91a),
        600: Color(0xffaabc18),
        700: Color(0xff889713),
        800: Color(0xff66710e),
        900: Color(0xff4f580b),
      });

  static const Color neutral50 = Color(0xffF9F9F9);
  static const Color neutral100 = Color(0xffE7E8E9);
  static const Color neutral200 = Color(0xffE4E7EC);

  static const Color white = Color(0xffFFFFFF);
  static const Color bgColor = Color(0xffFFFFFF);
  static const Color secondaryBgColor = Color(primaryColorValue);
  static const Color borderColor = Color(0xffE4E7EC);

  static const background = Color(0xFF000000);
  static const card = Color(0xFFF7F7F7);
  static const textPrimary = Color(0xff676767);
  static const textSecondary = Color(0xFF8E8E93);
  static const destructive = Color(0xffB11010);
}
