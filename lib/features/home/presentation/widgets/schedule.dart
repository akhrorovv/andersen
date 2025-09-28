import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_cubit.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_state.dart';
import 'package:andersen/features/calendar/presentation/pages/event_detail_page.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final now = DateTime.now();
  late final List<DateTime> days;
  late DateTime selectedDate;
  late EventsCubit eventsCubit;

  @override
  void initState() {
    super.initState();
    days = List.generate(5, (i) => DateTime(now.year, now.month, now.day + i));
    selectedDate = days.first;

    eventsCubit = sl<EventsCubit>();
    _fetchEventsForDate(selectedDate);
  }

  void _fetchEventsForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    eventsCubit.getEvents(
      refresh: true,
      dayMin: '${startOfDay.toIso8601String()}Z',
      dayMax: '${endOfDay.toIso8601String()}Z',
    );
  }

  @override
  void dispose() {
    eventsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _scheduleText(context),
        BlocProvider.value(
          value: eventsCubit,
          child: ShadowContainer(
            padding: EdgeInsets.only(right: 16.w, left: 16.w, bottom: 12.h, top: 8.h),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(days.length, (index) {
                      final date = days[index];
                      final isSelected = date == selectedDate;

                      final label = index == 0
                          ? context.tr('today')
                          : DateFormat('EEE d', context.locale.languageCode).format(date);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDate = date;
                          });
                          _fetchEventsForDate(date);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              label,
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.colorBgMask,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                BasicDivider(marginTop: 8, marginBottom: 12),

                BlocBuilder<EventsCubit, EventsState>(
                  builder: (context, state) {
                    if (state is EventsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is EventsError) {
                      return ErrorMessage(errorMessage: state.message);
                    } else if (state is EventsLoaded) {
                      final events = state.events.events;
                      if (events.isEmpty) {
                        return Center(child: Text(context.tr('noItemsFound')));
                      }
                      return _buildEventList(events, context);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventList(List<EventEntity> events, BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: events.length,
      separatorBuilder: (context, index) => BasicDivider(),
      itemBuilder: (context, index) {
        final event = events[index];
        final time = DateFormat('HH:mm').format(event.startsAt!);

        return InkWell(
          onTap: () async {
            final deleted = await context.push(EventDetailPage.path, extra: event.id);
            // if (deleted == true && context.mounted) {
            //   _fetchEventsForDate(selectedDate);
            // }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8.w,
                children: [
                  CircleAvatar(radius: 4.r, backgroundColor: AppColors.primary),
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
          ),
        );
      },
    );
  }

  Widget _scheduleText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Text(
        context.tr('schedule'),
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp, color: AppColors.colorText),
      ),
    );
  }
}
