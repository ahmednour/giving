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

class RevampedRegisterScreen extends StatefulWidget {
  const RevampedRegisterScreen({super.key});

  @override
  State<RevampedRegisterScreen> createState() => _RevampedRegisterScreenState();
}

class _RevampedRegisterScreenState extends State<RevampedRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'DONOR';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = context.read<AuthService>();
    final success = await authService.register(
      RegisterRequest(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole,
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
              content: Text(authService.error ??
                  'Registration failed. Please try again.'),
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
                    const SizedBox(height: 32),
                    _buildFormFields(l10n),
                    const SizedBox(height: 24),
                    _buildRoleSelector(context)
                        .animate()
                        .fade(delay: 400.ms, duration: 500.ms)
                        .slideY(begin: 0.5),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      onPressed: _register,
                      text: l10n.register,
                      isLoading: _isLoading,
                    )
                        .animate()
                        .fade(delay: 500.ms, duration: 500.ms)
                        .slideY(begin: 0.5),
                    const SizedBox(height: 24),
                    _buildFooter(context, l10n)
                        .animate()
                        .fade(delay: 600.ms, duration: 500.ms),
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
          'إنشاء حساب جديد',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'أهلاً بك في جسر العطاء. لنبدأ!',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields(AppLocalizations l10n) {
    return Column(
      children: [
        CustomTextField(
          controller: _nameController,
          labelText: l10n.name,
          prefixIcon: const Icon(Icons.person_outline),
          validator: FormBuilderValidators.required(),
        ).animate().fade(delay: 200.ms, duration: 500.ms).slideY(begin: 0.5),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController,
          labelText: l10n.email,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ]),
        ).animate().fade(delay: 300.ms, duration: 500.ms).slideY(begin: 0.5),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          labelText: l10n.password,
          obscureText: true,
          prefixIcon: const Icon(Icons.lock_outline),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(6),
          ]),
        ).animate().fade(delay: 400.ms, duration: 500.ms).slideY(begin: 0.5),
      ],
    );
  }

  Widget _buildRoleSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أنا أريد أن:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _RoleOption(
                label: 'أتبرع',
                icon: Icons.volunteer_activism_outlined,
                isSelected: _selectedRole == 'DONOR',
                onTap: () => setState(() => _selectedRole = 'DONOR'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _RoleOption(
                label: 'أستقبل',
                icon: Icons.redeem_outlined,
                isSelected: _selectedRole == 'RECEIVER',
                onTap: () => setState(() => _selectedRole = 'RECEIVER'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.alreadyHaveAccount),
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text(l10n.login),
        ),
      ],
    );
  }
}

class _RoleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.1)
              : theme.inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : theme.inputDecorationTheme.enabledBorder!.borderSide.color,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withOpacity(0.7),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
