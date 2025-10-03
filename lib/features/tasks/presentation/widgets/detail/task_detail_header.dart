import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_date.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskDetailHeader extends StatelessWidget {
  final TaskEntity task;

  const TaskDetailHeader({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 6.h),
      width: double.infinity,
      color: AppColors.colorPrimaryText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.h,
        children: [
          _descriptionText(task.description),
          _dueDateText(formatDueDate(task.dueAt, context)),
        ],
      ),
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
}
