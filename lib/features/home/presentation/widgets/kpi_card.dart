import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final bool hasProgress;

  const KpiCard({super.key, required this.title, required this.value, this.hasProgress = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.2,
              letterSpacing: 0,
              color: AppColors.colorTextWhite,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 0,
              color: AppColors.colorTextWhite,
            ),
          ),
          if (hasProgress)
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: 91 / 100,
              minHeight: 6.h,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff73D13D)),
            ),
          ),
        ],
      ),
    );
  }
}
