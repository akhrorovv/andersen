import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final EventEntity event;

  const EventDetailAppBar({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(color: AppColors.white),
      actions: [
        TextButton(
          onPressed: () async {
            // final updated = await context.pushCupertinoSheet<bool>(
            //   BlocProvider(
            //     create: (_) => sl<TaskUpdateCubit>(),
            //     child: UpdateTaskPage(task: event),
            //   ),
            // );
            // if (context.mounted && updated == true) {
            //   context.read<TaskDetailCubit>().getTaskDetail(event.id);
            // }
          },
          child: Text(
            "Edit",
            style: TextStyle(color: AppColors.white, fontSize: 12.sp, fontWeight: FontWeight.w500),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_vert, color: AppColors.white, size: 22),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
