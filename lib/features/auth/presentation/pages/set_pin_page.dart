import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/features/auth/presentation/pages/verify_pin_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class SetPinPage extends StatefulWidget {
  static String path = '/set_pin';

  const SetPinPage({super.key});

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  String? firstPin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 24.h,
          children: [
            Text(
              context.tr('enterNewPin'),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.colorText,
              ),
            ),
            Pinput(
              autofocus: true,
              length: 4,
              obscureText: true,
              onCompleted: (pin) {
                setState(() {
                  firstPin = pin;
                });
                context.go(VerifyPinPage.path, extra: firstPin);
              },
            ),
          ],
        ),
      ),
    );
  }
}
