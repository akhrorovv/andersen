import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_date.dart';
import 'package:andersen/core/utils/initial.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/presentation/widgets/detail/task_detail_item.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_filter.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskDetailInfo extends StatelessWidget {
  final TaskEntity task;
  final TaskStatus status;

  const TaskDetailInfo({super.key, required this.task, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.h,
      children: [
        _taskDetailText(context),
        ShadowContainer(
          child: Column(
            spacing: 16.h,
            children: [
              TaskDetailItem(
                title: context.tr('status'),
                iconPath: Assets.vectors.borderNone.path,
                value: status.label,
                color: status.color,
              ),
              TaskDetailItem(
                title: context.tr('description'),
                iconPath: Assets.vectors.textAlignLeft.path,
                value: task.description,
              ),
              TaskDetailItem(
                title: context.tr('relatedCase'),
                iconPath: Assets.vectors.briefcase.path,
                value: task.matter?.name,
                isMatter: true,
              ),
              TaskDetailItem(
                title: context.tr('assignedTo'),
                iconPath: Assets.vectors.borderNone.path,
                value: task.assignedStaff?.name,
                isMatter: true,
                initialName: getInitials(task.assignedStaff?.name),
              ),
              TaskDetailItem(
                title: context.tr('taskType'),
                iconPath: Assets.vectors.more.path,
                value: task.type?.name,
              ),
              TaskDetailItem(
                title: context.tr('dueDate'),
                iconPath: Assets.vectors.clock.path,
                value: formatDueDate(task.dueAt, context),
                hasDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _taskDetailText(BuildContext context) {
    return Text(
      context.tr('taskDetail'),
      style: TextStyle(
        color: AppColors.colorText,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.2,
      ),
    );
  }
}
