import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/empty_widget.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_tasks_cubit.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_tasks_state.dart';
import 'package:andersen/features/tasks/presentation/pages/task_detail_page.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_card.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CompletedTasks extends StatelessWidget {
  final String startDate;
  final String endDate;

  const CompletedTasks({super.key, required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<KpiTasksCubit>()..getTasks(startDate: startDate, endDate: endDate),
      child: Scaffold(
        appBar: BasicAppBar(title: context.tr('completedTasks')),
        body: BlocBuilder<KpiTasksCubit, KpiTasksState>(
          builder: (context, state) {
            if (state is KpiTasksInitial || state is KpiTasksLoading) {
              return LoadingIndicator();
            } else if (state is KpiTasksError) {
              return ErrorMessage(errorMessage: state.message);
            } else if (state is KpiTasksLoaded) {
              final tasks = state.tasks.results;
              final count = tasks.length;
              if (count == 0) {
                return EmptyWidget();
              }
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                child: Column(
                  children: [
                    ShadowContainer(
                      child: Column(
                        spacing: 8.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('completedTasks'),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.2.h,
                              letterSpacing: 0,
                              color: AppColors.black,
                            ),
                          ),
                          Text(
                            count.toString(),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.2.h,
                              letterSpacing: 0,
                              color: AppColors.colorText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent - 200) {
                            context.read<KpiTasksCubit>().loadMore(
                              startDate: startDate,
                              endDate: endDate,
                            );
                          }
                          return false;
                        },
                        child: RefreshIndicator(
                          color: AppColors.primary,
                          backgroundColor: Colors.white,
                          displacement: 50.h,
                          strokeWidth: 3,
                          onRefresh: () async {
                            await context.read<KpiTasksCubit>().getTasks(
                              refresh: true,
                              startDate: startDate,
                              endDate: endDate,
                            );
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
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
