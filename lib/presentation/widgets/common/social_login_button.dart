// Social login button widget
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

// Google Icon Widget - uses Google icon SVG
class GoogleIconWidget extends StatelessWidget {
  final double size;

  const GoogleIconWidget({super.key, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/google-icon-logo-svgrepo-com.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

enum SocialLoginType { google, phone }

class SocialLoginButton extends StatelessWidget {
  final SocialLoginType type;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.type,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final String text = type == SocialLoginType.google
        ? 'Continue with Google'
        : 'Continue with Phone';
    final Widget iconWidget = type == SocialLoginType.google
        ? const GoogleIconWidget(size: 18)
        : const Icon(
            Icons.phone_outlined,
            size: 18,
            color: AppColors.textBlack,
          );

    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: AppColors.socialButtonBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else ...[
                  iconWidget,
                  const SizedBox(width: 10),
                ],
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.socialButtonText.copyWith(
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
