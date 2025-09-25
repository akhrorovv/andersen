import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    bool error = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          spacing: 6.w,
          children: [
            Icon(Icons.error, color: error ? AppColors.red : AppColors.colorTextWhite),
            Text(
              message,
              style: TextStyle(color: error ? AppColors.red : AppColors.colorTextWhite),
            ),
          ],
        ),
        backgroundColor: error ? AppColors.white : AppColors.primary,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
