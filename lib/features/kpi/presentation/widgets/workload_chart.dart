import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/error_message.dart';
import 'package:andersen/core/widgets/loading_indicator.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/kpi/presentation/cubit/workload_cubit.dart';
import 'package:andersen/features/kpi/presentation/cubit/workload_state.dart';
import 'package:andersen/features/kpi/presentation/widgets/workload_pie_chart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkloadChart extends StatelessWidget {
  const WorkloadChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkloadCubit, WorkloadState>(
      builder: (context, state) {
        if (state is WorkloadInitial || state is WorkloadLoading) {
          return LoadingIndicator();
        } else if (state is WorkloadLoadedError) {
          return ErrorMessage(errorMessage: state.message);
        } else if (state is WorkloadLoadedSuccess) {
          return ShadowContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  context.tr('workload'),
                  style: TextStyle(
                    color: AppColors.colorText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8.h),

                WorkloadPieChart(workloads: state.workload),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
