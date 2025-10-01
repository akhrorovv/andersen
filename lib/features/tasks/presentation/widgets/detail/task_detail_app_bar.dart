import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/navigation/app_router.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_detail_cubit.dart';
import 'package:andersen/features/tasks/presentation/cubit/task_update_cubit.dart';
import 'package:andersen/features/tasks/presentation/pages/update_task_page.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TaskEntity task;

  const TaskDetailAppBar({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(color: AppColors.white),
      actions: [
        TextButton(
          onPressed: () async {
            final updated = await context.pushCupertinoSheet<bool>(
              BlocProvider(
                create: (_) => sl<TaskUpdateCubit>(),
                child: UpdateTaskPage(task: task),
              ),
            );
            if (context.mounted && updated == true) {
              context.read<TaskDetailCubit>().getTaskDetail(task.id);
            }
          },
          child: Text(
            context.tr('edit'),
            style: TextStyle(color: AppColors.white, fontSize: 12.sp),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
