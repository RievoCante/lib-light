// Profile avatar widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class ProfileAvatar extends ConsumerWidget {
  final VoidCallback? onTap;
  final double size;

  const ProfileAvatar({super.key, this.onTap, this.size = 40});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;
    final photoUrl = user?.photoUrl;

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
          child: photoUrl != null && photoUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: photoUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Theme.of(context).cardColor,
                    child: Icon(
                      Icons.person,
                      color: AppColors.primaryBlue,
                      size: size * 0.6,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.person,
                    color: AppColors.primaryBlue,
                    size: size * 0.6,
                  ),
                )
              : Icon(
                  Icons.person,
                  color: AppColors.primaryBlue,
                  size: size * 0.6,
                ),
        ),
      ),
    );
  }
}
