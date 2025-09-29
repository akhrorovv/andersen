import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_cubit.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_state.dart';
import 'package:andersen/features/kpi/presentation/widgets/kpi_card.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KpiPage extends StatelessWidget {
  static String path = '/kpi';

  const KpiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('kpi'))),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          spacing: 12.h,
          children: [
            SizedBox(height: 24.h),
            ShadowContainer(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6.h,
                    children: [
                      _myKpiText(context),
                      Text(
                        "10 jun - 17 jun",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorText,
                          height: 1.2,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 12.h,
                  children: [
                    // kpis
                    BlocBuilder<KpiUserCubit, KpiUserState>(
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

                    // chart

                    // diagrams
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myKpiText(BuildContext context) {
    return Text(
      context.tr('myKpi'),
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24.sp,
        color: AppColors.colorPrimaryText,
        letterSpacing: 0,
        height: 1.2,
      ),
    );
  }
}
