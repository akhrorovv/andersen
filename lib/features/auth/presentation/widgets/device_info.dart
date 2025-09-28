import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/core/widgets/basic_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildDeviceInfo(BuildContext context) {
  return Column(
    spacing: 8.h,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 📱 Model
      Row(
        spacing: 6.w,
        children: [
          Icon(Icons.phone_android, size: 20.sp, color: AppColors.grey),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14.sp),
                children: [
                  const TextSpan(
                    text: "Model: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: DBService.deviceModel ?? "Unknown"),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🧩 Version
      Row(
        spacing: 6.w,
        children: [
          Icon(Icons.system_update, size: 20.sp, color: AppColors.grey),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14.sp),
                children: [
                  const TextSpan(
                    text: "OS Version: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: DBService.deviceVersion ?? "Unknown"),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🆔 Device ID (copy)
      InkWell(
        onTap: () async {
          final id = DBService.deviceId ?? "";
          if (id.isNotEmpty) {
            await Clipboard.setData(ClipboardData(text: id));
            BasicSnackBar.show(context, message: "Device ID copied!");
          }
        },
        child: Row(
          spacing: 6.w,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.copy, size: 20.sp, color: AppColors.grey),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14.sp),
                  children: [
                    TextSpan(
                      text: "Device ID: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: DBService.deviceId ?? "Unknown"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
