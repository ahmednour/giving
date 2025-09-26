import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:giving_bridge/l10n/app_localizations.dart';
import 'package:giving_bridge/services/auth_service.dart';
import 'package:giving_bridge/models/user.dart';
import 'package:giving_bridge/ui/widgets/custom_text_field.dart';
import 'package:giving_bridge/ui/widgets/primary_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RevampedLoginScreen extends StatefulWidget {
  const RevampedLoginScreen({super.key});

  @override
  State<RevampedLoginScreen> createState() => _RevampedLoginScreenState();
}

class _RevampedLoginScreenState extends State<RevampedLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = context.read<AuthService>();
    final success = await authService.login(
      LoginRequest(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content:
                  Text(authService.error ?? 'Login failed. Please try again.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context, l10n)
                        .animate()
                        .fade(duration: 500.ms)
                        .slideY(begin: -0.5),
                    const SizedBox(height: 48),
                    _buildFormFields(l10n),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      onPressed: _login,
                      text: l10n.login,
                      isLoading: _isLoading,
                    )
                        .animate()
                        .fade(delay: 400.ms, duration: 500.ms)
                        .slideY(begin: 0.5),
                    const SizedBox(height: 24),
                    _buildFooter(context, l10n)
                        .animate()
                        .fade(delay: 500.ms, duration: 500.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Icon(
          Icons.favorite_border,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'مرحباً بعودتك',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'سجل الدخول للمتابعة في جسر العطاء',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields(AppLocalizations l10n) {
    return Column(
      children: [
        CustomTextField(
          controller: _emailController,
          labelText: l10n.email,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ]),
        ).animate().fade(delay: 200.ms, duration: 500.ms).slideY(begin: 0.5),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          labelText: l10n.password,
          obscureText: true,
          prefixIcon: const Icon(Icons.lock_outline),
          validator: FormBuilderValidators.required(),
        ).animate().fade(delay: 300.ms, duration: 500.ms).slideY(begin: 0.5),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.dontHaveAnAccount),
        TextButton(
          onPressed: () => context.go('/register'),
          child: Text(l10n.register),
        ),
      ],
    );
  }
}
