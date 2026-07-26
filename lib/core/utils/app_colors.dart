import 'package:flutter/material.dart';

// Central color palette for the entire app
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF008080);
  static const Color primaryLight = Color(0x9900A6A5); // 60%
  static const Color primaryLight50 = Color(0x8000A6A5); // 50%
  static const Color primaryDark = Color(0xFF006A6A);
  static const Color accent = Color(0xFFC09302);

  // Background
  static const Color background = Color(0xFFFDFDFD);
  static const Color backgroundSecondary = Color(0xFFF9F9F9);
  static const Color backgroundLight = Color(0xFFF7FCFF);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF181818);
  static const Color textSecondary = Color(0xFF272727);
  static const Color textHint = Color(0xFF797979);
  static const Color textDisabled = Color(0xFFAAAAAA);
  static const Color black = Color(0xFF000000);

  // Greys
  static const Color grey100 = Color(0xFFF7F7F7);
  static const Color grey200 = Color(0xFFEAEAEA);
  static const Color grey300 = Color(0xFFDBDBDB);
  static const Color grey500 = Color(0xFF797979);
  static const Color greyDark = Color(0xFF3C4949);

  // Status
  static const Color error = Color(0xFFE90000);
  static const Color danger = Color(0xFFBF2714);

  // Misc
  static const Color border = grey300;
  static const Color divider = grey200;
  static const Color card = surface;
  static const Color overlay = Color(0x4DBBC9C9); // 30% opacity
}
