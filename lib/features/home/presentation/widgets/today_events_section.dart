import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';

class TodayEventsList extends StatelessWidget {
  final List<EventEntity> events;

  const TodayEventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(child: Text("No events today"));
    }

    return ShadowContainer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: events.length,
        separatorBuilder: (context, index) => BasicDivider(),
        itemBuilder: (context, index) {
          final event = events[index];
          final time = DateFormat('HH:mm').format(event.startsAt!);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8.w,
                children: [
                  CircleAvatar(
                    radius: 4.r,
                    backgroundColor: AppColors.primary,
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorText,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  event.description ?? '-',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorText,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

