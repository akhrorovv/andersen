import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/empty_widget.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_cubit.dart';
import 'package:andersen/features/tasks/presentation/cubit/tasks_state.dart';
import 'package:andersen/features/tasks/presentation/pages/create_task_page.dart';
import 'package:andersen/features/tasks/presentation/pages/task_detail_page.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_card.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_status_filter.dart';
import 'package:andersen/features/tasks/presentation/widgets/tasks_app_bar.dart';
import 'package:andersen/service_locator.dart';
import 'package:dropdown_search/dropdown_search.dart';
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

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownSearch<TaskEntity>(
                    // items: (filter, cs) => matters,
                    items: (String? filter, props) async {
                      final result = await sl<TasksRepository>().getTasks(
                        limit: 5,
                        offset: 0,
                        assignedStaffId: 1,
                        search: (filter != null && filter.length >= 2) ? filter : null,
                      );

                      return result.fold((failure) => [], (tasksEntity) => tasksEntity.results);
                    },

                    compareFn: (a, b) => a.id == b.id,
                    itemAsString: (TaskEntity m) => m.description ?? '-',

                    // onChanged: (matter) => matterId = matter?.id,
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4),
                        hintText: "Select Case",
                        hintStyle: TextStyle(color: AppColors.black45),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: AppColors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),

                    popupProps: PopupProps.menu(
                      fit: FlexFit.loose,
                      showSearchBox: true,
                      showSelectedItems: true,
                      menuProps: MenuProps(
                        backgroundColor: AppColors.background,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: "Search...",
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                        // onChanged: (value) {
                        //   context.read<MatterCubit>().getMatters(refresh: true, search: value);
                        // },
                      ),
                    ),
                  ),
                ),

                /// Tasks
                BlocBuilder<TasksCubit, TasksState>(
                  builder: (context, state) {
                    if (state is TasksInitial || state is TasksLoading) {
                      return Expanded(child: LoadingIndicator());
                    } else if (state is TasksError) {
                      return ErrorMessage(errorMessage: state.message);
                    } else if (state is TasksLoaded) {
                      final tasks = state.tasks.results;
                      if (tasks.isEmpty) {
                        return EmptyWidget();
                      } else {
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
                                      context.push(TaskDetailPage.path, extra: tasks[index].id);
                                    },
                                  );
                                },
                                separatorBuilder: (_, __) => BasicDivider(),
                                itemCount: tasks.length,
                              ),
                            ),
                          ),
                        );
                      }
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
