import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../utils/responsive.dart';

enum ButtonVariant { primary, secondary, outline, ghost, danger }

enum ButtonSize { small, medium, large }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool disabled;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.padding,
    this.borderRadius,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final isDisabled =
        widget.disabled || widget.isLoading || widget.onPressed == null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: widget.isFullWidth ? double.infinity : null,
                height: _getButtonHeight(context),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(isDarkMode, isDisabled),
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                  border: _getBorder(isDarkMode, isDisabled),
                  boxShadow: _getBoxShadow(isDisabled),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isDisabled ? null : widget.onPressed,
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(8),
                    child: Container(
                      padding: widget.padding ?? _getButtonPadding(context),
                      child: Row(
                        mainAxisSize: widget.isFullWidth
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null && !widget.isLoading) ...[
                            IconTheme(
                              data: IconThemeData(
                                color: _getTextColor(isDarkMode, isDisabled),
                                size: _getIconSize(),
                              ),
                              child: widget.icon!,
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (widget.isLoading) ...[
                            SizedBox(
                              width: _getIconSize(),
                              height: _getIconSize(),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getTextColor(isDarkMode, isDisabled),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              widget.text,
                              style: _getTextStyle(isDarkMode, isDisabled),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (widget.suffixIcon != null &&
                              !widget.isLoading) ...[
                            const SizedBox(width: 8),
                            IconTheme(
                              data: IconThemeData(
                                color: _getTextColor(isDarkMode, isDisabled),
                                size: _getIconSize(),
                              ),
                              child: widget.suffixIcon!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double _getButtonHeight(BuildContext context) {
    switch (widget.size) {
      case ButtonSize.small:
        return Responsive.responsiveValue(context, mobile: 40, desktop: 36);
      case ButtonSize.medium:
        return Responsive.responsiveValue(context, mobile: 48, desktop: 44);
      case ButtonSize.large:
        return Responsive.responsiveValue(context, mobile: 56, desktop: 52);
    }
  }

  EdgeInsets _getButtonPadding(BuildContext context) {
    switch (widget.size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  TextStyle _getTextStyle(bool isDarkMode, bool isDisabled) {
    final baseStyle = switch (widget.size) {
      ButtonSize.small => AppTypography.labelMedium,
      ButtonSize.medium => AppTypography.labelLarge,
      ButtonSize.large => AppTypography.titleMedium,
    };

    return baseStyle.copyWith(
      color: _getTextColor(isDarkMode, isDisabled),
      fontWeight: FontWeight.w600,
    );
  }

  Color _getBackgroundColor(bool isDarkMode, bool isDisabled) {
    if (isDisabled) {
      return isDarkMode ? AppColors.darkTextDisabled : AppColors.textDisabled;
    }

    switch (widget.variant) {
      case ButtonVariant.primary:
        return _isHovered ? AppColors.primaryDark : AppColors.primary;
      case ButtonVariant.secondary:
        return _isHovered ? AppColors.secondaryDark : AppColors.secondary;
      case ButtonVariant.outline:
        return _isHovered
            ? (isDarkMode
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant)
            : Colors.transparent;
      case ButtonVariant.ghost:
        return _isHovered
            ? (isDarkMode
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant)
            : Colors.transparent;
      case ButtonVariant.danger:
        return _isHovered ? AppColors.errorDark : AppColors.error;
    }
  }

  Color _getTextColor(bool isDarkMode, bool isDisabled) {
    if (isDisabled) {
      return isDarkMode ? AppColors.darkTextDisabled : AppColors.textDisabled;
    }

    switch (widget.variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.danger:
        return Colors.white;
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        return isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary;
    }
  }

  Border? _getBorder(bool isDarkMode, bool isDisabled) {
    if (widget.variant == ButtonVariant.outline) {
      final borderColor = isDisabled
          ? (isDarkMode ? AppColors.darkTextDisabled : AppColors.textDisabled)
          : (isDarkMode ? AppColors.darkBorder : AppColors.border);

      return Border.all(color: borderColor, width: 1);
    }
    return null;
  }

  List<BoxShadow>? _getBoxShadow(bool isDisabled) {
    if (isDisabled ||
        widget.variant == ButtonVariant.ghost ||
        widget.variant == ButtonVariant.outline) {
      return null;
    }

    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        offset: const Offset(0, 2),
        blurRadius: 4,
      ),
    ];
  }
}
