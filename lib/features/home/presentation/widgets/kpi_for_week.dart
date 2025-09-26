import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/features/home/presentation/widgets/kpi_card.dart';
import 'package:andersen/features/kpi/presentation/pages/kpi_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class KpiForWeek extends StatelessWidget {
  const KpiForWeek({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _kpiForWeekText(context),
        Row(
          spacing: 12.w,
          children: [
            Expanded(
              child: KpiCard(title: 'Completed tasks', value: '16'),
            ),
            Expanded(
              child: KpiCard(title: 'Total time counted', value: '00:00:00'),
            ),
          ],
        ),
        KpiCard(title: 'Effectiveness', value: '91%', hasProgress: true),
      ],
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
