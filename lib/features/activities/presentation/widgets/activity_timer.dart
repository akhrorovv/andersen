import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityTimer extends StatelessWidget {
  final DateTime? lastStartTime;
  final DateTime? lastEndTime;
  final int? userEnteredTimeInSeconds;

  const ActivityTimer({
    super.key,
    required this.lastStartTime,
    required this.lastEndTime,
    this.userEnteredTimeInSeconds,
  });

  @override
  Widget build(BuildContext context) {
    if (lastEndTime != null) {
      // ⏹️ Activity tugagan – userEnteredTimeInSeconds ni ko‘rsatamiz
      return Text(
        formatDuration(userEnteredTimeInSeconds ?? 0),
        style: TextStyle(
          color: AppColors.colorBgMask,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.2,
          letterSpacing: 0,
        ),
      );
    } else {
      // ▶️ Activity davom etmoqda – real vaqt hisoblash
      final start = lastStartTime?.toLocal() ?? DateTime.now();

      return StreamBuilder<int>(
        stream: Stream.periodic(const Duration(seconds: 1), (_) {
          final diff = DateTime.now().difference(start).inSeconds;
          return diff;
        }),
        builder: (context, snapshot) {
          final seconds = snapshot.data ?? 0;
          return Text(
            formatDuration(seconds),
            style: TextStyle(
              color: AppColors.colorBgMask,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.2,
              letterSpacing: 0,
            ),
          );
        },
      );
    }
  }
}
