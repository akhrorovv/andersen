import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/navigation/app_router.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/features/home/presentation/cubit/activity_status_cubit.dart';
import 'package:andersen/features/home/presentation/pages/stop_activity_page.dart';
import 'package:andersen/features/tasks/presentation/widgets/activity_start_modal_bottomsheet.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ActivityStatusButton extends StatelessWidget {
  const ActivityStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
            onTap = () async {
              final result = await context.pushCupertinoSheet<bool>(
                const ActivityStartModalBottomSheet(),
              );

              if (result == true) {
                context.read<ActivityStatusCubit>().checkActiveActivity();
              }
            };
          } else if (state is ActivityStatusLoading) {
            timeText = "00:00:00";
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
    );
  }
}
