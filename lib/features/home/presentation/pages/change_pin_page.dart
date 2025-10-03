import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/features/home/presentation/pages/set_new_pin_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class ChangePinPage extends StatefulWidget {
  static String path = '/change_pin';

  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  String? _errorMessage;

  void _checkOldPin(String enteredPin) {
    if (enteredPin == DBService.pin) {
      // context.go(SetNewPinPage.path);
      // context.pushCupertinoSheet(SetNewPinPage());
      context.push(SetNewPinPage.path);

    } else {
      setState(() {
        _errorMessage = context.tr('incorrectPin');
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
              context.tr('enterOldPin'),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.colorText,
              ),
            ),

            // PIN input
            Pinput(
              autofocus: true,
              length: 4,
              obscureText: true,
              onCompleted: _checkOldPin,
            ),

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

