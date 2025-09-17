import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_date.dart';
import 'package:andersen/core/utils/initial.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/default_widget.dart';
import 'package:andersen/core/widgets/loading_page.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/tasks/domain/entities/activity_entity.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_activities_cubit.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_activities_state.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_detail_state.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_update_cubit.dart';
import 'package:andersen/features/tasks/presentation/pages/task_activities_page.dart';
import 'package:andersen/features/tasks/presentation/pages/update_task_page.dart';
import 'package:andersen/features/tasks/presentation/widgets/activity_item.dart';
import 'package:andersen/features/tasks/presentation/widgets/activity_start_modal_bottomsheet.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_detail_item.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_chip.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_filter.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../cubit/task_detail_cubit.dart';

class TaskDetailPage extends StatelessWidget {
  static String path = '/task_detail';
  final int taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskDetailCubit, TaskDetailState>(
      builder: (context, state) {
        if (state is TaskDetailInitial || state is TaskDetailLoading) {
          return SizedBox.expand(child: LoadingPage());
        } else if (state is TaskDetailError) {
          return Center(
            child: Text(state.message, style: TextStyle(color: Colors.red)),
          );
        } else if (state is TaskDetailLoaded) {
          final task = state.task;
          final status = TaskStatusX.fromString(task.status);

          final activities = state.task.activities ?? [];
          // final limited = activities.take(3).toList();

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: context.pop,
                icon: Icon(Icons.arrow_back, color: AppColors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final updated = await context.pushCupertinoSheet<bool>(
                      BlocProvider(
                        create: (_) => sl<TaskUpdateCubit>(),
                        child: UpdateTaskPage(task: task),
                      ),
                    );

                    if (!context.mounted) return;

                    if (updated == true) {
                      context.read<TaskDetailCubit>().getTaskDetail(task.id);
                    }
                  },

                  child: Text(
                    "Edit",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    bottom: 6.h,
                  ),
                  width: double.infinity,
                  color: AppColors.colorPrimaryText,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4.h,
                    children: [
                      _descriptionText(state.task.description),
                      _dueDateText(formatDueDate(state.task.dueAt)),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocProvider(
                            create: (_) =>
                                sl<TaskActivitiesCubit>()
                                  ..getTaskActivities(taskId: taskId),
                            child:
                                BlocBuilder<
                                  TaskActivitiesCubit,
                                  TaskActivitiesState
                                >(
                                  builder: (context, state) {
                                    if (state is TaskActivitiesInitial ||
                                        state is TaskActivitiesLoading) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      );
                                    } else if (state is TaskActivitiesError) {
                                      return Center(
                                        child: Text(
                                          state.message,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      );
                                    } else if (state is TaskActivitiesLoaded) {
                                      final allActivities =
                                          state.activities.results;

                                      final limited = allActivities
                                          .take(3)
                                          .toList();

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
                                                    children: List.generate(
                                                      limited.length,
                                                      (index) {
                                                        final activity =
                                                            limited[index];
                                                        return Column(
                                                          children: [
                                                            ActivityItem(
                                                              description:
                                                                  activity
                                                                      .description ??
                                                                  '-',
                                                              duration:
                                                                  activity
                                                                      .userEnteredTimeInSeconds ??
                                                                  0,
                                                            ),
                                                            if (index !=
                                                                limited.length -
                                                                    1)
                                                              BasicDivider(),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Center(
                                                    child: Text(
                                                      "No activities",
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      );
                                    }
                                    return SizedBox.shrink();
                                  },
                                ),
                          ),
                          SizedBox(height: 16.h),
                          _taskDetailText(),
                          SizedBox(height: 12.h),
                          ShadowContainer(
                            child: Column(
                              spacing: 16.h,
                              children: [
                                TaskDetailItem(
                                  title: "Status",
                                  iconPath: Assets.vectors.borderNone.path,
                                  value: status.label,
                                  color: status.color,
                                ),
                                TaskDetailItem(
                                  title: "Description",
                                  iconPath: Assets.vectors.textAlignLeft.path,
                                  value: task.description,
                                ),
                                TaskDetailItem(
                                  title: "Related case",
                                  iconPath: Assets.vectors.briefcase.path,
                                  value: task.matter?.name,
                                  isMatter: true,
                                ),
                                TaskDetailItem(
                                  title: "Assigned to",
                                  iconPath: Assets.vectors.borderNone.path,
                                  value: task.assignedStaff?.name,
                                  isMatter: true,
                                  initialName: getInitials(
                                    task.assignedStaff?.name,
                                  ),
                                ),
                                TaskDetailItem(
                                  title: "Task type",
                                  iconPath: Assets.vectors.more.path,
                                  value: task.type?.name,
                                ),
                                TaskDetailItem(
                                  title: "Due Date",
                                  iconPath: Assets.vectors.clock.path,
                                  value: formatDueDate(task.dueAt),
                                  hasDivider: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            floatingActionButton:
                context.read<TaskDetailCubit>().isActivityCreatable(task)
                ? FloatingActionButton(
                    backgroundColor: AppColors.primary,
                    shape: CircleBorder(),
                    onPressed: () async {
                      showCupertinoModalBottomSheet(
                        context: context,
                        topRadius: Radius.circular(16.r),
                        builder: (context) => activityStartModalBottomSheet(),
                      );
                    },
                    child: Icon(Icons.add, color: AppColors.white),
                  )
                : null,
          );
        }
        return DefaultWidget();
      },
    );
  }

  Widget _descriptionText(String? description) {
    return Text(
      description ?? "-",
      style: TextStyle(
        color: AppColors.colorTextWhite,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
      ),
    );
  }

  Widget _dueDateText(String? dueDate) {
    return Text(
      dueDate ?? "-",
      style: TextStyle(
        color: AppColors.colorTextWhite,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.4,
      ),
    );
  }

  Widget _taskDetailText() {
    return Text(
      "Task details",
      style: TextStyle(
        color: AppColors.colorText,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.2,
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
