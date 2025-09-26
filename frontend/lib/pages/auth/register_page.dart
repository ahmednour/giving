import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../utils/responsive.dart';
import '../../components/navigation/navbar.dart';
import '../../components/buttons/custom_button.dart';
import '../../components/forms/custom_text_field.dart';
import '../../components/common/loading_widget.dart';
import '../../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;
  bool _subscribeToNewsletter = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const AppNavbar(showBackButton: true),
      body: LoadingOverlay(
        isLoading: _isLoading,
        loadingMessage: 'Creating your account...',
        child: Center(
          child: SingleChildScrollView(
            padding: Responsive.responsivePadding(context),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(isDarkMode),
                    const SizedBox(height: 32),
                    _buildNameFields(),
                    SizedBox(height: Responsive.formFieldSpacing(context)),
                    _buildEmailField(),
                    SizedBox(height: Responsive.formFieldSpacing(context)),
                    _buildPasswordField(),
                    SizedBox(height: Responsive.formFieldSpacing(context)),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 16),
                    _buildCheckboxes(isDarkMode),
                    const SizedBox(height: 24),
                    _buildRegisterButton(),
                    const SizedBox(height: 24),
                    _buildDivider(isDarkMode),
                    const SizedBox(height: 24),
                    _buildSocialLogin(),
                    const SizedBox(height: 32),
                    _buildSignInPrompt(isDarkMode),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 24),
        Text(
          'Join Giving Bridge',
          style:
              Responsive.responsiveValue(
                context,
                mobile: AppTypography.headlineMedium,
                desktop: AppTypography.headlineLarge,
              ).copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Create your account to start making a difference',
          style: AppTypography.bodyLarge.copyWith(
            color: isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: 'First Name',
            hint: 'Enter your first name',
            controller: _firstNameController,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.person_outlined),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your first name';
              }
              if (value.trim().length < 2) {
                return 'First name must be at least 2 characters';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomTextField(
            label: 'Last Name',
            hint: 'Enter your last name',
            controller: _lastNameController,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.person_outlined),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your last name';
              }
              if (value.trim().length < 2) {
                return 'Last name must be at least 2 characters';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      label: 'Email Address',
      hint: 'Enter your email',
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.email_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      label: 'Password',
      hint: 'Create a strong password',
      controller: _passwordController,
      obscureText: true,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.lock_outlined),
      helperText:
          'Password must be at least 8 characters with uppercase, lowercase, and number',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
          return 'Password must contain uppercase, lowercase, and number';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
      label: 'Confirm Password',
      hint: 'Confirm your password',
      controller: _confirmPasswordController,
      obscureText: true,
      textInputAction: TextInputAction.done,
      prefixIcon: const Icon(Icons.lock_outlined),
      onSubmitted: (_) => _handleRegister(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildCheckboxes(bool isDarkMode) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Wrap(
                children: [
                  Text(
                    'I agree to the ',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showTermsOfService,
                    child: Text(
                      'Terms of Service',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(
                    ' and ',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showPrivacyPolicy,
                    child: Text(
                      'Privacy Policy',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _subscribeToNewsletter,
                onChanged: (value) {
                  setState(() {
                    _subscribeToNewsletter = value ?? false;
                  });
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Subscribe to our newsletter for updates and giving opportunities',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return CustomButton(
      text: 'Create Account',
      onPressed: _agreeToTerms ? _handleRegister : null,
      size: ButtonSize.large,
      isFullWidth: true,
      isLoading: _isLoading,
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDarkMode ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: AppTypography.bodyMedium.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDarkMode ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        CustomButton(
          text: 'Continue with Google',
          onPressed: _handleGoogleRegister,
          variant: ButtonVariant.outline,
          size: ButtonSize.large,
          isFullWidth: true,
          icon: const Icon(Icons.g_mobiledata, size: 24),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Continue with Apple',
          onPressed: _handleAppleRegister,
          variant: ButtonVariant.outline,
          size: ButtonSize.large,
          isFullWidth: true,
          icon: const Icon(Icons.apple, size: 20),
        ),
      ],
    );
  }

  Widget _buildSignInPrompt(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTypography.bodyMedium.copyWith(
            color: isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => context.pushReplacementNamed('login'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign in',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      _showErrorMessage(
        'Please agree to the Terms of Service and Privacy Policy',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      if (success && mounted) {
        _showSuccessMessage(
          'Account created successfully! Welcome to Giving Bridge.',
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          context.goNamed('dashboard');
        }
      } else if (mounted) {
        _showErrorMessage(authProvider.errorMessage ?? 'Registration failed');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('An unexpected error occurred');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'Terms of Service content will be implemented here. This would typically include the full legal terms and conditions for using the Giving Bridge platform.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Privacy Policy content will be implemented here. This would typically include information about how user data is collected, used, and protected.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGoogleRegister() async {
    // TODO: Implement Google registration
    _showInfoMessage('Google registration will be implemented soon');
  }

  Future<void> _handleAppleRegister() async {
    // TODO: Implement Apple registration
    _showInfoMessage('Apple registration will be implemented soon');
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
