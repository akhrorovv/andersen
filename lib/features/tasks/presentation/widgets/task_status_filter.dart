import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskStatusFilter extends StatelessWidget {
  final TaskStatus selected;
  final ValueChanged<TaskStatus> onChanged;

  const TaskStatusFilter({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      color: AppColors.colorPrimaryText,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: TaskStatus.values.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final status = TaskStatus.values[index];
          return TaskStatusChip(
            status: status,
            isSelected: selected == status,
            onTap: () => onChanged(status),
          );
        },
      ),
    );
  }
}

enum TaskStatus { all, newTask, review, done }

extension TaskStatusX on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.all:
        return "All";
      case TaskStatus.newTask:
        return "New";
      case TaskStatus.review:
        return "Review";
      case TaskStatus.done:
        return "Done";
    }
  }

  String? get apiValue {
    switch (this) {
      case TaskStatus.all:
        return null;
      case TaskStatus.newTask:
        return "NEW";
      case TaskStatus.review:
        return "REVIEW";
      case TaskStatus.done:
        return "DONE";
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.all:
        return AppColors.grey;
      case TaskStatus.newTask:
        return AppColors.statusColorNew;
      case TaskStatus.review:
        return AppColors.statusColorReview;
      case TaskStatus.done:
        return AppColors.statusColorDone;
    }
  }

  static TaskStatus fromString(String? value) {
    switch (value?.toUpperCase()) {
      case "NEW":
        return TaskStatus.newTask;
      case "REVIEW":
        return TaskStatus.review;
      case "DONE":
        return TaskStatus.done;
      default:
        return TaskStatus.all;
    }
  }
}
