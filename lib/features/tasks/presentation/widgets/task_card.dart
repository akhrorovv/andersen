import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/tasks/domain/entities/activity_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final VoidCallback onTap;
  final TaskEntity task;

  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String formatDurationFromActivities(List<ActivityEntity>? activities) {
      if (activities == null || activities.isEmpty) return "00:00:00";

      final totalSeconds = activities.fold<int>(
        0,
        (sum, activity) => sum + (activity.userEnteredTimeInSeconds ?? 0),
      );

      final duration = Duration(seconds: totalSeconds);

      final hours = duration.inHours.toString().padLeft(2, '0');
      final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

      return "$hours:$minutes:$seconds";
    }

    String formatDueDate(DateTime? dueAt) {
      if (dueAt == null) return "Due Date - ";

      final now = DateTime.now();
      final localDueAt = dueAt.toLocal();

      final isToday =
          now.year == localDueAt.year &&
          now.month == localDueAt.month &&
          now.day == localDueAt.day;

      final dayFormat = DateFormat('EEE, MMM d');
      final formattedDate = dayFormat.format(dueAt.toLocal());

      if (isToday) {
        return "Due Today, ${DateFormat('MMM d').format(dueAt.toLocal())}";
      } else {
        return "Due $formattedDate";
      }
    }

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
                  task.type?.name ?? "Unknown Type",
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
                    task.matter?.name ?? "No description",
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
                    task.description ?? "No description",
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
