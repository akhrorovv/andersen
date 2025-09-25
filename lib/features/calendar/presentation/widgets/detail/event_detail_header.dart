import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/enum/event_target.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EventDetailHeader extends StatelessWidget {
  final EventEntity event;

  const EventDetailHeader({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final start = event.startsAt;
    final end = event.endsAt;

    final formatted =
        "${DateFormat('MMM d, HH:mm').format(start!)} - ${DateFormat('MMM d, HH:mm').format(end!)}";

    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 6.h),
      width: double.infinity,
      color: AppColors.colorPrimaryText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.h,
        children: [
          _descriptionText(EventTargetX.fromString(event.target).label),
          _dueDateText(formatted),
        ],
      ),
    );
  }

  Widget _descriptionText(String? description) {
    return Text(
      description ?? "-",
      style: TextStyle(
        color: AppColors.colorTextWhite,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
      ),
    );
  }

  Widget _dueDateText(String? dueDate) {
    return Text(
      dueDate ?? "-",
      style: TextStyle(
        color: AppColors.colorTextWhite,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.4,
      ),
    );
  }
}
