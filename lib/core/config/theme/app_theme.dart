import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: AppColors.colorPrimaryText,
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
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
    snackBarTheme: SnackBarThemeData(contentTextStyle: GoogleFonts.montserrat()),
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
      primaryColor: AppColors.primary,
      textTheme: CupertinoTextThemeData(
        dateTimePickerTextStyle: GoogleFonts.montserrat(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.colorText,
        ),
      ),
    ),
  );

  static final darkTheme = ThemeData();
}
