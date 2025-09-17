import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/default_widget.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_detail_state.dart';
import 'package:andersen/features/tasks/presentation/widgets/activity_start_modal_bottomsheet.dart';
import 'package:andersen/features/tasks/presentation/widgets/detail/task_activities_section.dart';
import 'package:andersen/features/tasks/presentation/widgets/detail/task_detail_app_bar.dart';
import 'package:andersen/features/tasks/presentation/widgets/detail/task_detail_header.dart';
import 'package:andersen/features/tasks/presentation/widgets/detail/task_detail_info.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          return LoadingIndicator();
        } else if (state is TaskDetailError) {
          return ErrorMessage(errorMessage: state.message);
        } else if (state is TaskDetailLoaded) {
          final task = state.task;
          final status = TaskStatusX.fromString(task.status);

          return Scaffold(
            appBar: TaskDetailAppBar(task: task),
            body: Column(
              children: [
                TaskDetailHeader(task: task),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16.h,
                        children: [
                          TaskActivitiesSection(taskId: taskId),
                          TaskDetailInfo(task: task, status: status),
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
}
