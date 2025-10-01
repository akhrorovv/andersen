import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/presentation/widgets/event_tile.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

// 📌 DayEventsSection.dart
class DayEventsSection extends StatelessWidget {
  final DateTime day;
  final List<EventEntity> events;

  const DayEventsSection({super.key, required this.day, required this.events});

  @override
  Widget build(BuildContext context) {
    final locale = DBService.locale;

    return Container(
      margin: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Sana header
          Text(
            DateFormat('EEE, MMM d', locale).format(day),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.colorText,
              height: 1.2,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 12.h),

          if (events.isEmpty)
            ShadowContainer(
              child: Row(
                spacing: 8.w,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.colorPrimaryBg,
                    child: Assets.vectors.calendar.svg(color: AppColors.colorText),
                  ),
                  Text(
                    context.tr('noEvents'),
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
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h.h),
              itemBuilder: (context, index) {
                return EventTile(event: events[index]);
              },
            ),
        ],
      ),
    );
  }
}
