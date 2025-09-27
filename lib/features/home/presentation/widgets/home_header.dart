import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/home/presentation/cubit/activity_status_cubit.dart';
import 'package:andersen/features/home/presentation/pages/stop_activity_page.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.green,
                  ),
                  child: Center(
                    child: Text(
                      "Has Come",
                      style: TextStyle(
                        color: AppColors.greenText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.25.h,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),

                /// activity start/stop button
                BlocProvider(
                  create: (context) => sl<ActivityStatusCubit>()..checkActiveActivity(),
                  child: BlocBuilder<ActivityStatusCubit, ActivityStatusState>(
                    builder: (context, state) {
                      IconData icon = Icons.play_arrow;
                      String timeText = "00:00:00";
                      VoidCallback? onTap;

                      if (state is ActivityStatusActive) {
                        timeText = formatDuration(state.elapsedSeconds);
                        icon = Icons.pause;
                        onTap = () async {
                          final result = await context.push<bool>(
                            StopActivityPage.path,
                            extra: state.activity.id,
                          );

                          if (result == true) {
                            context.read<ActivityStatusCubit>().checkActiveActivity();
                          }
                        };

                      } else if (state is ActivityStatusInactive) {
                        timeText = "00:00:00";
                        onTap = () {};
                      } else if (state is ActivityStatusLoading) {
                        timeText = "...";
                      } else if (state is ActivityStatusError) {
                        timeText = "Error";
                      }
                      return GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColors.primary, width: 1.w),
                          ),
                          child: Row(
                            spacing: 8.w,
                            children: [
                              Icon(icon, color: AppColors.primary),
                              Text(
                                timeText,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.25.h,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
