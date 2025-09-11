import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_card.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_chip.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TasksPage extends StatefulWidget {
  static String path = '/tasks';

  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  TaskStatus selected = TaskStatus.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tasks",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),

      body: Column(
        children: [
          /// Task status
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            color: AppColors.colorPrimaryText,
            height: 52.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: TaskStatus.values.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final status = TaskStatus.values[index];
                return TaskStatusChip(
                  status: status,
                  isSelected: selected == status,
                  onTap: () {
                    setState(() {
                      selected = status;
                    });
                  },
                );
              },
            ),
          ),

          BlocProvider(
            create: (context) => sl<TasksCubit>()..getTasks(),
            child: BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                if (state is TasksLoading && (state is! TasksLoaded)) {
                  return Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is TasksError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is TasksLoaded) {
                  final tasks = state.tasks.results;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        itemBuilder: (context, index) {
                          return TaskCard(task: tasks[index]);
                        },
                        separatorBuilder: (_, __) => BasicDivider(),
                        itemCount: tasks.length,
                      ),
                    ),
                  );
                }
                return Text("No tasks found");
              },
            ),
          ),
        ],
      ),
    );
  }
}
