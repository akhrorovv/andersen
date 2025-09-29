import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/navigation/app_router.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/empty_widget.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/features/tasks/presentation/cubit/create_task_cubit.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:andersen/features/tasks/presentation/pages/create_task_page.dart';
import 'package:andersen/features/tasks/presentation/pages/task_detail_page.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_card.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_filter.dart';
import 'package:andersen/features/tasks/presentation/widgets/tasks_app_bar.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TasksPage extends StatefulWidget {
  static String path = '/tasks';

  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  TaskStatus selected = TaskStatus.all;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TasksCubit>()..getTasks(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: TasksAppBar(
              isSearching: isSearching,
              controller: searchController,
              onSearchTap: () => setState(() => isSearching = true),
              onClearTap: () {
                setState(() => isSearching = false);
                searchController.clear();
                context.read<TasksCubit>().clearSearch();
              },
              onSubmitted: (q) => context.read<TasksCubit>().searchTasks(q),
            ),

            body: Column(
              children: [
                /// Task status
                TaskStatusFilter(
                  selected: selected,
                  onChanged: (status) {
                    setState(() => selected = status);
                    context.read<TasksCubit>().getTasks(refresh: true, status: status);
                  },
                ),

                /// Tasks
                BlocBuilder<TasksCubit, TasksState>(
                  builder: (context, state) {
                    if (state is TasksInitial || state is TasksLoading) {
                      return Expanded(child: LoadingIndicator());
                    } else if (state is TasksError) {
                      return Expanded(child: ErrorMessage(errorMessage: state.message));
                    } else if (state is TasksLoaded) {
                      final tasks = state.tasks.results;

                      return Expanded(
                        child: tasks.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: (scrollInfo) {
                                    if (scrollInfo.metrics.pixels >=
                                        scrollInfo.metrics.maxScrollExtent - 200) {
                                      context.read<TasksCubit>().loadMore();
                                    }
                                    return false;
                                  },
                                  child: ListView.separated(
                                    padding: EdgeInsets.symmetric(vertical: 24.h),
                                    itemBuilder: (context, index) {
                                      return TaskCard(
                                        task: tasks[index],
                                        onTap: () async {
                                          context.push(TaskDetailPage.path, extra: tasks[index].id);
                                        },
                                      );
                                    },
                                    separatorBuilder: (_, __) => BasicDivider(),
                                    itemCount: tasks.length,
                                  ),
                                ),
                              )
                            : EmptyWidget(),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.primary,
              shape: CircleBorder(),
              onPressed: () async {
                final created = await context.pushCupertinoSheet<bool>(
                  BlocProvider(create: (_) => sl<CreateTaskCubit>(), child: CreateTaskPage()),
                );
                if (context.mounted && created == true) {
                  context.read<TasksCubit>().getTasks(refresh: true);
                }
              },
              child: Icon(Icons.add, color: AppColors.white),
            ),
          );
        },
      ),
    );
  }
}
