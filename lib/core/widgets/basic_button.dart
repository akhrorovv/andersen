import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicButton extends StatelessWidget {
  final String title;
  final double height;
  final double marginLeft;
  final double marginRight;
  final double marginBottom;
  final VoidCallback onTap;

  const BasicButton({
    super.key,
    required this.title,
    this.height = 42,
    this.marginLeft = 16,
    this.marginRight = 16,
    this.marginBottom = 16,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: marginLeft,
          right: marginRight,
          bottom: marginBottom,
        ),
        height: height.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.colorTextWhite,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              height: 1.25,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}
