import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_cubit.dart';
import 'package:andersen/features/kpi/presentation/cubit/kpi_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KpiBarChart extends StatelessWidget {
  const KpiBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KpiCubit, KpiState>(
      builder: (context, state) {
        if (state is KpiLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is KpiLoadedError) {
          return Text("Error: ${state.message}");
        } else if (state is KpiLoadedSuccess) {
          final kpis = state.resultsEntity.results;
          final visibleKpis = kpis.take(10).toList();

          final maxY = visibleKpis.isNotEmpty
              ? (visibleKpis.map((e) => e.value ?? 0).reduce((a, b) => a > b ? a : b)).toDouble() +
                    1
              : 10.0;

          return ShadowContainer(
            child: SizedBox(
              height: 250.h,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 28.w, interval: 2),
                    ),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: true, horizontalInterval: 1),
                  borderData: FlBorderData(show: true, border: Border.all(color: AppColors.grey2)),
                  barGroups: visibleKpis.isNotEmpty
                      ? List.generate(visibleKpis.length, (index) {
                          final kpi = visibleKpis[index];
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: (kpi.value ?? 0).toDouble(),
                                color: AppColors.chartColor,
                                width: 16.w,
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ],
                          );
                        })
                      : [],
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
