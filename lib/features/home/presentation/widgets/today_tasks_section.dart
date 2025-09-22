import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodayTasksSection extends StatelessWidget {
  const TodayTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return BlocProvider(
      create: (context) => sl<TasksCubit>()
        ..getTasks(
          limit: 100,
          dueMin: '${startOfDay.toIso8601String()}Z',
          dueMax: '${endOfDay.toIso8601String()}Z',
        ),
      child: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) return const LoadingIndicator();
          if (state is TasksError) return ErrorWidget(state.message);

          if (state is TasksLoaded) {
            final tasks = state.tasks.results;

            final completedCount = tasks.where((t) => t.status == 'DONE').length;

            final totalSeconds = tasks.fold<int>(0, (sum, task) {
              final activities = task.activities ?? [];
              final seconds = activities.fold<int>(
                0,
                (s, a) => s + (a.userEnteredTimeInSeconds ?? 0),
              );
              return sum + seconds;
            });

            // final formattedTime = _formatDuration(Duration(seconds: totalSeconds));
            final formattedTime = formatDuration(totalSeconds);

            return Column(
              spacing: 12.h,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Assets.vectors.fileColour.svg(),
                        title: "Tasks for today",
                        value: tasks.length.toString(),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _StatCard(
                        icon: Assets.vectors.checkmark.svg(),
                        title: "Completed tasks",
                        value: completedCount.toString(),
                      ),
                    ),
                  ],
                ),
                _StatCard(
                  icon: Assets.vectors.timeQuarter.svg(),
                  title: "The time is counted today",
                  value: formattedTime,
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Duration ni `1h 34min` formatga o‘giradi
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) return '${hours}h ${minutes}min';
    if (hours > 0) return '${hours}h';
    return '${minutes}min';
  }
}

/// UI uchun reusable card
class _StatCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String value;

  const _StatCard({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.h,
        children: [
          Row(
            spacing: 8.w,
            children: [
              CircleAvatar(radius: 16.r, backgroundColor: AppColors.colorPrimaryBg, child: icon),
              Expanded(
                child: Text(
                  title,
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
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
