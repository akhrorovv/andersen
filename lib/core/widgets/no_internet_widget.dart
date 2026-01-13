import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_button.dart';
import 'package:andersen/core/widgets/gradient_button.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final bool isRetrying;

  const NoInternetWidget({
    super.key,
    required this.onRetry,
    this.isRetrying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Assets.vectors.noInternet.svg(width: 120.w, height: 120.w),
              SizedBox(height: 24.h),
              Text(
                context.tr('noInternetConnection'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorText,
                ),
              ),
              const Spacer(),
              BasicButton(
                title: context.tr('refreshPage'),
                onTap: onRetry,
                isLoading: isRetrying,
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
