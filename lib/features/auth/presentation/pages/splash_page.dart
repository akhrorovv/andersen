import 'package:andersen/core/api/interceptors.dart';
import 'package:andersen/core/common/profile/cubit/profile_cubit.dart';
import 'package:andersen/core/common/profile/cubit/profile_state.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/auth/presentation/pages/checking_page.dart';
import 'package:andersen/features/auth/presentation/pages/enter_pin_page.dart';
import 'package:andersen/features/auth/presentation/pages/login_page.dart';
import 'package:andersen/features/auth/presentation/pages/set_pin_page.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  static String path = '/';

  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoggerInterceptor.logger.i(
      "Device ID: ${DBService.deviceId}\n"
      "Access Token: ${DBService.accessToken}\n"
      "Refresh Token: ${DBService.refreshToken}",
    );
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) async {
          if (state is ProfileLoadedSuccess) {
            if(DBService.pin.isEmpty){
              context.go(SetPinPage.path);
            } else {
              context.go(EnterPinPage.path, extra: false);
            }
          } else if (state is ProfileLoadedError) {
            // BasicSnackBar.show(context, message: state.message, error: true);
            if (state.message == "Device is blocked") {
              context.go(CheckingPage.path);
            } else if (state.message == 'Unauthorized') {
              await DBService.clear();
              if (context.mounted) {
                context.go(LoginPage.path);
              }
            }
            // context.go(CheckingPage.path);
          }
        },
        child: Center(
          child: Container(
            color: AppColors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 80.w),
              child: Assets.images.splash.image(),
            ),
          ),
        ),
      ),
    );
  }
}
