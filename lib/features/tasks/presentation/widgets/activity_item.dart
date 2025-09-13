import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityItem extends StatelessWidget {
  final String description;
  final int duration;

  const ActivityItem({
    super.key,
    required this.description,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 1.2.h,
              letterSpacing: 0,
            ),
          ),
        ),
        Text(
          formatDuration(duration),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.colorBgMask,
            fontWeight: FontWeight.w400,
            height: 1.2,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}
