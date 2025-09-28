import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/empty_widget.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_cubit.dart';
import 'package:andersen/features/calendar/presentation/cubit/events_state.dart';
import 'package:andersen/features/calendar/presentation/pages/event_detail_page.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UpcomingEvents extends StatelessWidget {
  const UpcomingEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _upcomingEventText(context),

        BlocProvider(
          create: (context) => sl<EventsCubit>()
            ..getEvents(
              dayMin: '${startOfDay.toIso8601String()}Z',
              dayMax: '${endOfDay.toIso8601String()}Z',
            ),
          child: BlocBuilder<EventsCubit, EventsState>(
            builder: (context, state) {
              if (state is EventsLoading) return const LoadingIndicator();
              if (state is EventsError) return ErrorWidget(state.message);
              if (state is EventsLoaded) {
                final events = state.events.events;
                return ShadowContainer(
                  child: (events.isNotEmpty)
                      ? ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: events.length,
                          separatorBuilder: (context, index) => BasicDivider(),
                          itemBuilder: (context, index) {
                            final event = events[index];
                            final time = DateFormat('HH:mm').format(event.startsAt!);
                            return InkWell(
                              onTap: () async {
                                final deleted = await context.push(
                                  EventDetailPage.path,
                                  extra: event.id,
                                );
                                // if (deleted == true && context.mounted) {
                                //   context.read<EventsCubit>().getEvents();
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
                        )
                      : EmptyWidget(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _upcomingEventText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Text(
        context.tr('upcomingEvent'),
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp, color: AppColors.colorText),
      ),
    );
  }
}
