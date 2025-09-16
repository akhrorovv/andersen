import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget activityStartModalBottomSheet() {
  return Material(
    child: Container(
      padding: EdgeInsets.only(top: 8.h, right: 16.w, left: 16.w, bottom: 16.h),
      color: AppColors.white,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Timekeeper",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Tap to record new time entry",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          BasicButton(
            title: "Start timer",
            icon: Assets.vectors.play.path,
            marginLeft: 0,
            marginRight: 0,
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}
