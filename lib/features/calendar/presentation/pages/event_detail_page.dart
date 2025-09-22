import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/enum/event_target.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/core/widgets/default_widget.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/calendar/presentation/cubit/delete_event_cubit.dart';
import 'package:andersen/features/calendar/presentation/cubit/event_detail_cubit.dart';
import 'package:andersen/features/calendar/presentation/cubit/event_detail_state.dart';
import 'package:andersen/features/calendar/presentation/pages/calendar_page.dart';
import 'package:andersen/features/calendar/presentation/widgets/detail/event_detail_app_bar.dart';
import 'package:andersen/features/calendar/presentation/widgets/detail/event_detail_header.dart';
import 'package:andersen/features/calendar/presentation/widgets/detail/event_detail_item.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EventDetailPage extends StatelessWidget {
  static String path = '/event_detail';
  final int eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteEventCubit, DeleteEventState>(
          listener: (context, state) {
            if (state is DeleteEventSuccess) {
              context.go(CalendarPage.path);
            } else if (state is DeleteEventError) {
              BasicSnackBar.show(context, message: state.message, error: true);
            }
          },
        ),
      ],
      child: BlocBuilder<EventDetailCubit, EventDetailState>(
        builder: (context, state) {
          if (state is EventDetailInitial || state is EventDetailLoading) {
            return const LoadingIndicator();
          } else if (state is EventDetailError) {
            return ErrorMessage(errorMessage: state.message);
          } else if (state is EventDetailLoaded) {
            final event = state.event;
            return Scaffold(
              appBar: EventDetailAppBar(event: event),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventDetailHeader(event: event),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12.h,
                        children: [
                          _taskDetailText(),
                          ShadowContainer(
                            child: Column(
                              spacing: 16.h,
                              children: [
                                EventDetailItem(
                                  title: "Event target",
                                  iconPath: Assets.vectors.calendarFav.path,
                                  value: EventTargetX.fromString(event.target).label,
                                ),
                                EventDetailItem(
                                  title: "Location",
                                  iconPath: Assets.vectors.location.path,
                                  value: event.location,
                                ),
                                EventDetailItem(
                                  title: "Description",
                                  iconPath: Assets.vectors.textAlignLeft.path,
                                  value: event.description,
                                ),
                                EventDetailItem(
                                  title: "Related case",
                                  iconPath: Assets.vectors.briefcase.path,
                                  value: event.matter?.name,
                                  isMatter: true,
                                  hasDivider: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return DefaultWidget();
        },
      ),
    );
  }

  Widget _taskDetailText() {
    return Text(
      "Event details",
      style: TextStyle(
        color: AppColors.colorText,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.2,
      ),
    );
  }
}
