import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'web_colors.dart';
import 'web_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: WebColorScheme.light,
      textTheme: WebTypography.lightTextTheme,

      // App Bar with web-like styling
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: WebTypography.baseTextStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: WebColors.lightForeground,
        ),
        iconTheme: const IconThemeData(
          color: WebColors.lightForeground,
        ),
      ),

      // Elevated Button with web-like styling and hover effects
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: WebColors.lightPrimary,
          foregroundColor: WebColors.lightPrimaryForeground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(120, 44),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: WebTypography.buttonText,
        ).copyWith(
          // Hover effects for web
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return WebColors.lightPrimaryForeground.withOpacity(0.1);
              }
              if (states.contains(MaterialState.pressed)) {
                return WebColors.lightPrimaryForeground.withOpacity(0.2);
              }
              return null;
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return WebColors.lightPrimary.withOpacity(0.9);
              }
              return WebColors.lightPrimary;
            },
          ),
        ),
      ),

      // Text Button styling
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: WebColors.lightPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: WebTypography.buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return WebColors.lightPrimary.withOpacity(0.08);
              }
              return null;
            },
          ),
        ),
      ),

      // Card with subtle shadows and hover effects
      cardTheme: CardThemeData(
        color: WebColors.lightCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: WebColors.lightBorder,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: WebColors.lightBorder,
            width: 1,
          ),
        ),
      ),

      // Input fields with web-like styling
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WebColors.lightInputBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: WebColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: WebColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: WebColors.lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: WebColors.lightDestructive),
        ),
        labelStyle: WebTypography.baseTextStyle.copyWith(
          color: WebColors.lightMutedForeground,
        ),
        hintStyle: WebTypography.baseTextStyle.copyWith(
          color: WebColors.lightMutedForeground,
        ),
      ),

      // Scaffold with proper web background
      scaffoldBackgroundColor: WebColors.lightBackground,

      // Navigation bar styling
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: WebColors.lightCard,
        surfaceTintColor: Colors.transparent,
        indicatorColor: WebColors.lightPrimary.withOpacity(0.1),
        labelTextStyle: MaterialStateProperty.all(WebTypography.navigationText),
      ),

      // Divider styling
      dividerTheme: const DividerThemeData(
        color: WebColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: WebColorScheme.dark,
      textTheme: WebTypography.darkTextTheme,

      // App Bar for dark mode
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: WebTypography.baseTextStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: WebColors.darkForeground,
        ),
        iconTheme: const IconThemeData(
          color: WebColors.darkForeground,
        ),
      ),

      // Elevated Button for dark mode
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: WebColors.darkPrimary,
          foregroundColor: WebColors.darkPrimaryForeground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(120, 44),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: WebTypography.buttonText,
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return WebColors.darkPrimaryForeground.withOpacity(0.1);
              }
              if (states.contains(MaterialState.pressed)) {
                return WebColors.darkPrimaryForeground.withOpacity(0.2);
              }
              return null;
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return WebColors.darkPrimary.withOpacity(0.9);
              }
              return WebColors.darkPrimary;
            },
          ),
        ),
      ),

      // Text Button for dark mode
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: WebColors.darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: WebTypography.buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return WebColors.darkPrimary.withOpacity(0.08);
              }
              return null;
            },
          ),
        ),
      ),

      // Card for dark mode
      cardTheme: CardThemeData(
        color: WebColors.darkSecondary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: WebColors.darkBorder,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: WebColors.darkBorder,
            width: 1,
          ),
        ),
      ),

      // Input fields for dark mode
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WebColors.darkInputBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: WebColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: WebColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: WebColors.darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: WebColors.darkDestructive),
        ),
        labelStyle: WebTypography.baseTextStyle.copyWith(
          color: WebColors.darkMutedForeground,
        ),
        hintStyle: WebTypography.baseTextStyle.copyWith(
          color: WebColors.darkMutedForeground,
        ),
      ),

      // Scaffold for dark mode
      scaffoldBackgroundColor: WebColors.darkBackground,

      // Navigation bar for dark mode
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: WebColors.darkSecondary,
        surfaceTintColor: Colors.transparent,
        indicatorColor: WebColors.darkPrimary.withOpacity(0.1),
        labelTextStyle: MaterialStateProperty.all(WebTypography.navigationText),
      ),

      // Divider for dark mode
      dividerTheme: const DividerThemeData(
        color: WebColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
