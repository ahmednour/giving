import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WebTypography {
  // Base font size as specified (16px)
  static const double baseFontSize = 16.0;

  // Font family - using a modern web font
  static TextStyle get baseTextStyle => GoogleFonts.inter(
        fontSize: baseFontSize,
        height: 1.5, // Line height for better readability
        letterSpacing: -0.01, // Slight negative letter spacing for modern look
      );

  // Typography scale for web
  static TextTheme lightTextTheme = TextTheme(
    // Display styles (for hero sections, large headings)
    displayLarge: baseTextStyle.copyWith(
      fontSize: 56,
      fontWeight: FontWeight.w800,
      height: 1.1,
      letterSpacing: -0.02,
    ),
    displayMedium: baseTextStyle.copyWith(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.015,
    ),
    displaySmall: baseTextStyle.copyWith(
      fontSize: 40,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.01,
    ),

    // Headline styles (for section headings)
    headlineLarge: baseTextStyle.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.25,
      letterSpacing: -0.01,
    ),
    headlineMedium: baseTextStyle.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: -0.005,
    ),
    headlineSmall: baseTextStyle.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),

    // Title styles (for card titles, form labels)
    titleLarge: baseTextStyle.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleMedium: baseTextStyle.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    titleSmall: baseTextStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),

    // Body styles (for main content)
    bodyLarge: baseTextStyle.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1.6,
    ),
    bodyMedium: baseTextStyle.copyWith(
      fontSize: 16, // Base font size
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodySmall: baseTextStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),

    // Label styles (for buttons, captions)
    labelLarge: baseTextStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    labelMedium: baseTextStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    labelSmall: baseTextStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
  );

  static TextTheme darkTextTheme =
      lightTextTheme; // Same typography for dark mode

  // Utility text styles for specific web components
  static TextStyle get navigationText => baseTextStyle.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.0,
      );

  static TextStyle get buttonText => baseTextStyle.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.0,
        letterSpacing: 0.01,
      );

  static TextStyle get captionText => baseTextStyle.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get codeText => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );
}
