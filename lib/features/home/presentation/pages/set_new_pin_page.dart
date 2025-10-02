import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/navigation/app_router.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/features/home/presentation/pages/verify_new_pin_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class SetNewPinPage extends StatefulWidget {
  static String path = '/set_new_pin';

  const SetNewPinPage({super.key});

  @override
  State<SetNewPinPage> createState() => _SetNewPinPageState();
}

class _SetNewPinPageState extends State<SetNewPinPage> {
  String? _errorMessage;

  void _onNewPinEntered(String newPin) {
    if (newPin.length == 4) {
      // context.go(VerifyNewPinPage.path, extra: newPin);
      context.push(VerifyNewPinPage.path, extra: newPin);
    } else {
      setState(() {
        _errorMessage = context.tr('pinMustBe4Digits');
      });
    }
  }

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
              context.tr('enterNewPin'),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.colorText,
              ),
            ),

            // PIN input
            Pinput(autofocus: true, length: 4, obscureText: true, onCompleted: _onNewPinEntered),

            // Error message
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
          ],
        ),
      ),
    );
  }
}
