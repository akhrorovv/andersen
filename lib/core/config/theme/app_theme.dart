import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.colorPrimaryText,
      titleTextStyle: GoogleFonts.montserrat(
        color: AppColors.colorTextWhite,
        height: 1.2,
        letterSpacing: 0,
      ),
    ),

    brightness: Brightness.light,
    textTheme: GoogleFonts.montserratTextTheme(),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withValues(alpha: 0.3),
      selectionHandleColor: AppColors.primary,
    ),
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
      primaryColor: AppColors.primary,
    ),
  );

  static final darkTheme = ThemeData();
}
