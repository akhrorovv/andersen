import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendeeButton extends StatefulWidget {
  final String title;
  final Color background;
  final Color textColor;
  final Future<void> Function() onTap;

  const AttendeeButton({
    super.key,
    required this.title,
    required this.background,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<AttendeeButton> createState() => _AttendeeButtonState();
}

class _AttendeeButtonState extends State<AttendeeButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_loading) return;
        setState(() => _loading = true);

        await widget.onTap();

        if (mounted) setState(() => _loading = false);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: widget.background,
        ),
        child: Center(
          child: _loading
              ? SizedBox(
            height: 18.w,
            width: 18.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Text(
            widget.title,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 1.25.h,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}

