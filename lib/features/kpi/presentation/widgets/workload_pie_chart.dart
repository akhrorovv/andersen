import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/features/kpi/domain/entities/workload_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkloadPieChart extends StatelessWidget {
  final List<WorkloadEntity> workloads;

  const WorkloadPieChart({super.key, required this.workloads});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.teal,
      Colors.indigo,
      Colors.brown,
    ];

    final totalTasks = workloads.fold<int>(0, (sum, item) => sum + item.count.tasks);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.colorBgMask),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Pie Chart
          Container(
            width: 100.w,
            height: 100.w,
            padding: EdgeInsets.all(12.w),
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 20.r,
                sections: totalTasks == 0
                    ? [
                        PieChartSectionData(
                          value: 1,
                          color: Colors.grey.shade300,
                          title: '',
                          radius: 60,
                        ),
                      ]
                    : List.generate(workloads.length, (index) {
                        final workload = workloads[index];
                        final color = colors[index % colors.length];
                        final taskCount = workload.count.tasks;
                        final percentage = (taskCount / totalTasks) * 100;

                        return PieChartSectionData(
                          color: color,
                          value: taskCount.toDouble(),
                          title: "${percentage.toStringAsFixed(0)}%",
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }),
              ),
            ),
          ),

          SizedBox(width: 24.w),

          // Legend (yonidagi ro‘yxat)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(workloads.length, (index) {
                final workload = workloads[index];
                final color = colors[index % colors.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 9.w,
                        height: 9.w,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 2.h),
                          child: Text(
                            "${workload.name} - ${workload.count.tasks}",
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
