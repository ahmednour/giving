import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2563EB); // Blue 600
  static const Color primaryLight = Color(0xFF3B82F6); // Blue 500
  static const Color primaryDark = Color(0xFF1D4ED8); // Blue 700

  // Secondary Colors
  static const Color secondary = Color(0xFF10B981); // Emerald 500
  static const Color secondaryLight = Color(0xFF34D399); // Emerald 400
  static const Color secondaryDark = Color(0xFF059669); // Emerald 600

  // Accent Colors
  static const Color accent = Color(0xFF8B5CF6); // Violet 500
  static const Color accentLight = Color(0xFFA78BFA); // Violet 400
  static const Color accentDark = Color(0xFF7C3AED); // Violet 600

  // Neutral Colors (Light Theme)
  static const Color background = Color(0xFFFAFAFA); // Gray 50
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFF5F5F5); // Gray 100
  static const Color border = Color(0xFFE5E7EB); // Gray 200
  static const Color divider = Color(0xFFE5E7EB); // Gray 200

  // Text Colors (Light Theme)
  static const Color textPrimary = Color(0xFF111827); // Gray 900
  static const Color textSecondary = Color(0xFF6B7280); // Gray 500
  static const Color textTertiary = Color(0xFF9CA3AF); // Gray 400
  static const Color textDisabled = Color(0xFFD1D5DB); // Gray 300

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceVariant = Color(0xFF334155); // Slate 700
  static const Color darkBorder = Color(0xFF475569); // Slate 600
  static const Color darkDivider = Color(0xFF475569); // Slate 600

  // Text Colors (Dark Theme)
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFFCBD5E1); // Slate 300
  static const Color darkTextTertiary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextDisabled = Color(0xFF64748B); // Slate 500

  // Status Colors
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color info = Color(0xFF3B82F6); // Blue 500

  // Status Colors - Light
  static const Color successLight = Color(0xFFD1FAE5); // Emerald 100
  static const Color warningLight = Color(0xFFFEF3C7); // Amber 100
  static const Color errorLight = Color(0xFFFEE2E2); // Red 100
  static const Color infoLight = Color(0xFFDBEAFE); // Blue 100

  // Status Colors - Dark
  static const Color successDark = Color(0xFF065F46); // Emerald 800
  static const Color warningDark = Color(0xFF92400E); // Amber 800
  static const Color errorDark = Color(0xFF991B1B); // Red 800
  static const Color infoDark = Color(0xFF1E3A8A); // Blue 800

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Hero Gradient
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Material 3 Color Schemes
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: Colors.white,
    tertiary: accent,
    onTertiary: Colors.white,
    surface: surface,
    onSurface: textPrimary,
    background: background,
    onBackground: textPrimary,
    error: error,
    onError: Colors.white,
    outline: border,
    outlineVariant: divider,
    surfaceVariant: surfaceVariant,
    onSurfaceVariant: textSecondary,
  );

  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: primary,
    onPrimary: Colors.white,
    secondary: secondary,
    onSecondary: Colors.white,
    tertiary: accent,
    onTertiary: Colors.white,
    surface: darkSurface,
    onSurface: darkTextPrimary,
    background: darkBackground,
    onBackground: darkTextPrimary,
    error: error,
    onError: Colors.white,
    outline: darkBorder,
    outlineVariant: darkDivider,
    surfaceVariant: darkSurfaceVariant,
    onSurfaceVariant: darkTextSecondary,
  );
}
