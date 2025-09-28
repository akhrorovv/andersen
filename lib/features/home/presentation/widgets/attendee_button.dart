import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendeeButton extends StatefulWidget {
  final String title;
  final Color background;
  final Color textColor;
  final Future<void> Function()? onTap;
  final bool isLoading;

  const AttendeeButton({
    super.key,
    required this.title,
    required this.background,
    required this.textColor,
    this.onTap,
    this.isLoading = false,
  });

  /// 🔹 Factory for "Has Come"
  factory AttendeeButton.hasCome({Future<void> Function()? onTap, bool isLoading = false}) {
    return AttendeeButton(
      title: "Has Come",
      background: AppColors.green,
      textColor: AppColors.greenText,
      onTap: onTap,
      isLoading: isLoading,
    );
  }

  /// 🔹 Factory for "Has Left"
  factory AttendeeButton.hasLeft({Future<void> Function()? onTap, bool isLoading = false}) {
    return AttendeeButton(
      title: "Has Left",
      background: AppColors.volcano,
      textColor: AppColors.volcanoText,
      onTap: onTap,
      isLoading: isLoading,
    );
  }

  @override
  State<AttendeeButton> createState() => _AttendeeButtonState();
}

class _AttendeeButtonState extends State<AttendeeButton> {
  bool _localLoading = false;

  Future<void> _handleTap() async {
    if (_localLoading || widget.onTap == null) return;

    setState(() => _localLoading = true);
    try {
      await widget.onTap!();
    } finally {
      if (mounted) setState(() => _localLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = _localLoading || widget.isLoading;

    return GestureDetector(
      onTap: loading ? null : _handleTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: widget.background,
        ),
        child: Center(
          child: loading
              ? SizedBox(
                  height: 18.w,
                  width: 18.w,
                  child: CircularProgressIndicator(strokeWidth: 2, color: widget.textColor),
                )
              : Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.25.h,
                  ),
                ),
        ),
      ),
    );
  }
}
