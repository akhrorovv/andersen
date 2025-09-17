import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/tasks/presentation/widgets/detail/activity_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskActivitiesPage extends StatelessWidget {
  final ActivitiesEntity activities;

  const TaskActivitiesPage({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final allActivities = activities.results;
    return Scaffold(
      appBar: BasicAppBar(title: "Related time"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          children: [
            ShadowContainer(
              child: Column(
                children: List.generate(allActivities.length, (index) {
                  final activity = allActivities[index];
                  return Column(
                    children: [
                      ActivityItem(
                        description: activity.description ?? '-',
                        duration: activity.userEnteredTimeInSeconds ?? 0,
                      ),
                      if (index != allActivities.length - 1) BasicDivider(),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
