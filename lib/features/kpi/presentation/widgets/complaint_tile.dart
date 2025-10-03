import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/initial.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/kpi/domain/entities/complaint_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComplaintTile extends StatelessWidget {
  final ComplaintEntity complaint;

  const ComplaintTile({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: AppColors.primary,
            child: Text(
              getInitials(complaint.client?.name ?? '-'),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Text(
                  complaint.client?.name ?? '-',
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.2.h,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorBgMask,
                  ),
                ),
                Text(
                  complaint.comment ?? '-',
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.2.h,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
