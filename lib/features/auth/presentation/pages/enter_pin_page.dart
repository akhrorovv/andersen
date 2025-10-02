import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/auth/presentation/pages/checking_page.dart';
import 'package:andersen/features/auth/presentation/pages/login_page.dart';
import 'package:andersen/features/auth/presentation/widgets/pin_put_theme.dart';
import 'package:andersen/features/home/presentation/pages/home_page.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';

class EnterPinPage extends StatefulWidget {
  static String path = '/enter_pin';
  final bool fromLogin;

  const EnterPinPage({super.key, required this.fromLogin});

  @override
  State<EnterPinPage> createState() => _EnterPinPageState();
}

class _EnterPinPageState extends State<EnterPinPage> {
  final LocalAuthentication auth = LocalAuthentication();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tryBiometricAuth();
  }

  Future<void> _tryBiometricAuth() async {
    if (!DBService.biometricEnabled) return;

    try {
      final bool canCheck = await auth.canCheckBiometrics;
      final bool isAvailable = await auth.isDeviceSupported();

      if (canCheck && isAvailable) {
        final didAuthenticate = await auth.authenticate(
          localizedReason: 'Unlock with Face ID / Fingerprint',
          options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
        );

        if (didAuthenticate && mounted) {
          context.go(HomePage.path);
        }
      }
    } catch (e) {
      debugPrint("Biometric auth error: $e");
    }
  }

  void _checkPin(String enteredPin) {
    if (enteredPin == DBService.pin) {
      if (widget.fromLogin) {
        context.go(CheckingPage.path);
      } else {
        context.go(HomePage.path);
      }
    } else {
      setState(() {
        _errorMessage = context.tr('incorrectPin');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        actions: [
          TextButton(
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  content: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.red5,
                        radius: 24.r,
                        child: Assets.vectors.logout.svg(width: 24.w),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        context.tr('forgotPinMessage'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorText,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(context.tr('cancel')),
                    ),
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      isDestructiveAction: true,
                      onPressed: () async {
                        await Future.wait([DBService.clear()]);

                        context.go(LoginPage.path);
                      },
                      child: Text(context.tr('logout')),
                    ),
                  ],
                ),
              );
            },
            child: Text(
              context.tr('cannotLogin'),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 24.h,
          children: [
            Text(context.tr('enterPin'), style: TextStyle(fontSize: 18)),

            Pinput(
              length: 4,
              autofocus: true,
              obscureText: true,
              onCompleted: _checkPin,
              defaultPinTheme: (_errorMessage != null) ? errorPinTheme : defaultPinTheme,
            ),

            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
