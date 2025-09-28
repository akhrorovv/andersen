import 'package:andersen/core/common/profile/cubit/profile_cubit.dart';
import 'package:andersen/core/common/profile/cubit/profile_state.dart';
import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/basic_divider.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:andersen/features/auth/presentation/pages/login_page.dart';
import 'package:andersen/features/auth/presentation/widgets/device_info.dart';
import 'package:andersen/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CheckingPage extends StatelessWidget {
  static String path = '/checking';

  const CheckingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoadedSuccess) {
            context.go(HomePage.path);
          } else if (state is ProfileLoadedError) {
            BasicSnackBar.show(context, message: state.message, error: true);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Check your device status",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.colorText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                BasicButton(
                  title: 'Check',
                  isLoading: state is ProfileLoading,
                  onTap: () async {
                    context.read<ProfileCubit>().getProfile();
                  },
                ),
                BasicDivider(),

                buildDeviceInfo(context),

                // login button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: ElevatedButton(
                        onPressed: () {
                          DBService.clear();
                          context.go(LoginPage.path);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                        ),
                        child: Text("Login", style: TextStyle(color: AppColors.colorTextWhite)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
