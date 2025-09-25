import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TasksAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController controller;
  final VoidCallback onSearchTap;
  final VoidCallback onClearTap;
  final ValueChanged<String> onSubmitted;

  const TasksAppBar({
    required this.isSearching,
    required this.controller,
    required this.onSearchTap,
    required this.onClearTap,
    required this.onSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: isSearching
          ? TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "${context.tr('searchTasks')}...",
                hintStyle: TextStyle(color: AppColors.grey),
                border: InputBorder.none,
              ),
              style: TextStyle(color: AppColors.white),
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
            )
          : Text(context.tr('tasks')),
      actions: [
        isSearching
            ? GestureDetector(
                onTap: onClearTap,
                child: Padding(
                  padding: EdgeInsets.only(right: 14.w),
                  child: Icon(Icons.clear, color: AppColors.white),
                ),
              )
            : GestureDetector(
                onTap: onSearchTap,
                child: Padding(
                  padding: EdgeInsets.only(right: 14.w),
                  child: Assets.vectors.search.svg(),
                ),
              ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
