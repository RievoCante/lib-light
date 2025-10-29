// Loading indicator widget
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;

  const LoadingIndicator({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          color: AppColors.primaryBlue,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
