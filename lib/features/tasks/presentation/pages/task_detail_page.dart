import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../cubit/task_detail_cubit.dart';

class TaskDetailPage extends StatelessWidget {
  static String path = '/task_detail';
  final int taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.pop,
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Edit",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<TaskDetailCubit, TaskDetailState>(
        builder: (context, state) {
          if (state is TaskDetailInitial || state is TaskDetailLoading) {
            return SizedBox.expand(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          } else if (state is TaskDetailError) {
            return Center(
              child: Text(state.message, style: TextStyle(color: Colors.red)),
            );
          } else if (state is TaskDetailLoaded) {
            return Column(
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
                      Text(
                        state.task.description ?? "-",
                        style: TextStyle(
                          color: AppColors.colorTextWhite,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                          height: 1.4,
                        ),
                      ),
                      Text(
                        state.task.dueAt.toString(),
                        style: TextStyle(
                          color: AppColors.colorTextWhite,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
