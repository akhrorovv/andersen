import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/core/widgets/basic_app_bar.dart';
import 'package:andersen/core/widgets/shadow_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: 'Options'),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: Column(
          spacing: 12.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _eventsTypeText(),
            ShadowContainer(child: Column())
          ],
        ),
      ),
    );
  }

  Widget _eventsTypeText(){
    return Text(
      "Events type",
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0,
        color: AppColors.colorText,
      ),
    );
  }
}
