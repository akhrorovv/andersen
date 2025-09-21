import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/initial.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/presentation/pages/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

// 📌 EventTile.dart
class EventTile extends StatelessWidget {
  final EventEntity event;

  const EventTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final start = event.startsAt;
    final end = event.endsAt;

    final formatted =
        "${DateFormat('MMM d, HH:mm').format(start!)} - ${DateFormat('MMM d, HH:mm').format(end!)}";

    return ShadowContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text(
              getInitials(event.matter?.name ?? ''),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
                height: 1,
                letterSpacing: 0,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.h,
            children: [
              Text(
                event.matter?.name ?? '-',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  height: 1.2,
                  letterSpacing: 0,
                ),
              ),
              Text(
                EventTargetX.fromString(event.target).label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  height: 1.2,
                  letterSpacing: 0,
                ),
              ),
              Text(
                event.description ?? '-',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  height: 1.2,
                  letterSpacing: 0,
                ),
              ),
              Text(
                formatted,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  height: 1.2,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
