import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BasicButton extends StatelessWidget {
  final String title;
  final String? icon;
  final double height;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool enabled;

  const BasicButton({
    super.key,
    required this.title,
    this.icon,
    this.height = 42,
    required this.onTap,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = isLoading || !enabled;
    return ElevatedButton(
      onPressed: isDisabled ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
        minimumSize: Size(MediaQuery.of(context).size.width, 48.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
      child: SizedBox(
        height: height.h,
        width: double.infinity,
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorTextWhite),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null)
                      Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: SvgPicture.asset(icon!, width: 20.w),
                      ),
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.colorTextWhite,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
