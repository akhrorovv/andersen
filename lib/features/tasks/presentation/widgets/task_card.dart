import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_date.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskCard extends StatelessWidget {
  final VoidCallback onTap;
  final TaskEntity task;

  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = TaskStatusX.fromString(task.status);

    return GestureDetector(
      onTap: onTap,
      child: ShadowContainer(
        child: Column(
          spacing: 8.h,
          children: [
            // type & activities time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.type?.name ?? "-",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: task.type?.name != null
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: task.type?.name != null
                        ? AppColors.colorPrimaryText
                        : null,
                    letterSpacing: 0,
                  ),
                ),
                Text(
                  formatDurationFromActivities(task.activities),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),

            // matter
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.matter?.name ?? "-",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),

            // due time
            Row(
              children: [
                Text(
                  formatDueDate(task.dueAt),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),

            // status & description
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    task.description ?? "-",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                SizedBox(width: 18.w),
                Text(
                  status.label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: status.color,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
