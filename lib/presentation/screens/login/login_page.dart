// Login page with modern UI design
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/exceptions/auth_exceptions.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/social_login_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter email and password';
          _isLoading = false;
        });
        return;
      }

      await ref
          .read(authProvider.notifier)
          .loginWithEmail(
            email: email,
            password: password,
            rememberMe: _rememberMe,
          );

      if (mounted) {
        context.go('/home');
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .loginWithGoogle(rememberMe: _rememberMe);

      if (mounted) {
        context.go('/home');
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Google sign in failed. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _handlePhoneLogin() async {
    // Show phone input dialog
    final phoneNumber = await _showPhoneInputDialog();
    if (phoneNumber == null || phoneNumber.isEmpty) return;

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      // Format phone number
      // Remove all non-digits and leading 0 if present
      final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
      final cleanedNumber = digitsOnly.startsWith('0')
          ? digitsOnly.substring(1)
          : digitsOnly;
      final formattedPhone = '+66$cleanedNumber';

      final completer = Completer<String?>();

      await ref
          .read(authProvider.notifier)
          .loginWithPhoneNumber(
            phoneNumber: formattedPhone,
            rememberMe: _rememberMe,
            codeSent: (vid) {
              if (!completer.isCompleted) {
                completer.complete(vid);
              }
            },
            verificationFailed: (error) {
              setState(() {
                _errorMessage = error;
                _isLoading = false;
              });
              if (!completer.isCompleted) {
                completer.completeError(error);
              }
            },
          );

      // Wait for verification ID
      try {
        final vid = await completer.future.timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw Exception('Timeout waiting for verification code');
          },
        );

        if (vid != null && mounted) {
          setState(() {
            _isLoading = false;
          });

          // Show SMS code input dialog
          final smsCode = await _showSmsCodeDialog();
          if (smsCode != null && smsCode.isNotEmpty && mounted) {
            setState(() {
              _isLoading = true;
            });

            await ref
                .read(authProvider.notifier)
                .verifyPhoneNumber(verificationId: vid, smsCode: smsCode);

            if (mounted) {
              context.go('/home');
            }
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to send verification code. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Phone authentication failed. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<String?> _showPhoneInputDialog() async {
    final phoneController = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Enter Phone Number',
                style: AppTextStyles.h2.copyWith(color: AppColors.textBlack),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'We\'ll send you a verification code',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 24),
              // Phone input field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: AppColors.inputBorder),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.inputShadow,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Country code prefix
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1,
                            color: AppColors.inputBorder,
                          ),
                        ),
                      ),
                      child: Text(
                        '+66',
                        style: AppTextStyles.inputText.copyWith(
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),
                    // Phone number input
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: AppTextStyles.inputText.copyWith(
                          color: AppColors.textBlack,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter phone number',
                          hintStyle: AppTextStyles.inputText.copyWith(
                            color: AppColors.textGrey,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Helper text
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  'Example: 812345678 or 0812345678',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final phoneNumber = phoneController.text.trim();
                      if (phoneNumber.isNotEmpty) {
                        Navigator.pop(context, phoneNumber);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.loginPrimaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue',
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showSmsCodeDialog() async {
    final codeController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Verification Code'),
        content: TextField(
          controller: codeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(hintText: '6-digit code'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, codeController.text),
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email address';
      });
      return;
    }

    try {
      await ref.read(authProvider.notifier).sendPasswordResetEmail(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Password reset email sent. Please check your inbox.',
            ),
          ),
        );
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = screenWidth > 375 ? 375.0 : screenWidth;
    final horizontalPadding = screenWidth > 375
        ? (screenWidth - 375) / 2
        : 24.0;

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 24),
                    _buildContent(),
                    _buildFooter(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // Logo
        Center(
          child: Image.asset(
            'assets/images/liberator_logo.png',
            height: 120,
            width: 240,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Fallback if image not found
              return const SizedBox.shrink();
            },
          ),
        ),
        const SizedBox(height: 30),
        // Title and Subtitle
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign in to your Account',
              style: AppTextStyles.loginTitle.copyWith(
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Enter your email and password to log in',
              style: AppTextStyles.loginSubtitle.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // Form Fields
        Column(
          children: [
            // Email Field
            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Password Field
            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                  color: AppColors.textGrey,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            // Remember Me and Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: AppColors.textGrey,
                      checkColor: Colors.white,
                      fillColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.textGrey;
                        }
                        return Colors.transparent;
                      }),
                      side: BorderSide(color: AppColors.textGrey, width: 1.5),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text(
                      'Remember me',
                      style: AppTextStyles.loginSubtitle.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _handleForgotPassword,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot Password ?',
                    style: AppTextStyles.linkText.copyWith(
                      color: AppColors.loginPrimaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Error Message
        if (_errorMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.negative.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.negative),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.negative,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.negative,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
        // Log In Button
        GradientButton(
          text: 'Log In',
          onPressed: _isLoading ? null : _handleEmailLogin,
          isLoading: _isLoading,
        ),
        const SizedBox(height: 16),
        // Or Separator
        Row(
          children: [
            Expanded(child: Container(height: 1, color: AppColors.dividerGrey)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or',
                style: AppTextStyles.loginSubtitle.copyWith(
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(child: Container(height: 1, color: AppColors.dividerGrey)),
          ],
        ),
        const SizedBox(height: 16),
        // Social Login Buttons
        Column(
          children: [
            SocialLoginButton(
              type: SocialLoginType.google,
              onPressed: _isLoading ? null : _handleGoogleLogin,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 8),
            SocialLoginButton(
              type: SocialLoginType.phone,
              onPressed: _isLoading ? null : _handlePhoneLogin,
              isLoading: _isLoading,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?',
            style: AppTextStyles.loginSubtitle.copyWith(
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () {
              context.go('/signup');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                'Sign Up',
                style: AppTextStyles.linkText.copyWith(
                  color: AppColors.loginPrimaryBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
