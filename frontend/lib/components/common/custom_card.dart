import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

enum CardVariant { elevated, outlined, filled }

class CustomCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final CardVariant variant;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final bool showShadow;
  final bool isClickable;
  final String? tooltip;

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.variant = CardVariant.outlined,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.showShadow = false,
    this.isClickable = false,
    this.tooltip,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 0.0, end: 4.0).animate(
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

    Widget card = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isClickable ? _scaleAnimation.value : 1.0,
          child: Container(
            margin: widget.margin,
            decoration: BoxDecoration(
              color: _getBackgroundColor(isDarkMode),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              border: _getBorder(isDarkMode),
              boxShadow: _getBoxShadow(isDarkMode),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                splashColor: AppColors.primary.withOpacity(0.1),
                highlightColor: AppColors.primary.withOpacity(0.05),
                child: Container(
                  padding: widget.padding ?? const EdgeInsets.all(16),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );

    if (widget.isClickable || widget.onTap != null) {
      card = MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _animationController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _animationController.reverse();
        },
        child: card,
      );
    }

    if (widget.tooltip != null) {
      card = Tooltip(message: widget.tooltip!, child: card);
    }

    return card;
  }

  Color _getBackgroundColor(bool isDarkMode) {
    if (widget.backgroundColor != null) {
      return widget.backgroundColor!;
    }

    switch (widget.variant) {
      case CardVariant.elevated:
      case CardVariant.outlined:
        return isDarkMode ? AppColors.darkSurface : AppColors.surface;
      case CardVariant.filled:
        return isDarkMode
            ? AppColors.darkSurfaceVariant
            : AppColors.surfaceVariant;
    }
  }

  Border? _getBorder(bool isDarkMode) {
    if (widget.variant == CardVariant.outlined) {
      return Border.all(
        color:
            widget.borderColor ??
            (isDarkMode ? AppColors.darkBorder : AppColors.border),
        width: 1,
      );
    }
    return null;
  }

  List<BoxShadow>? _getBoxShadow(bool isDarkMode) {
    if (!widget.showShadow && widget.variant != CardVariant.elevated) {
      return null;
    }

    final baseElevation =
        widget.elevation ??
        (widget.variant == CardVariant.elevated ? 2.0 : 0.0);
    final currentElevation = widget.isClickable && _isHovered
        ? baseElevation + _elevationAnimation.value
        : baseElevation;

    if (currentElevation <= 0) return null;

    return [
      BoxShadow(
        color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
        offset: Offset(0, currentElevation),
        blurRadius: currentElevation * 2,
        spreadRadius: 0,
      ),
    ];
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.onTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return CustomCard(
      onTap: onTap,
      isClickable: onTap != null,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconTheme(
                data: IconThemeData(
                  color: iconColor ?? AppColors.primary,
                  size: 24,
                ),
                child: icon!,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actions != null) ...[
            const SizedBox(width: 16),
            Row(mainAxisSize: MainAxisSize.min, children: actions!),
          ],
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Widget? icon;
  final Color? color;
  final String? trend;
  final bool isPositiveTrend;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.color,
    this.trend,
    this.isPositiveTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = color ?? AppColors.primary;

    return CustomCard(
      variant: CardVariant.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.labelMedium.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconTheme(
                    data: IconThemeData(color: cardColor, size: 20),
                    child: icon!,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.headlineMedium.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null || trend != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                if (subtitle != null)
                  Expanded(
                    child: Text(
                      subtitle!,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                if (trend != null) ...[
                  Icon(
                    isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                    size: 16,
                    color: isPositiveTrend
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend!,
                    style: AppTypography.bodySmall.copyWith(
                      color: isPositiveTrend
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
