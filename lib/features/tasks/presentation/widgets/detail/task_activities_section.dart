import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_activities_cubit.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_activities_state.dart';
import 'package:andersen/features/tasks/presentation/pages/task_activities_page.dart';
import 'package:andersen/features/tasks/presentation/widgets/detail/activity_item.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskActivitiesSection extends StatelessWidget {
  final int taskId;

  const TaskActivitiesSection({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TaskActivitiesCubit>()..getTaskActivities(taskId: taskId),
      child: BlocBuilder<TaskActivitiesCubit, TaskActivitiesState>(
        builder: (context, state) {
          if (state is TaskActivitiesInitial || state is TaskActivitiesLoading) {
            return LoadingIndicator();
          } else if (state is TaskActivitiesError) {
            return ErrorWidget(state.message);
          } else if (state is TaskActivitiesLoaded) {
            final activities = state.activities.results;
            final limited = activities.take(3).toList();

            return Column(
              children: [
                _relatedTimesText(
                  context: context,
                  activities: state.activities,
                  taskId: taskId,
                ),
                ShadowContainer(
                  child: activities.isNotEmpty
                      ? Column(
                          children: List.generate(limited.length, (index) {
                            final activity = limited[index];
                            return Column(
                              children: [
                                ActivityItem(
                                  description: activity.description ?? '-',
                                  duration:
                                      activity.userEnteredTimeInSeconds ?? 0,
                                ),
                                if (index != limited.length - 1) BasicDivider(),
                              ],
                            );
                          }),
                        )
                      : Center(child: Text("No activities")),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _relatedTimesText({
    required BuildContext context,
    required ActivitiesEntity activities,
    required int taskId,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Related time",
            style: TextStyle(
              color: AppColors.colorText,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              height: 1.2,
              letterSpacing: 0,
            ),
          ),
          if (activities.results.length > 3)
            GestureDetector(
              onTap: () {
                context.pushCupertinoSheet(
                  TaskActivitiesPage(activities: activities),
                );
              },
              child: Text(
                "More",
                style: TextStyle(
                  color: AppColors.colorText,
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  height: 1.2,
                  letterSpacing: 0,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
