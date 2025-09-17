import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicDivider extends StatelessWidget {
  final double marginTop;
  final double marginBottom;

  const BasicDivider({super.key, this.marginTop = 12, this.marginBottom = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop.h, bottom: marginBottom.h),
      width: double.infinity,
      height: 1.h,
      decoration: BoxDecoration(
        color: AppColors.dividerColor,
        borderRadius: BorderRadius.circular(5.r),
      ),
    );
  }
}
