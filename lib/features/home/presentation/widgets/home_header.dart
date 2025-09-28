import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/home/domain/entities/user_entity.dart';
import 'package:andersen/features/home/presentation/cubit/attendee_cubit.dart';
import 'package:andersen/features/home/presentation/pages/reason_page.dart';
import 'package:andersen/features/home/presentation/widgets/activity_status_button.dart';
import 'package:andersen/features/home/presentation/widgets/attendee_actions.dart';
import 'package:andersen/features/home/presentation/widgets/attendee_button.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class HomeHeader extends StatefulWidget {
  final UserEntity user;

  const HomeHeader({super.key, required this.user});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final formattedDate = DateFormat("EEEE, dd MMMM", locale).format(DateTime.now());

    return ShadowContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // hello, user
          Text(
            "${context.tr('hello')}, ${widget.user.name}",
            style: TextStyle(
              color: AppColors.colorPrimaryText,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              height: 1.2.h,
              letterSpacing: 0,
            ),
          ),
          // date
          Text(
            formattedDate,
            style: TextStyle(
              color: AppColors.colorText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.2.h,
              letterSpacing: 0,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// has come & has left button
                BlocConsumer<AttendeeCubit, AttendeeState>(
                  listener: (context, state) {
                    if (state is AttendeeArriveSuccess) {
                      BasicSnackBar.show(context, message: "Welcome! You’ve arrived ✅");
                      context.read<AttendeeCubit>().checkAttendeeStatus();
                    } else if (state is AttendeeLeaveSuccess) {
                      BasicSnackBar.show(context, message: "Goodbye! You’ve left 👋");
                      context.read<AttendeeCubit>().checkAttendeeStatus();
                    } else if (state is AttendeeArriveError || state is AttendeeLeaveError) {
                      final msg = state is AttendeeArriveError
                          ? state.message
                          : (state as AttendeeLeaveError).message;
                      BasicSnackBar.show(context, message: msg, error: true);
                    } else if (state is AttendeeStatusError) {
                      BasicSnackBar.show(context, message: state.message, error: true);
                    }
                  },
                  builder: (context, state) {
                    final isLoading =
                        state is AttendeeStatusLoading ||
                        state is AttendeeArriveLoading ||
                        state is AttendeeLeaveLoading;

                    if (state is AttendeeStatusLoaded) {
                      return AttendeeButton.hasLeft(
                        isLoading: isLoading,
                        onTap: () async {
                          final now = DateTime.now();
                          final isEarly = now.hour < 18;
                          if (isEarly) {
                            final reason = await context.pushCupertinoSheet(ReasonPage());
                            if (reason != null && reason is String && reason.isNotEmpty) {
                              context.read<AttendeeCubit>().leave(earlyReason: reason);
                            }
                          } else {
                            context.read<AttendeeCubit>().leave();
                          }
                        },
                      );
                    }

                    if (state is AttendeeStatusInactive) {
                      return AttendeeButton.hasCome(
                        isLoading: isLoading,
                        onTap: () async => await AttendeeActions.handleArrive(context),
                      );
                    }

                    if (state is AttendeeStatusError) {
                      return ErrorMessage(errorMessage: state.message);
                    }

                    return const SizedBox.shrink();
                  },
                ),

                /// activity status button
                const ActivityStatusButton(),
              ],
            ),
          ),

          BlocBuilder<AttendeeCubit, AttendeeState>(
            builder: (context, state) {
              if (state is AttendeeStatusLoaded) {
                final attendee = state.attendee;
                final time = DateFormat("HH:mm").format(attendee.arrivedAt!.toLocal());

                return Text(
                  "Getting started - $time",
                  style: TextStyle(
                    color: AppColors.colorText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.2.h,
                  ),
                );
              }

              if (state is AttendeeStatusInactive) {
                return Text(
                  "To get started, please click on the \"Has come\" button!",
                  style: TextStyle(
                    color: AppColors.colorBgMask,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.2.h,
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
