import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/format_duration.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_cubit.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_user_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActualPlanTable extends StatelessWidget {
  const ActualPlanTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KpiUserCubit, KpiUserState>(
      builder: (context, state) {
        if (state is KpiUserInitial || state is KpiUserLoading) {
          return LoadingIndicator();
        } else if (state is KpiUserLoadedError) {
          return ErrorMessage(errorMessage: state.message);
        } else if (state is KpiUserLoadedSuccess) {
          final plan = state.userKpi.sum?.durationInSeconds?.toInt() ?? 0;
          final fact = (state.userKpi.count?.id ?? 0) * 129600;
          final completion = calculateCompletion(plan, fact);
          return ShadowContainer(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('actualPlan'),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorText,
                  ),
                ),
                SizedBox(height: 8.h),
                Table(
                  border: TableBorder(horizontalInside: BorderSide(width: 0.5, color: Colors.grey)),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1.5),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(2),
                  },
                  children: [
                    // header row
                    TableRow(
                      children: [
                        _buildCell(context.tr('indicator'), isHeader: true),
                        _buildCell(context.tr('plan'), isHeader: true),
                        _buildCell(context.tr('fact'), isHeader: true),
                        _buildCell("% ${context.tr('completion')}", isHeader: true),
                      ],
                    ),
                    // content row
                    TableRow(
                      children: [
                        _buildCell(context.tr('hours')),
                        _buildCell(formatKpiDuration(plan)),
                        _buildCell(formatKpiDuration(fact)),
                        _buildCell(completion),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
      child: Text(
        text,
        style: TextStyle(fontWeight: isHeader ? FontWeight.w500 : FontWeight.w400, fontSize: 12.sp),
      ),
    );
  }
}
