import 'dart:io';

import 'package:andersen/core/common/navigation/app_router.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/utils/initial.dart';
import 'package:andersen/core/utils/phone_number_formatter.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/auth/presentation/pages/login_page.dart';
import 'package:andersen/features/home/presentation/pages/languages_page.dart';
import 'package:andersen/features/home/presentation/widgets/settings_tile.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  static String path = '/setting';

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String appVersion = '';

  Future<void> loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAppVersion();
  }

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
              spacing: 12.w,
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
                Expanded(
                  child: Column(
                    spacing: 8.h,
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

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                spacing: 16.h,
                children: [
                  ShadowContainer(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Column(
                      children: [
                        // SettingsTile(
                        //   iconPath: Assets.vectors.notification.path,
                        //   title: "Notifications",
                        //   subtitle: "Switch to disable",
                        //   trailing: CupertinoSwitch(
                        //     activeTrackColor: AppColors.primary,
                        //     value: true,
                        //     onChanged: (v) {},
                        //   ),
                        // ),
                        // BasicDivider(),
                        SettingsTile(
                          iconPath: Assets.vectors.global.path,
                          title: context.tr('language'),
                          subtitle: context.tr('changeLanguage'),
                          onTap: () {
                            context.pushCupertinoSheet(LanguagesPage());
                          },
                        ),
                        // BasicDivider(),
                        // SettingsTile(
                        //   iconPath: Assets.vectors.lock.path,
                        //   title: "Security",
                        //   subtitle: "Settings",
                        //   onTap: () {},
                        // ),
                      ],
                    ),
                  ),

                  /// logout button
                  GestureDetector(
                    onTap: () {
                      showLogoutDialog(context);
                    },
                    child: ShadowContainer(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Row(
                        spacing: 8.w,
                        children: [
                          CircleAvatar(
                            radius: 16.r,
                            backgroundColor: AppColors.red5,
                            child: Assets.vectors.logout.svg(),
                          ),
                          Text(
                            context.tr('logout'),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                              letterSpacing: 0,
                              color: AppColors.colorText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Spacer(),

                  Column(
                    spacing: 4.h,
                    children: [
                      Text(
                        context.tr('appVersion'),
                        style: TextStyle(
                          color: AppColors.colorBgMask,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          letterSpacing: 0,
                        ),
                      ),
                      Text(
                        appVersion,
                        style: TextStyle(
                          color: AppColors.colorBgMask,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showLogoutDialog(BuildContext context) async {
  if (Platform.isIOS) {
    // iOS style
    return showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              DBService.clear();
              context.go(LoginPage.path);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  } else {
    // Android style
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              DBService.clear();
              context.go(LoginPage.path);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}
