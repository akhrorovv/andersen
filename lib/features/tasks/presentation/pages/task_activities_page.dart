import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/tasks/domain/entities/activity_entity.dart';
import 'package:andersen/features/tasks/presentation/widgets/activity_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskActivitiesPage extends StatelessWidget {
  final List<ActivityEntity> activities;

  const TaskActivitiesPage({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: "Related time"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          children: [
            ShadowContainer(
              child: Column(
                children: List.generate(activities.length, (index) {
                  final activity = activities[index];
                  return Column(
                    children: [
                      ActivityItem(
                        description: "Description",
                        duration: activity.runTimeInSeconds,
                      ),
                      if (index != activities.length - 1) BasicDivider(),
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
