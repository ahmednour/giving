import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../utils/responsive.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../buttons/custom_button.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String? title;
  final List<Widget>? actions;
  final bool transparent;

  const Navbar({
    super.key,
    this.showBackButton = false,
    this.title,
    this.actions,
    this.transparent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Container(
      decoration: BoxDecoration(
        color: transparent
            ? Colors.transparent
            : (isDarkMode ? AppColors.darkSurface : AppColors.surface),
        border: !transparent
            ? Border(
                bottom: BorderSide(
                  color: isDarkMode ? AppColors.darkBorder : AppColors.border,
                  width: 1,
                ),
              )
            : null,
        boxShadow: !transparent
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                ),
              ]
            : null,
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
        automaticallyImplyLeading: showBackButton,
        title: title != null
            ? Text(
                title!,
                style: AppTypography.titleLarge.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              )
            : _buildLogo(isDarkMode),
        centerTitle: false,
        actions: [
          ...?actions,
          if (Responsive.isDesktop(context)) ...[
            if (!authProvider.isAuthenticated) ...[
              TextButton(
                onPressed: () => context.pushNamed('login'),
                child: Text(
                  'Sign In',
                  style: AppTypography.labelLarge.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomButton(
                text: 'Get Started',
                onPressed: () => context.pushNamed('register'),
                size: ButtonSize.medium,
              ),
            ] else ...[
              _buildThemeToggle(themeProvider),
              const SizedBox(width: 8),
              _buildUserMenu(context, authProvider, isDarkMode),
            ],
          ] else ...[
            if (authProvider.isAuthenticated) ...[
              _buildThemeToggle(themeProvider),
              const SizedBox(width: 8),
              _buildUserMenu(context, authProvider, isDarkMode),
            ] else ...[
              _buildThemeToggle(themeProvider),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.login),
                onPressed: () => context.pushNamed('login'),
                tooltip: 'Sign In',
              ),
            ],
          ],
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isDarkMode) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          'Giving Bridge',
          style: AppTypography.titleLarge.copyWith(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color:
                isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggle(ThemeProvider themeProvider) {
    return IconButton(
      icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
      onPressed: themeProvider.toggleTheme,
      tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
    );
  }

  Widget _buildUserMenu(
    BuildContext context,
    AuthProvider authProvider,
    bool isDarkMode,
  ) {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDarkMode ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Text(
                authProvider.user?.initials ?? 'U',
                style: AppTypography.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (Responsive.isDesktop(context)) ...[
              const SizedBox(width: 8),
              Text(
                authProvider.user?.firstName ?? 'User',
                style: AppTypography.labelLarge.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
      onSelected: (value) async {
        switch (value) {
          case 'dashboard':
            context.pushNamed('dashboard');
            break;
          case 'settings':
            context.pushNamed('settings');
            break;
          case 'logout':
            await authProvider.logout();
            if (context.mounted) {
              context.goNamed('landing');
            }
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'dashboard',
          child: Row(
            children: [
              const Icon(Icons.dashboard, size: 20),
              const SizedBox(width: 12),
              Text('Dashboard', style: AppTypography.bodyMedium),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              const Icon(Icons.settings, size: 20),
              const SizedBox(width: 12),
              Text('Settings', style: AppTypography.bodyMedium),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout, size: 20),
              const SizedBox(width: 12),
              Text('Sign Out', style: AppTypography.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}

// Fixed version of Navbar with proper preferredSize implementation
class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String? title;
  final List<Widget>? actions;
  final bool transparent;

  const AppNavbar({
    super.key,
    this.showBackButton = false,
    this.title,
    this.actions,
    this.transparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Navbar(
      showBackButton: showBackButton,
      title: title,
      actions: actions,
      transparent: transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72.0);
}
