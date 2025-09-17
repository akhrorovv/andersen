import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/features/activities/presentation/cubit/activities_cubit.dart';
import 'package:andersen/features/activities/presentation/cubit/activities_state.dart';
import 'package:andersen/features/activities/presentation/pages/activity_detail_page.dart';
import 'package:andersen/features/activities/presentation/widgets/activity_card.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivitiesPage extends StatelessWidget {
  static String path = '/activities';

  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Activities",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocProvider(
        create: (_) => sl<ActivitiesCubit>()..getActivities(),
        child: BlocBuilder<ActivitiesCubit, ActivitiesState>(
          builder: (context, state) {
            if (state is ActivitiesInitial || state is ActivitiesLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is ActivitiesError) {
              return Center(
                child: Text(state.message, style: TextStyle(color: Colors.red)),
              );
            } else if (state is ActivitiesLoaded) {
              final activities = state.activities.results;
              if (activities.isEmpty) {
                return Center(child: Text("No Activities found"));
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                      context.read<ActivitiesCubit>().loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    itemBuilder: (context, index) {
                      return ActivityCard(
                        onTap: () {
                          context.pushCupertinoSheet(
                            ActivityDetailPage(
                              activityId: activities[index].id,
                            ),
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
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
