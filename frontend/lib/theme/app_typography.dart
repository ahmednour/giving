import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  // Display Styles (for hero sections and large headings)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 57,
    fontWeight: FontWeight.bold,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 45,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 36,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  // Headline Styles (for page titles and section headers)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // Title Styles (for card titles and component headers)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // Body Styles (for regular text content)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // Label Styles (for buttons, labels, and captions)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: AppColors.textSecondary,
  );

  // Button Styles
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: Colors.white,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: Colors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: Colors.white,
  );

  // Special Styles
  static const TextStyle subtitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
    color: AppColors.textTertiary,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
  );

  // Link Style
  static const TextStyle link = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // Error Text Style
  static const TextStyle error = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
    color: AppColors.error,
  );

  // Hero Text Style
  static const TextStyle heroTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    height: 1.1,
    color: Colors.white,
  );

  static const TextStyle heroSubtitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: Colors.white,
  );

  // Dark Theme Variants
  static TextStyle displayLargeDark = displayLarge.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle displayMediumDark = displayMedium.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle displaySmallDark = displaySmall.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle headlineLargeDark = headlineLarge.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle headlineMediumDark = headlineMedium.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle headlineSmallDark = headlineSmall.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle titleLargeDark = titleLarge.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle titleMediumDark = titleMedium.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle titleSmallDark = titleSmall.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle bodyLargeDark = bodyLarge.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle bodyMediumDark = bodyMedium.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle bodySmallDark = bodySmall.copyWith(
    color: AppColors.darkTextSecondary,
  );
  static TextStyle labelLargeDark = labelLarge.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle labelMediumDark = labelMedium.copyWith(
    color: AppColors.darkTextPrimary,
  );
  static TextStyle labelSmallDark = labelSmall.copyWith(
    color: AppColors.darkTextSecondary,
  );
  static TextStyle subtitleDark = subtitle.copyWith(
    color: AppColors.darkTextSecondary,
  );
  static TextStyle captionDark = caption.copyWith(
    color: AppColors.darkTextTertiary,
  );
  static TextStyle overlineDark = overline.copyWith(
    color: AppColors.darkTextSecondary,
  );
  static TextStyle linkDark = link.copyWith(color: AppColors.primary);
}
