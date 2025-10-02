import 'package:andersen/core/navigation/app_router.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_cubit.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_state.dart';
import 'package:andersen/features/kpi/presentation/pages/complaints.dart';
import 'package:andersen/features/kpi/presentation/pages/completed_tasks.dart';
import 'package:andersen/features/kpi/presentation/pages/confirmed_hours.dart';
import 'package:andersen/features/kpi/presentation/pages/rating.dart';
import 'package:andersen/features/kpi/presentation/pages/total_time_counted.dart';
import 'package:andersen/features/kpi/presentation/widgets/kpi_card.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserKpiSection extends StatelessWidget {
  const UserKpiSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KpiUserCubit, KpiUserState>(
      builder: (context, state) {
        if (state is KpiUserInitial || state is KpiUserLoading) {
          return LoadingIndicator();
        } else if (state is KpiUserLoadedError) {
          return ErrorMessage(errorMessage: state.message);
        } else if (state is KpiUserLoadedSuccess) {
          final totalTime = state.userKpi.sum?.durationInSeconds?.toInt() ?? 0;
          final completedTasks = (state.userKpi.avg?.tasksScore ?? 0).toInt();
          final efficiency = (state.userKpi.avg?.value ?? 0).toInt();
          final complaints = (state.userKpi.sum?.complaintsCount ?? 0).toInt();
          final rating = (state.userKpi.avg?.rating ?? 0).toInt();
          return GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 7 / 4,
            children: [
              KpiCard(
                iconPath: Assets.vectors.time.path,
                title: context.tr('totalTimeCounted'),
                value: formatDuration(totalTime),
                onTap: () {
                  context.pushCupertinoSheet(const TotalTimeCounted());
                },
              ),
              KpiCard(
                iconPath: Assets.vectors.moneyBag.path,
                title: context.tr('confirmedHours'),
                value: "00:00:00",
                onTap: () {
                  context.pushCupertinoSheet(const ConfirmedHours());
                },
              ),
              KpiCard(
                iconPath: Assets.vectors.checkmark.path,
                title: context.tr('completedTasks'),
                value: completedTasks.toString(),
                onTap: () {
                  context.pushCupertinoSheet(const CompletedTasks());
                },
              ),
              KpiCard(
                iconPath: Assets.vectors.startUp.path,
                title: context.tr('efficiency'),
                value: "$efficiency %",
                onTap: () {},
              ),
              KpiCard(
                iconPath: Assets.vectors.complaint.path,
                title: context.tr('complaint'),
                value: complaints.toString(),
                onTap: () {
                  context.pushCupertinoSheet(const Complaints());
                },
              ),
              KpiCard(
                iconPath: Assets.vectors.star.path,
                title: context.tr('rating'),
                value: "$rating/10",
                onTap: () {
                  context.pushCupertinoSheet(const Rating());

                },
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
