import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KpiPage extends StatelessWidget {
  static String path = '/kpi';

  const KpiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("KPI")),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          spacing: 12.h,
          children: [
            ShadowContainer(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6.h,
                    children: [
                      _myKpiText(),
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
              child: Column(children: [ShadowContainer(child: Container())]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myKpiText() {
    return Text(
      'My KPI',
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
