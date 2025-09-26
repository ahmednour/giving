import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/l10n/app_localizations.dart';
import 'package:giving_bridge/services/auth_service.dart';
import 'package:giving_bridge/models/user.dart';
import '../../widgets/web_navbar.dart';
import '../../widgets/web_button.dart';
import '../../widgets/web_card.dart';
import '../../widgets/web_container.dart';
import '../../widgets/web_input.dart';
import '../../theme/web_colors.dart';
import '../../theme/web_typography.dart';

class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({super.key});

  @override
  State<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends State<WebLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = context.read<AuthService>();
    final success = await authService.login(
      LoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );

    if (mounted) {
      setState(() => _isLoading = false);

      if (success) {
        context.go('/home');
      } else {
        setState(() {
          _errorMessage =
              authService.error ?? 'فشل في تسجيل الدخول. حاول مرة أخرى.';
        });
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: WebNavbar(
        title: 'Giving Bridge',
        actions: [
          WebButton(
            text: 'العودة للرئيسية',
            variant: WebButtonVariant.ghost,
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: WebContainer.narrow(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(theme, isDark),
                const SizedBox(height: 40),
                _buildLoginForm(theme, isDark),
                const SizedBox(height: 24),
                _buildFooter(theme, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isDark ? WebColors.darkPrimary : WebColors.lightPrimary,
                isDark
                    ? WebColors.darkPrimary.withOpacity(0.8)
                    : WebColors.lightPrimary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (isDark ? WebColors.darkPrimary : WebColors.lightPrimary)
                    .withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.favorite,
            color: isDark
                ? WebColors.darkPrimaryForeground
                : WebColors.lightPrimaryForeground,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'مرحباً بعودتك',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color:
                isDark ? WebColors.darkForeground : WebColors.lightForeground,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'سجل دخولك للمتابعة في جسر العطاء',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isDark
                ? WebColors.darkMutedForeground
                : WebColors.lightMutedForeground,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(ThemeData theme, bool isDark) {
    return WebCard(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (isDark
                          ? WebColors.darkDestructive
                          : WebColors.lightDestructive)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDark
                        ? WebColors.darkDestructive
                        : WebColors.lightDestructive,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: isDark
                          ? WebColors.darkDestructive
                          : WebColors.lightDestructive,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? WebColors.darkDestructive
                              : WebColors.lightDestructive,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            WebInput(
              label: 'البريد الإلكتروني',
              placeholder: 'أدخل بريدك الإلكتروني',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: _validateEmail,
              isRequired: true,
            ),
            const SizedBox(height: 20),
            WebInput(
              label: 'كلمة المرور',
              placeholder: 'أدخل كلمة المرور',
              controller: _passwordController,
              isPassword: true,
              prefixIcon: Icons.lock_outline,
              validator: _validatePassword,
              isRequired: true,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement forgot password
                },
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        isDark ? WebColors.darkPrimary : WebColors.lightPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            WebButton(
              text: _isLoading ? 'جاري تسجيل الدخول...' : 'تسجيل الدخول',
              variant: WebButtonVariant.primary,
              size: WebButtonSize.large,
              isFullWidth: true,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _login,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme, bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Divider(
                    color:
                        isDark ? WebColors.darkBorder : WebColors.lightBorder)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'أو',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? WebColors.darkMutedForeground
                      : WebColors.lightMutedForeground,
                ),
              ),
            ),
            Expanded(
                child: Divider(
                    color:
                        isDark ? WebColors.darkBorder : WebColors.lightBorder)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ليس لديك حساب؟ ',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? WebColors.darkMutedForeground
                    : WebColors.lightMutedForeground,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/register'),
              child: Text(
                'إنشاء حساب جديد',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      isDark ? WebColors.darkPrimary : WebColors.lightPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'حسابات تجريبية: ',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? WebColors.darkMutedForeground
                    : WebColors.lightMutedForeground,
              ),
            ),
            TextButton(
              onPressed: () {
                _emailController.text = 'john@example.com';
                _passwordController.text = 'admin123';
              },
              child: Text(
                'متبرع',
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      isDark ? WebColors.darkPrimary : WebColors.lightPrimary,
                ),
              ),
            ),
            Text(' | ',
                style: TextStyle(
                  color: isDark
                      ? WebColors.darkMutedForeground
                      : WebColors.lightMutedForeground,
                )),
            TextButton(
              onPressed: () {
                _emailController.text = 'jane@example.com';
                _passwordController.text = 'admin123';
              },
              child: Text(
                'محتاج',
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      isDark ? WebColors.darkPrimary : WebColors.lightPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
