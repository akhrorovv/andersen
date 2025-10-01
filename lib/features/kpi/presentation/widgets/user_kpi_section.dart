import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_cubit.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_state.dart';
import 'package:andersen/features/kpi/presentation/widgets/kpi_card.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:andersen/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserKpiSection extends StatelessWidget {
  const UserKpiSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<KpiUserCubit>()..getUserKpi(111),
      child: BlocBuilder<KpiUserCubit, KpiUserState>(
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
                  title: "Total time counted",
                  value: formatDuration(totalTime),
                  onTap: () {},
                ),
                KpiCard(
                  iconPath: Assets.vectors.moneyBag.path,
                  title: "Confirmed hours",
                  value: "00:00:00",
                  onTap: () {},
                ),
                KpiCard(
                  iconPath: Assets.vectors.checkmark.path,
                  title: "Completed tasks",
                  value: completedTasks.toString(),
                  onTap: () {},
                ),
                KpiCard(
                  iconPath: Assets.vectors.startUp.path,
                  title: "Efficiency",
                  value: "$efficiency %",
                  onTap: () {},
                ),
                KpiCard(
                  iconPath: Assets.vectors.complaint.path,
                  title: "Complaints",
                  value: complaints.toString(),
                  onTap: () {},
                ),
                KpiCard(
                  iconPath: Assets.vectors.star.path,
                  title: "Rating",
                  value: "$rating/10",
                  onTap: () {},
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
