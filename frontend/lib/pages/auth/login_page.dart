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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        loadingMessage: 'Signing you in...',
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
                    _buildEmailField(),
                    SizedBox(height: Responsive.formFieldSpacing(context)),
                    _buildPasswordField(),
                    const SizedBox(height: 16),
                    _buildRememberMeAndForgotPassword(isDarkMode),
                    const SizedBox(height: 24),
                    _buildLoginButton(),
                    const SizedBox(height: 24),
                    _buildDivider(isDarkMode),
                    const SizedBox(height: 24),
                    _buildSocialLogin(),
                    const SizedBox(height: 32),
                    _buildSignUpPrompt(isDarkMode),
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
          'Welcome Back',
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
          'Sign in to your account to continue giving',
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
      hint: 'Enter your password',
      controller: _passwordController,
      obscureText: true,
      textInputAction: TextInputAction.done,
      prefixIcon: const Icon(Icons.lock_outlined),
      onSubmitted: (_) => _handleLogin(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildRememberMeAndForgotPassword(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Remember me',
              style: AppTypography.bodyMedium.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: _handleForgotPassword,
          child: Text(
            'Forgot password?',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return CustomButton(
      text: 'Sign In',
      onPressed: _handleLogin,
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
          onPressed: _handleGoogleLogin,
          variant: ButtonVariant.outline,
          size: ButtonSize.large,
          isFullWidth: true,
          icon: const Icon(Icons.g_mobiledata, size: 24),
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Continue with Apple',
          onPressed: _handleAppleLogin,
          variant: ButtonVariant.outline,
          size: ButtonSize.large,
          isFullWidth: true,
          icon: const Icon(Icons.apple, size: 20),
        ),
      ],
    );
  }

  Widget _buildSignUpPrompt(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTypography.bodyMedium.copyWith(
            color: isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => context.pushReplacementNamed('register'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign up',
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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        context.goNamed('dashboard');
      } else if (mounted) {
        _showErrorMessage(authProvider.errorMessage ?? 'Login failed');
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

  void _handleForgotPassword() {
    // TODO: Implement forgot password functionality
    _showInfoMessage('Forgot password functionality will be implemented soon');
  }

  Future<void> _handleGoogleLogin() async {
    // TODO: Implement Google login
    _showInfoMessage('Google login will be implemented soon');
  }

  Future<void> _handleAppleLogin() async {
    // TODO: Implement Apple login
    _showInfoMessage('Apple login will be implemented soon');
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
