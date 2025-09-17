import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskStatusChip extends StatelessWidget {
  final TaskStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  const TaskStatusChip({
    super.key,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black45 : AppColors.black15,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black5,
              offset: const Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            status.label,
            style: TextStyle(
              color: AppColors.colorTextWhite,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}


