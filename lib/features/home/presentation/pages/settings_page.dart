import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/utils/initial.dart';
import 'package:andersen/core/utils/phone_number_formatter.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/features/auth/presentation/pages/login_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  static String path = '/setting';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DBService.user;
    return Scaffold(
      appBar: BasicAppBar(title: context.tr('settings')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            color: AppColors.colorPrimaryText,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.colorPrimaryBgHover,
                  radius: 26.r,
                  child: Text(
                    getInitials(user?.name),
                    style: TextStyle(
                      color: AppColors.colorText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? "-",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        formatPhoneNumber(user?.phone ?? "-"),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: () {
              DBService.clear();
              context.go(LoginPage.path);
            },
            child: Text("Log out"),
          ),
        ],
      ),
    );
  }
}
