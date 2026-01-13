import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}
