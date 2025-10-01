import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom Calendar Widget
class CustomCalendar<T> extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final void Function(DateTime selectedDay, DateTime focusedDay)? onDaySelected;
  final ValueChanged<CalendarFormat>? onFormatChanged;
  final List<T> Function(DateTime day)? eventLoader;
  final ValueChanged<DateTime>? onPageChanged;

  const CustomCalendar({
    super.key,
    required this.focusedDay,
    required this.calendarFormat,
    this.selectedDay,
    this.onDaySelected,
    this.onFormatChanged,
    this.eventLoader,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(color: AppColors.colorPrimaryText),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.black15,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TableCalendar<T>(
              locale: DBService.locale,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: focusedDay,
              calendarFormat: calendarFormat,
              selectedDayPredicate: (day) => selectedDay != null && isSameDay(selectedDay, day),
              onDaySelected: onDaySelected,
              onFormatChanged: onFormatChanged,
              eventLoader: eventLoader,
              onPageChanged: onPageChanged,

              // Styling
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 1.w),
                ),
                selectedDecoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
                defaultTextStyle: TextStyle(
                  color: AppColors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                selectedTextStyle: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                weekendTextStyle: TextStyle(
                  color: AppColors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                outsideDaysVisible: false,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(
                  color: AppColors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                weekdayStyle: TextStyle(
                  color: AppColors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              headerVisible: false,

              // for dots
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  return Positioned(
                    bottom: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: events.take(1).map((event) {
                        return Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),

          /// Toggle button
          GestureDetector(
            onTap: () {
              final newFormat = calendarFormat == CalendarFormat.month
                  ? CalendarFormat.week
                  : CalendarFormat.month;
              onFormatChanged?.call(newFormat);
            },
            child: Icon(
              calendarFormat == CalendarFormat.month
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 18.sp,
              color: Color(0xff69B1FF),
            ),
          ),
        ],
      ),
    );
  }
}
