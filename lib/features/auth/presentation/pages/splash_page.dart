import 'package:andersen/core/api/interceptors.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/auth/presentation/pages/login_page.dart';
import 'package:andersen/features/home/presentation/pages/home_page.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  static String path = '/';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    LoggerInterceptor.logger.i(
      "Device ID: ${DBService.deviceId}\n"
      "Access Token: ${DBService.accessToken}",
    );
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final token = DBService.accessToken;

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      context.go(HomePage.path);
    } else {
      context.go(LoginPage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 80.w),
        child: Assets.images.splash.image(),
      ),
    );
  }
}
