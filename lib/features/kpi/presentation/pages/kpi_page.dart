import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/kpi/presentation/widgets/kpi_bar_chart.dart';
import 'package:andersen/features/kpi/presentation/widgets/user_kpi_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: () {},
                    child: Text(
                      'Select date range',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 24.h),
                child: Column(
                  spacing: 12.h,
                  children: [
                    // user kpi
                    UserKpiSection(),

                    // kpis
                    KpiBarChart(),
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
