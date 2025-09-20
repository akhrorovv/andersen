import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onClose;

  const BasicAppBar({super.key, this.title, this.onClose});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: title != null ? Text(
        title!,
        style: TextStyle(
          color: AppColors.colorTextWhite,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          height: 1.h,
          letterSpacing: 0,
        ),
      ) : null,
      actions: [
        IconButton(
          onPressed: onClose ?? () => Navigator.of(context).pop(),
          icon: Icon(Icons.clear, size: 24, color: AppColors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
