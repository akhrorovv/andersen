import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/features/home/presentation/widgets/kpi_card.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_user_repository.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_cubit.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_state.dart';
import 'package:andersen/features/kpi/presentation/pages/kpi_page.dart';
import 'package:andersen/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class KpiForWeek extends StatelessWidget {
  const KpiForWeek({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DBService.user;
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 7));

    return BlocProvider(
      create: (_) => sl<KpiUserCubit>()
        ..getUserKpi(
          user!.id,
          KpiUserRequest(
            limit: 100,
            offset: 0,
            startDate: startDate.toIso8601String(),
            endDate: now.toIso8601String(),
          ),
        ),
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
            return Column(
              spacing: 12.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kpiForWeekText(context),
                Row(
                  spacing: 12.w,
                  children: [
                    Expanded(
                      child: KpiCard(
                        title: context.tr('completedTasks'),
                        value: completedTasks.toString(),
                      ),
                    ),
                    Expanded(
                      child: KpiCard(
                        title: context.tr('totalTimeCounted'),
                        value: formatDuration(totalTime),
                      ),
                    ),
                  ],
                ),
                KpiCard(
                  title: context.tr('effectiveness'),
                  value: "$efficiency %",
                  effectiveness: efficiency,
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _kpiForWeekText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.tr('kpiForWeek'),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: AppColors.colorText,
            ),
          ),
          GestureDetector(
            onTap: () {
              context.go(KpiPage.path);
            },
            child: Text(
              context.tr('more'),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                decoration: TextDecoration.underline,
                color: AppColors.colorText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
