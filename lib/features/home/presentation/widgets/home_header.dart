import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/home/presentation/cubit/attendee_cubit.dart';
import 'package:andersen/features/home/presentation/pages/reason_page.dart';
import 'package:andersen/features/home/presentation/widgets/activity_status_button.dart';
import 'package:andersen/features/home/presentation/widgets/attendee_button.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

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
            "${context.tr('hello')}, ${DBService.user?.name}",
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
                BlocProvider(
                  create: (context) => sl<AttendeeCubit>()..checkAttendeeStatus(),
                  child: BlocConsumer<AttendeeCubit, AttendeeState>(
                    listener: (context, state) {
                      if (state is AttendeeArriveSuccess) {
                        BasicSnackBar.show(context, message: "Welcome! You’ve arrived ✅");
                        // context.read<AttendeeCubit>().checkAttendeeStatus();
                        sl<AttendeeCubit>().checkAttendeeStatus();
                      } else if (state is AttendeeLeaveSuccess) {
                        BasicSnackBar.show(context, message: "Goodbye! You’ve left 👋");
                        // context.read<AttendeeCubit>().checkAttendeeStatus();
                        sl<AttendeeCubit>().checkAttendeeStatus();
                      } else if (state is AttendeeArriveError || state is AttendeeLeaveError) {
                        final msg = state is AttendeeArriveError
                            ? state.message
                            : (state as AttendeeLeaveError).message;
                        BasicSnackBar.show(context, message: msg, error: true);
                      }
                    },
                    builder: (context, state) {
                      if (state is AttendeeStatusLoading ||
                          state is AttendeeArriveLoading ||
                          state is AttendeeLeaveLoading) {
                        return const LoadingIndicator();
                      }

                      if (state is AttendeeStatusLoaded) {
                        // Has Left
                        return AttendeeButton(
                          title: "Has Left",
                          background: AppColors.volcano,
                          textColor: AppColors.volcanoText,
                          onTap: () async {
                            final now = DateTime.now();
                            final isEarly = now.hour < 18;

                            if (isEarly) {
                              final reason = await context.pushCupertinoSheet(ReasonPage());

                              if (reason != null && reason is String) {
                                context.read<AttendeeCubit>().leave(earlyReason: reason);
                              }
                            } else {
                              context.read<AttendeeCubit>().leave();
                            }
                          },
                        );
                      }

                      if (state is AttendeeStatusInactive) {
                        return AttendeeButton(
                          title: "Has Come",
                          background: AppColors.green,
                          textColor: AppColors.greenText,
                          onTap: () async {
                            try {
                              // 🔹 Lokatsiya servisi yoqilganmi?
                              final serviceEnabled = await Geolocator.isLocationServiceEnabled();
                              if (!serviceEnabled) {
                                await Geolocator.openLocationSettings();
                                return;
                              }

                              // 🔹 Permission check
                              LocationPermission permission = await Geolocator.checkPermission();
                              if (permission == LocationPermission.denied) {
                                permission = await Geolocator.requestPermission();
                                if (permission == LocationPermission.denied) {
                                  BasicSnackBar.show(context, message: "Location permission is required");
                                  return;
                                }
                              }

                              if (permission == LocationPermission.deniedForever) {
                                BasicSnackBar.show(context, message: "Please enable location in settings");
                                await Geolocator.openAppSettings();
                                return;
                              }

                              // 🔹 Lokatsiyani olish
                              final position = await Geolocator.getCurrentPosition(
                                locationSettings: const LocationSettings(
                                  accuracy: LocationAccuracy.high,
                                ),
                              );

                              // 🔹 Kech qoldimi?
                              final now = DateTime.now();
                              final isLate = now.hour > 9 || (now.hour == 9 && now.minute > 0);

                              if (isLate) {
                                final reason = await context.pushCupertinoSheet(ReasonPage());
                                if (reason != null && reason is String && reason.isNotEmpty) {
                                  context.read<AttendeeCubit>().arrive(
                                    latitude: position.latitude,
                                    longitude: position.longitude,
                                    lateReason: reason,
                                  );
                                } else {
                                  BasicSnackBar.show(context, message: "Please provide a reason");
                                }
                              } else {
                                context.read<AttendeeCubit>().arrive(
                                  latitude: position.latitude,
                                  longitude: position.longitude,
                                );
                              }
                            } catch (e) {
                              BasicSnackBar.show(context, message: "Error: $e", error: true);
                            }
                          },
                        );
                      }


                      if (state is AttendeeStatusError) {
                        return ErrorMessage(errorMessage: state.message);
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),

                /// activity status button
                const ActivityStatusButton(),
              ],
            ),
          ),

          Text(
            "${context.tr('gettingStarted')} - ",
            style: TextStyle(
              color: AppColors.colorText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.2.h,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
