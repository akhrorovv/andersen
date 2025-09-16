import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:andersen/features/tasks/presentation/pages/create_task_page.dart';
import 'package:andersen/features/tasks/presentation/pages/task_detail_page.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_card.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_chip.dart';
import 'package:andersen/gen/assets.gen.dart';
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
            appBar: AppBar(
              title: !isSearching
                  ? Text(
                      "Tasks",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : TextField(
                      controller: searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Search tasks...",
                        hintStyle: TextStyle(color: AppColors.grey),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: AppColors.white),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (query) {
                        context.read<TasksCubit>().searchTasks(query);
                      },
                    ),
              centerTitle: false,
              actions: [
                if (isSearching)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearching = false;
                        searchController.clear();
                      });
                      context.read<TasksCubit>().clearSearch();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 14.w),
                      child: Icon(Icons.clear, color: AppColors.white),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 14.w),
                      child: Assets.vectors.search.svg(),
                    ),
                  ),
              ],
            ),

            body: Column(
              children: [
                /// Task status
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 16.w,
                  ),
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
                          context.read<TasksCubit>().getTasks(
                            refresh: true,
                            status: status,
                          );
                        },
                      );
                    },
                  ),
                ),

                BlocBuilder<TasksCubit, TasksState>(
                  builder: (context, state) {
                    if (state is TasksInitial || state is TasksLoading) {
                      return Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
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
                      if (tasks.isEmpty) {
                        return Expanded(
                          child: Center(child: Text("No Tasks found")),
                        );
                      }
                      return Expanded(
                        child: Padding(
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
                                  onTap: () {
                                    context.push(
                                      TaskDetailPage.path,
                                      extra: tasks[index].id,
                                    );
                                  },
                                );
                              },
                              separatorBuilder: (_, __) => BasicDivider(marginTop: 12, marginBottom: 12),
                              itemCount: tasks.length,
                            ),
                          ),
                        ),
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
                // final result = await Navigator.of(context, rootNavigator: true).push(
                //   CupertinoSheetRoute(
                //     builder: (BuildContext context) {
                //       return NewTaskPage(controller: controller);
                //     },
                //   ),
                // );

                // if (result == true) {
                //   controller.fetchTasks(isRefresh: true);
                // }
                context.pushCupertinoSheet(CreateTaskPage());
              },
              child: Icon(Icons.add, color: AppColors.white),
            ),
          );
        },
      ),
    );
  }
}
