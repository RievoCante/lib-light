// Profile avatar widget
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;

  const ProfileAvatar({super.key, this.onTap, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryBlue, width: 2),
          color: Theme.of(context).cardColor,
        ),
        child: ClipOval(
          child: Icon(
            Icons.person,
            color: AppColors.primaryBlue,
            size: size * 0.6,
          ),
        ),
      ),
    );
  }
}
