import 'package:flutter/material.dart';

class WebColors {
  // Light Mode Colors (based on provided CSS variables)
  static const Color lightBackground = Color(0xFFFFFFFF); // #ffffff
  static const Color lightForeground =
      Color(0xFF252525); // oklch(0.145 0 0) approximation
  static const Color lightCard = Color(0xFFFFFFFF); // #ffffff
  static const Color lightCardForeground =
      Color(0xFF252525); // oklch(0.145 0 0)
  static const Color lightPrimary = Color(0xFF030213); // #030213
  static const Color lightPrimaryForeground = Color(0xFFFFFFFF); // oklch(1 0 0)
  static const Color lightSecondary =
      Color(0xFFF1F2F6); // oklch(0.95 0.0058 264.53) approximation
  static const Color lightSecondaryForeground = Color(0xFF030213); // #030213
  static const Color lightMuted = Color(0xFFECECF0); // #ececf0
  static const Color lightMutedForeground = Color(0xFF717182); // #717182
  static const Color lightAccent = Color(0xFFE9EBEF); // #e9ebef
  static const Color lightAccentForeground = Color(0xFF030213); // #030213
  static const Color lightDestructive = Color(0xFFD4183D); // #d4183d
  static const Color lightDestructiveForeground = Color(0xFFFFFFFF); // #ffffff
  static const Color lightBorder = Color(0x1A000000); // rgba(0, 0, 0, 0.1)
  static const Color lightInputBackground = Color(0xFFF3F3F5); // #f3f3f5

  // Dark Mode Colors (based on provided CSS variables)
  static const Color darkBackground =
      Color(0xFF252525); // oklch(0.145 0 0) approximation
  static const Color darkForeground =
      Color(0xFFFBFBFB); // oklch(0.985 0 0) approximation
  static const Color darkPrimary = Color(0xFFFBFBFB); // oklch(0.985 0 0)
  static const Color darkPrimaryForeground =
      Color(0xFF343434); // oklch(0.205 0 0)
  static const Color darkSecondary =
      Color(0xFF434343); // oklch(0.269 0 0) approximation
  static const Color darkSecondaryForeground =
      Color(0xFFFBFBFB); // oklch(0.985 0 0)
  static const Color darkMuted = Color(0xFF434343); // oklch(0.269 0 0)
  static const Color darkMutedForeground =
      Color(0xFFB5B5B5); // oklch(0.708 0 0) approximation
  static const Color darkAccent = Color(0xFF434343); // oklch(0.269 0 0)
  static const Color darkAccentForeground =
      Color(0xFFFBFBFB); // oklch(0.985 0 0)
  static const Color darkDestructive = Color(0xFFD4183D); // same as light
  static const Color darkDestructiveForeground =
      Color(0xFFFFFFFF); // same as light
  static const Color darkBorder = Color(0x1AFFFFFF); // rgba(255, 255, 255, 0.1)
  static const Color darkInputBackground =
      Color(0xFF2A2A2A); // darker input background

  // Success and Warning colors (not in original palette, but commonly needed)
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}

class WebColorScheme {
  static ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: WebColors.lightPrimary,
    onPrimary: WebColors.lightPrimaryForeground,
    secondary: WebColors.lightSecondary,
    onSecondary: WebColors.lightSecondaryForeground,
    error: WebColors.lightDestructive,
    onError: WebColors.lightDestructiveForeground,
    surface: WebColors.lightCard,
    onSurface: WebColors.lightCardForeground,
    background: WebColors.lightBackground,
    onBackground: WebColors.lightForeground,
    surfaceVariant: WebColors.lightAccent,
    onSurfaceVariant: WebColors.lightAccentForeground,
    outline: WebColors.lightBorder,
    outlineVariant: WebColors.lightMuted,
    tertiary: WebColors.lightMuted,
    onTertiary: WebColors.lightMutedForeground,
  );

  static ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: WebColors.darkPrimary,
    onPrimary: WebColors.darkPrimaryForeground,
    secondary: WebColors.darkSecondary,
    onSecondary: WebColors.darkSecondaryForeground,
    error: WebColors.darkDestructive,
    onError: WebColors.darkDestructiveForeground,
    surface: WebColors.darkSecondary,
    onSurface: WebColors.darkForeground,
    background: WebColors.darkBackground,
    onBackground: WebColors.darkForeground,
    surfaceVariant: WebColors.darkAccent,
    onSurfaceVariant: WebColors.darkAccentForeground,
    outline: WebColors.darkBorder,
    outlineVariant: WebColors.darkMuted,
    tertiary: WebColors.darkMuted,
    onTertiary: WebColors.darkMutedForeground,
  );
}
