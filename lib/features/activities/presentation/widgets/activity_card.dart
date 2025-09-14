import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/utils/initial.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityCard extends StatelessWidget {
  final VoidCallback onTap;
  final ActivityEntity activity;

  const ActivityCard({super.key, required this.onTap, required this.activity});

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Row(
        spacing: 8.w,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 16.r,
            child: Text(
              getInitials(activity.matter?.name),
              style: TextStyle(
                color: AppColors.colorTextWhite,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 1,
                letterSpacing: 0,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity.matter?.name ?? '-',
                      style: TextStyle(
                        color: AppColors.colorBgMask,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      formatDuration(activity.userEnteredTimeInSeconds ?? 0),
                      style: TextStyle(
                        color: AppColors.colorBgMask,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
                Text(
                  activity.description ?? '-',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
