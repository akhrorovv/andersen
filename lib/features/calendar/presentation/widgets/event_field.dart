import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventField extends StatelessWidget {
  final String? title;
  final String? iconPath;
  final Widget child;
  final bool? hasDivider;
  final bool? hasIcon;

  const EventField({
    super.key,
    this.title,
    this.iconPath,
    required this.child,
    this.hasDivider,
    this.hasIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: (hasIcon == true) ? 8.w : 0,
      children: [
        if(hasIcon == true)
        CircleAvatar(
          radius: 16.r,
          backgroundColor: AppColors.primary,
          child: SvgPicture.asset(
            iconPath!,
            width: 16.w,
            height: 16.w,
            colorFilter: const ColorFilter.mode(AppColors.colorTextWhite, BlendMode.srcIn),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.h,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    letterSpacing: 0,
                  ),
                ),
              child,
              if (hasDivider == true) BasicDivider(marginTop: 0),
              if (hasDivider == false) SizedBox(height: 12.h),
            ],
          ),
        ),
      ],
    );
  }
}
