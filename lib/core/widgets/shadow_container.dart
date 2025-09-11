import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  // final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;

  const ShadowContainer({
    super.key,
    required this.child,
    this.padding,
    // this.margin,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: margin ?? const EdgeInsets.all(8),
      padding: padding ?? EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }
}
