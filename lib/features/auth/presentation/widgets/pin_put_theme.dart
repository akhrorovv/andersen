import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

final defaultPinTheme = PinTheme(
  width: 56.w,
  height: 56.w,
  textStyle: TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.r),
    border: Border.all(color: AppColors.grey),
  ),
);

final errorPinTheme = defaultPinTheme.copyWith(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.r),
    border: Border.all(color: AppColors.red),
  ),
);