import 'package:flutter/material.dart';
import '../theme/web_colors.dart';
import '../theme/web_typography.dart';

class WebInput extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isRequired;
  final bool isDisabled;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;

  const WebInput({
    super.key,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.isPassword = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onTap,
    this.validator,
    this.maxLines,
    this.minLines,
  });

  @override
  State<WebInput> createState() => _WebInputState();
}

class _WebInputState extends State<WebInput> {
  bool _isFocused = false;
  bool _isHovered = false;
  bool _isPasswordVisible = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  Color get _borderColor {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.errorText != null) {
      return isDark ? WebColors.darkDestructive : WebColors.lightDestructive;
    }
    if (_isFocused) {
      return isDark ? WebColors.darkPrimary : WebColors.lightPrimary;
    }
    if (_isHovered) {
      return isDark
          ? WebColors.darkBorder.withOpacity(0.8)
          : WebColors.lightBorder.withOpacity(0.8);
    }
    return isDark ? WebColors.darkBorder : WebColors.lightBorder;
  }

  Color get _backgroundColor {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.isDisabled) {
      return isDark
          ? WebColors.darkMuted.withOpacity(0.5)
          : WebColors.lightMuted.withOpacity(0.5);
    }
    return isDark
        ? WebColors.darkInputBackground
        : WebColors.lightInputBackground;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label,
              style: WebTypography.baseTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? WebColors.darkForeground
                    : WebColors.lightForeground,
              ),
              children: widget.isRequired
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: isDark
                              ? WebColors.darkDestructive
                              : WebColors.lightDestructive,
                        ),
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(height: 8),
        ],
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _borderColor,
                width: _isFocused ? 2 : 1,
              ),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: (isDark
                                ? WebColors.darkPrimary
                                : WebColors.lightPrimary)
                            .withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: !widget.isDisabled,
              obscureText: widget.isPassword && !_isPasswordVisible,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              maxLines: widget.isPassword ? 1 : widget.maxLines,
              minLines: widget.minLines,
              style: WebTypography.baseTextStyle.copyWith(
                color: widget.isDisabled
                    ? (isDark
                        ? WebColors.darkMutedForeground
                        : WebColors.lightMutedForeground)
                    : (isDark
                        ? WebColors.darkForeground
                        : WebColors.lightForeground),
              ),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: WebTypography.baseTextStyle.copyWith(
                  color: isDark
                      ? WebColors.darkMutedForeground
                      : WebColors.lightMutedForeground,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: isDark
                            ? WebColors.darkMutedForeground
                            : WebColors.lightMutedForeground,
                        size: 20,
                      )
                    : null,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: isDark
                              ? WebColors.darkMutedForeground
                              : WebColors.lightMutedForeground,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      )
                    : widget.suffixIcon,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
        if (widget.helperText != null || widget.errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText ?? widget.helperText!,
            style: WebTypography.baseTextStyle.copyWith(
              fontSize: 12,
              color: widget.errorText != null
                  ? (isDark
                      ? WebColors.darkDestructive
                      : WebColors.lightDestructive)
                  : (isDark
                      ? WebColors.darkMutedForeground
                      : WebColors.lightMutedForeground),
            ),
          ),
        ],
      ],
    );
  }
}
