import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/navigation/app_router.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/features/auth/presentation/pages/biometric_page.dart';
import 'package:andersen/features/home/presentation/pages/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class VerifyNewPinPage extends StatelessWidget {
  static String path = '/verify_mew_pin';

  final String newPin;

  const VerifyNewPinPage({super.key, required this.newPin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: context.tr('changePin')),


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
                if (enteredPin == newPin) {
                  await Future.wait([DBService.savePin(newPin)]);

                  context.go(HomePage.path);
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
