import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/navigation/app_router.dart';
import 'package:andersen/core/network/connectivity_cubit.dart';
import 'package:andersen/core/network/connectivity_state.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/empty_widget.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/activities/presentation/pages/activity_detail_page.dart';
import 'package:andersen/features/activities/presentation/widgets/activity_card.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_activities_cubit.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_activities_state.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalTimeCounted extends StatelessWidget {
  final String startDate;
  final String endDate;

  const TotalTimeCounted({super.key, required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<KpiActivitiesCubit>()..getActivities(startDate: startDate, endDate: endDate),
      child: BlocListener<ConnectivityCubit, ConnectivityState>(
        listener: (context, connectivityState) {
          if (connectivityState is RetryRequested) {
            context.read<KpiActivitiesCubit>().getActivities(
              startDate: startDate,
              endDate: endDate,
            );
          }
        },
        child: Scaffold(
          appBar: BasicAppBar(title: context.tr('totalTimeCounted')),
          body: BlocBuilder<KpiActivitiesCubit, KpiActivitiesState>(
            builder: (context, state) {
              if (state is KpiActivitiesInitial || state is KpiActivitiesLoading) {
                return Center(child: CircularProgressIndicator(color: AppColors.primary));
              } else if (state is KpiActivitiesError) {
                return Center(child: ErrorMessage(errorMessage: state.message));
              } else if (state is KpiActivitiesLoaded) {
                final activities = state.activities.results;
                final count = activities.length;

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
                              context.tr('totalTimeCounted'),
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
                              context.read<KpiActivitiesCubit>().loadMore(
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
                              await context.read<KpiActivitiesCubit>().getActivities(
                                refresh: true,
                                startDate: startDate,
                                endDate: endDate,
                              );
                            },
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(vertical: 24.h),
                              itemBuilder: (context, index) {
                                return ActivityCard(
                                  onTap: () {
                                    context.pushCupertinoSheet(
                                      ActivityDetailPage(activityId: activities[index].id),
                                    );
                                  },
                                  activity: activities[index],
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  BasicDivider(marginTop: 8, marginBottom: 8),
                              itemCount: activities.length,
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
      ),
    );
  }
}
