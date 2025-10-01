import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsPage extends StatelessWidget {
  static String path = '/notifications';

  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: context.tr('notifications')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.images.bell.image(height: 114.h),
            SizedBox(height: 24.h),
            Text(
              "${context.tr('allClear')}!",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            Text(
              '${context.tr('youAreAllCaughtUp')}.',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
