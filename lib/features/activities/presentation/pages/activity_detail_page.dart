import 'package:andersen/core/utils/format_date.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/default_widget.dart';
import 'package:andersen/core/widgets/loading_page.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/activities/presentation/cubit/activity_detail_cubit.dart';
import 'package:andersen/features/activities/presentation/cubit/activity_detail_state.dart';
import 'package:andersen/features/activities/presentation/widgets/activity_detail_item.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityDetailPage extends StatelessWidget {
  static String path = '/activity_detail';

  final int activityId;

  const ActivityDetailPage({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ActivityDetailCubit>()..getActivityDetail(activityId),
      child: BlocBuilder<ActivityDetailCubit, ActivityDetailState>(
        builder: (context, state) {
          if (state is ActivityDetailInitial || state is ActivityDetailLoading) {
            return SizedBox.expand(child: LoadingPage());
          } else if (state is ActivityDetailError) {
            return Center(
              child: Text(state.message, style: TextStyle(color: Colors.red)),
            );
          } else if (state is ActivityDetailLoaded) {
            final activity = state.activity;

            return Scaffold(
              appBar: BasicAppBar(title: context.tr('activityDetail')),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  children: [
                    ShadowContainer(
                      child: Column(
                        spacing: 16.h,
                        children: [
                          ActivityDetailItem(
                            title: context.tr('relatedCase'),
                            iconPath: Assets.vectors.briefcase.path,
                            value: activity.matter?.name,
                            isMatter: true,
                          ),
                          ActivityDetailItem(
                            title: context.tr('description'),
                            iconPath: Assets.vectors.textAlignLeft.path,
                            value: activity.description,
                          ),
                          ActivityDetailItem(
                            title: context.tr('relatedTime'),
                            iconPath: Assets.vectors.clock.path,
                            value: formatDuration(activity.userEnteredTimeInSeconds ?? 0),
                          ),
                          ActivityDetailItem(
                            title: context.tr('date'),
                            iconPath: Assets.vectors.clock.path,
                            value: formatDueDate(activity.date, context),
                            hasDivider: false,
                          ),
                          // ActivityDetailItem(
                          //   title: "Invoice status",
                          //   iconPath: Assets.vectors.file.path,
                          //   value: activity.billingPeriodId,
                          //   hasDivider: false,
                          //   isInvoice: true,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return DefaultWidget();
        },
      ),
    );
  }
}
