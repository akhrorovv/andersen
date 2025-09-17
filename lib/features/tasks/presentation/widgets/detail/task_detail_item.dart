import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/initial.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskDetailItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final String? value;
  final Color? color;
  final bool? isMatter;
  final bool? hasDivider;
  final String? initialName;

  const TaskDetailItem({
    super.key,
    required this.title,
    required this.iconPath,
    required this.value,
    this.color,
    this.isMatter = false,
    this.hasDivider = true,
    this.initialName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.w,
      children: [
        CircleAvatar(
          radius: 16.r,
          backgroundColor: (value == null || value == '-')
              ? AppColors.colorPrimaryBg
              : AppColors.primary,
          child: (initialName == null)
              ? SvgPicture.asset(
                  iconPath,
                  width: 16.w,
                  height: 16.w,
                  colorFilter: (value == null || value == '-')
                      ? ColorFilter.mode(AppColors.colorText, BlendMode.srcIn)
                      : ColorFilter.mode(
                          AppColors.colorTextWhite,
                          BlendMode.srcIn,
                        ),
                )
              : Text(
                  getInitials(initialName),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorTextWhite,
                    height: 1,
                    letterSpacing: 0,
                  ),
                ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.h,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  letterSpacing: 0,
                ),
              ),
              Text(
                value ?? "-",
                style: TextStyle(
                  color: valueColor(value, isMatter!, color),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  letterSpacing: 0,
                ),
              ),
              if (hasDivider!) BasicDivider(marginBottom: 0, marginTop: 8),
            ],
          ),
        ),
      ],
    );
  }
}

Color valueColor(String? value, bool isMatter, Color? color) {
  if (color != null) {
    return color;
  }
  if (value == null || value == '-' || value.isEmpty) {
    return AppColors.colorBgMask;
  } else if (isMatter) {
    return AppColors.primary;
  }
  return AppColors.colorText;
}
