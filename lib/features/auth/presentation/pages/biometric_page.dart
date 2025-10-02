import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:andersen/features/auth/presentation/pages/enter_pin_page.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BiometricPage extends StatefulWidget {
  static String path = '/biometric';

  const BiometricPage({super.key});

  @override
  State<BiometricPage> createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: context.tr('security')),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: Column(
          children: [
            ShadowContainer(
              child: Row(
                spacing: 8.w,
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.primary,
                    child: Assets.images.fingerPrint.image(width: 18.w),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4.h,
                      children: [
                        Text(
                          context.tr('loginUsingBiometrics'),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.colorText,
                          ),
                        ),
                        Text(
                          context.tr('faceIdOrTouchId'),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoSwitch(
                    value: isEnabled,
                    activeTrackColor: AppColors.primary,
                    onChanged: (value) async {
                      setState(() => isEnabled = value);
                      await Future.wait([DBService.saveBiometricStatus(value)]);
                    },
                  ),
                ],
              ),
            ),
            Spacer(),

            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: BasicButton(
                title: context.tr('continue'),
                onTap: () {
                  context.go(EnterPinPage.path, extra: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
