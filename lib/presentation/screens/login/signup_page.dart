// Signup page with modern UI design
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:country_flags/country_flags.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/exceptions/auth_exceptions.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/gradient_button.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dateController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  bool _isLoading = false;
  String _selectedCountryCode = '+66';
  String _selectedCountryIso = 'TH'; // ISO 3166-1 alpha-2 country code

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _showCountryCodePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Country',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildCountryOption('TH', '+66', 'Thailand'),
                  _buildCountryOption('US', '+1', 'United States'),
                  _buildCountryOption('GB', '+44', 'United Kingdom'),
                  _buildCountryOption('JE', '+44', 'Jersey'),
                  _buildCountryOption('SG', '+65', 'Singapore'),
                  _buildCountryOption('MY', '+60', 'Malaysia'),
                  _buildCountryOption('ID', '+62', 'Indonesia'),
                  _buildCountryOption('PH', '+63', 'Philippines'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryOption(String isoCode, String code, String name) {
    final isSelected = _selectedCountryIso == isoCode;
    return ListTile(
      leading: CountryFlag.fromCountryCode(isoCode, height: 24, width: 32),
      title: Text(name),
      trailing: Text(code, style: const TextStyle(fontWeight: FontWeight.w500)),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        if (mounted) {
          setState(() {
            _selectedCountryCode = code;
            _selectedCountryIso = isoCode;
          });
        }
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.loginPrimaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Future<void> _handleSignup() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter email and password';
          _isLoading = false;
        });
        return;
      }

      if (password != confirmPassword) {
        setState(() {
          _errorMessage = 'Passwords do not match';
          _isLoading = false;
        });
        return;
      }

      if (firstName.isEmpty || lastName.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter your first and last name';
          _isLoading = false;
        });
        return;
      }

      final displayName = '$firstName $lastName';

      await ref
          .read(authProvider.notifier)
          .signUpWithEmail(
            email: email,
            password: password,
            displayName: displayName,
            rememberMe: false,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildHeader(),
                    const SizedBox(height: 32),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => context.go('/login'),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(height: 12),
        Text(
          'Register',
          style: AppTextStyles.loginTitle.copyWith(color: AppColors.textBlack),
        ),
        const SizedBox(height: 12),
        Text(
          'Create an account to continue!',
          style: AppTextStyles.loginSubtitle.copyWith(
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Form Fields
        Column(
          children: [
            // First Name
            CustomTextField(
              controller: _firstNameController,
              hintText: 'First Name',
            ),
            const SizedBox(height: 16),
            // Last Name
            CustomTextField(
              controller: _lastNameController,
              hintText: 'Last Name',
            ),
            const SizedBox(height: 16),
            // Email
            CustomTextField(
              controller: _emailController,
              hintText: 'Email Address',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Date of Birth
            CustomTextField(
              controller: _dateController,
              hintText: 'Date of Birth',
              readOnly: true,
              onTap: _selectDate,
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppColors.textGrey,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: _selectDate,
              ),
            ),
            const SizedBox(height: 16),
            // Phone Number
            Container(
              width: double.infinity,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Flag icon and dropdown section
                  InkWell(
                    onTap: _showCountryCodePicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1,
                            color: AppColors.inputBorder,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Flag icon
                          CountryFlag.fromCountryCode(
                            _selectedCountryIso,
                            height: 20,
                            width: 30,
                          ),
                          const SizedBox(width: 8),
                          // Country code text
                          Text(
                            _selectedCountryCode,
                            style: AppTextStyles.inputText.copyWith(
                              color: AppColors.textBlack,
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Dropdown chevron
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: AppColors.textGrey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Phone number input
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: AppTextStyles.inputText.copyWith(
                        color: AppColors.textBlack,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: AppTextStyles.inputText.copyWith(
                          color: AppColors.textGrey,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Password
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
            // Confirm Password
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 20,
                  color: AppColors.textGrey,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
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
        // Register Button
        GradientButton(
          text: 'Register',
          onPressed: _isLoading ? null : _handleSignup,
          isLoading: _isLoading,
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
            'Already have an account?',
            style: AppTextStyles.loginSubtitle.copyWith(
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () {
              context.go('/login');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                'Log in',
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
