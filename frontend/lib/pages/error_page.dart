import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/responsive.dart';
import '../components/buttons/custom_button.dart';

class ErrorPage extends StatelessWidget {
  final String error;
  final int? statusCode;
  final String? details;

  const ErrorPage({
    super.key,
    required this.error,
    this.statusCode,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: Responsive.responsivePadding(context),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildErrorIcon(isDarkMode),
                const SizedBox(height: 32),
                _buildErrorCode(),
                const SizedBox(height: 16),
                _buildErrorMessage(isDarkMode),
                if (details != null) ...[
                  const SizedBox(height: 16),
                  _buildErrorDetails(isDarkMode),
                ],
                const SizedBox(height: 40),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon(bool isDarkMode) {
    IconData iconData;
    Color iconColor;

    switch (statusCode) {
      case 404:
        iconData = Icons.search_off;
        iconColor = AppColors.warning;
        break;
      case 403:
        iconData = Icons.lock;
        iconColor = AppColors.error;
        break;
      case 500:
        iconData = Icons.error_outline;
        iconColor = AppColors.error;
        break;
      default:
        iconData = Icons.warning_amber;
        iconColor = AppColors.warning;
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 60, color: iconColor),
    );
  }

  Widget _buildErrorCode() {
    if (statusCode == null) return const SizedBox.shrink();

    String codeText;
    switch (statusCode) {
      case 404:
        codeText = '404';
        break;
      case 403:
        codeText = '403';
        break;
      case 500:
        codeText = '500';
        break;
      default:
        codeText = statusCode.toString();
    }

    return Text(
      codeText,
      style: AppTypography.displayLarge.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorMessage(bool isDarkMode) {
    String title;
    String subtitle;

    switch (statusCode) {
      case 404:
        title = 'Page Not Found';
        subtitle =
            'The page you\'re looking for doesn\'t exist or has been moved.';
        break;
      case 403:
        title = 'Access Denied';
        subtitle = 'You don\'t have permission to access this resource.';
        break;
      case 500:
        title = 'Server Error';
        subtitle = 'Something went wrong on our end. Please try again later.';
        break;
      default:
        title = 'Something Went Wrong';
        subtitle = 'We encountered an unexpected error.';
    }

    return Column(
      children: [
        Text(
          title,
          style: AppTypography.headlineMedium.copyWith(
            color: isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: AppTypography.bodyLarge.copyWith(
            color: isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        if (error.isNotEmpty && error != title) ...[
          const SizedBox(height: 8),
          Text(
            error,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.error,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildErrorDetails(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkSurfaceVariant
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Error Details',
                style: AppTypography.labelMedium.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            details!,
            style: AppTypography.bodySmall.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ResponsiveWidget(
      mobile: Column(
        children: [
          CustomButton(
            text: 'Go Home',
            onPressed: () => context.goNamed('landing'),
            size: ButtonSize.large,
            isFullWidth: true,
            icon: const Icon(Icons.home),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Go Back',
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed('landing');
              }
            },
            variant: ButtonVariant.outline,
            size: ButtonSize.large,
            isFullWidth: true,
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => _reportError(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bug_report, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Report this error',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      desktop: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Go Home',
                onPressed: () => context.goNamed('landing'),
                size: ButtonSize.large,
                icon: const Icon(Icons.home),
              ),
              const SizedBox(width: 16),
              CustomButton(
                text: 'Go Back',
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.goNamed('landing');
                  }
                },
                variant: ButtonVariant.outline,
                size: ButtonSize.large,
                icon: const Icon(Icons.arrow_back),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => _reportError(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bug_report, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Report this error',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _reportError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Error'),
        content: const Text(
          'Thank you for helping us improve! Our team has been notified of this error. '
          'If you continue to experience issues, please contact our support team.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          CustomButton(
            text: 'Contact Support',
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement support contact
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Support contact feature will be implemented soon',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            size: ButtonSize.medium,
          ),
        ],
      ),
    );
  }
}
