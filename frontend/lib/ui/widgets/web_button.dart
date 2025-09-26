import 'package:flutter/material.dart';
import '../theme/web_colors.dart';
import '../theme/web_typography.dart';

enum WebButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
}

enum WebButtonSize {
  small,
  medium,
  large,
}

class WebButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final WebButtonVariant variant;
  final WebButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const WebButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = WebButtonVariant.primary,
    this.size = WebButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  State<WebButton> createState() => _WebButtonState();
}

class _WebButtonState extends State<WebButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  EdgeInsets get _padding {
    switch (widget.size) {
      case WebButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case WebButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case WebButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case WebButtonSize.small:
        return 14;
      case WebButtonSize.medium:
        return 16;
      case WebButtonSize.large:
        return 18;
    }
  }

  Color get _backgroundColor {
    if (widget.onPressed == null) {
      return WebColors.lightMuted;
    }

    switch (widget.variant) {
      case WebButtonVariant.primary:
        return _isHovered
            ? WebColors.lightPrimary.withOpacity(0.9)
            : WebColors.lightPrimary;
      case WebButtonVariant.secondary:
        return _isHovered
            ? WebColors.lightSecondary.withOpacity(0.8)
            : WebColors.lightSecondary;
      case WebButtonVariant.outline:
      case WebButtonVariant.ghost:
        return _isHovered
            ? WebColors.lightPrimary.withOpacity(0.05)
            : Colors.transparent;
      case WebButtonVariant.destructive:
        return _isHovered
            ? WebColors.lightDestructive.withOpacity(0.9)
            : WebColors.lightDestructive;
    }
  }

  Color get _foregroundColor {
    if (widget.onPressed == null) {
      return WebColors.lightMutedForeground;
    }

    switch (widget.variant) {
      case WebButtonVariant.primary:
        return WebColors.lightPrimaryForeground;
      case WebButtonVariant.secondary:
        return WebColors.lightSecondaryForeground;
      case WebButtonVariant.outline:
      case WebButtonVariant.ghost:
        return WebColors.lightPrimary;
      case WebButtonVariant.destructive:
        return WebColors.lightDestructiveForeground;
    }
  }

  BorderSide? get _borderSide {
    if (widget.variant == WebButtonVariant.outline) {
      return BorderSide(
        color: widget.onPressed == null
            ? WebColors.lightBorder
            : WebColors.lightPrimary,
        width: 1,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: widget.isFullWidth ? double.infinity : null,
            padding: _padding,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(6),
              border: _borderSide != null
                  ? Border.fromBorderSide(_borderSide!)
                  : null,
              boxShadow:
                  widget.variant == WebButtonVariant.primary && !_isHovered
                      ? [
                          BoxShadow(
                            color: WebColors.lightPrimary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading)
                  SizedBox(
                    width: _fontSize,
                    height: _fontSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(_foregroundColor),
                    ),
                  )
                else if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: _fontSize,
                    color: _foregroundColor,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: WebTypography.buttonText.copyWith(
                    fontSize: _fontSize,
                    color: _foregroundColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
