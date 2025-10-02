import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/navigation/app_router.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/features/auth/presentation/pages/biometric_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class VerifyPinPage extends StatelessWidget {
  static String path = '/verify_pin';

  final String pin;

  const VerifyPinPage({super.key, required this.pin});

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
              context.tr('verifyPin'),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.colorText,
              ),
            ),
            Pinput(
              length: 4,
              autofocus: true,
              obscureText: true,
              onCompleted: (enteredPin) async {
                if (enteredPin == pin) {
                  await Future.wait([DBService.savePin(pin)]);

                  context.pushCupertinoSheet(BiometricPage());
                } else {
                  BasicSnackBar.show(context, error: true, message: context.tr('pinMismatch'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
