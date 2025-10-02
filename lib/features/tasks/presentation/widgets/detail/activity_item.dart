import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/features/activities/presentation/widgets/activity_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityItem extends StatelessWidget {
  final String description;
  final int? userEnteredTimeInSeconds;
  final DateTime? lastStartTime;
  final DateTime? lastEndTime;

  const ActivityItem({
    super.key,
    required this.description,
    this.userEnteredTimeInSeconds,
    this.lastStartTime,
    this.lastEndTime,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = lastEndTime == null && lastStartTime != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20.w,
      children: [
        Expanded(
          child: Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 1.2,
              letterSpacing: 0,
            ),
          ),
        ),
        isRunning
            ? ActivityTimer(
                lastStartTime: lastStartTime!,
                lastEndTime: lastEndTime,
                userEnteredTimeInSeconds: userEnteredTimeInSeconds ?? 0,
              )
            : Text(
                formatDuration(userEnteredTimeInSeconds ?? 0),
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
