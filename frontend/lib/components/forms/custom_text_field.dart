import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../utils/responsive.dart';

enum TextFieldVariant { filled, outlined, underlined }

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final String? initialValue;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final bool showClearButton;
  final TextFieldVariant variant;
  final EdgeInsets? contentPadding;
  final BorderRadius? borderRadius;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.showClearButton = false,
    this.variant = TextFieldVariant.outlined,
    this.contentPadding,
    this.borderRadius,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isFocused = false;
  bool _hasText = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _hasText = _controller.text.isNotEmpty;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);

    if (_isFocused || _hasText) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused || _hasText) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });

      if (_isFocused || _hasText) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }

    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _clearText() {
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null &&
            widget.variant != TextFieldVariant.filled) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label!,
              style: AppTypography.labelLarge.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],

        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              obscureText: _obscureText,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              autofocus: widget.autofocus,
              maxLines: widget.obscureText ? 1 : widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              inputFormatters: widget.inputFormatters,
              onFieldSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
              validator: widget.validator,
              style: AppTypography.bodyLarge.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: widget.variant == TextFieldVariant.filled
                    ? widget.label
                    : null,
                hintText: widget.hint,
                helperText: widget.helperText,
                errorText: widget.errorText,
                filled: widget.variant == TextFieldVariant.filled,
                fillColor: _getFillColor(isDarkMode),
                contentPadding: widget.contentPadding ?? _getContentPadding(),
                border: _getBorder(isDarkMode, false, false),
                enabledBorder: _getBorder(isDarkMode, false, false),
                focusedBorder: _getBorder(isDarkMode, true, false),
                errorBorder: _getBorder(isDarkMode, false, true),
                focusedErrorBorder: _getBorder(isDarkMode, true, true),
                disabledBorder: _getBorder(isDarkMode, false, false),

                prefixIcon: widget.prefixIcon,
                prefixText: widget.prefixText,
                suffixText: widget.suffixText,

                suffixIcon: _buildSuffixIcon(),

                labelStyle: AppTypography.labelLarge.copyWith(
                  color: _getLabelColor(isDarkMode),
                ),
                hintStyle: AppTypography.bodyLarge.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextTertiary
                      : AppColors.textTertiary,
                ),
                helperStyle: AppTypography.bodySmall.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                errorStyle: AppTypography.bodySmall.copyWith(
                  color: AppColors.error,
                ),

                counterStyle: AppTypography.bodySmall.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    final List<Widget> suffixWidgets = [];

    // Clear button
    if (widget.showClearButton && _hasText && widget.enabled) {
      suffixWidgets.add(
        IconButton(
          onPressed: _clearText,
          icon: const Icon(Icons.clear, size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        ),
      );
    }

    // Password visibility toggle
    if (widget.obscureText) {
      suffixWidgets.add(
        IconButton(
          onPressed: _toggleObscureText,
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            size: 20,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
        ),
      );
    }

    // Custom suffix icon
    if (widget.suffixIcon != null) {
      suffixWidgets.add(widget.suffixIcon!);
    }

    if (suffixWidgets.isEmpty) return null;

    if (suffixWidgets.length == 1) {
      return suffixWidgets.first;
    }

    return Row(mainAxisSize: MainAxisSize.min, children: suffixWidgets);
  }

  EdgeInsets _getContentPadding() {
    switch (widget.variant) {
      case TextFieldVariant.filled:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
      case TextFieldVariant.outlined:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
      case TextFieldVariant.underlined:
        return const EdgeInsets.symmetric(horizontal: 0, vertical: 16);
    }
  }

  Color _getFillColor(bool isDarkMode) {
    switch (widget.variant) {
      case TextFieldVariant.filled:
        return isDarkMode
            ? AppColors.darkSurfaceVariant
            : AppColors.surfaceVariant;
      case TextFieldVariant.outlined:
      case TextFieldVariant.underlined:
        return Colors.transparent;
    }
  }

  Color _getLabelColor(bool isDarkMode) {
    if (!widget.enabled) {
      return isDarkMode ? AppColors.darkTextDisabled : AppColors.textDisabled;
    }

    if (_isFocused) {
      return AppColors.primary;
    }

    return isDarkMode ? AppColors.darkTextSecondary : AppColors.textSecondary;
  }

  InputBorder _getBorder(bool isDarkMode, bool isFocused, bool isError) {
    final borderColor = isError
        ? AppColors.error
        : isFocused
        ? AppColors.primary
        : (isDarkMode ? AppColors.darkBorder : AppColors.border);

    final borderWidth = isFocused || isError ? 2.0 : 1.0;

    switch (widget.variant) {
      case TextFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          borderSide: BorderSide.none,
        );
      case TextFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor, width: borderWidth),
        );
      case TextFieldVariant.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: borderWidth),
        );
    }
  }
}
