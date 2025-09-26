import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/web_colors.dart';
import '../theme/web_typography.dart';
import 'web_button.dart';
import 'web_container.dart';

class WebNavbar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final List<WebNavbarItem> items;
  final List<Widget>? actions;
  final bool showLogo;
  final VoidCallback? onLogoTap;

  const WebNavbar({
    super.key,
    this.title,
    this.items = const [],
    this.actions,
    this.showLogo = true,
    this.onLogoTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  State<WebNavbar> createState() => _WebNavbarState();
}

class _WebNavbarState extends State<WebNavbar> {
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    // You could add scroll listener here if needed
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: isDark
            ? WebColors.darkBackground.withOpacity(0.95)
            : WebColors.lightBackground.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: isDark ? WebColors.darkBorder : WebColors.lightBorder,
            width: 1,
          ),
        ),
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: WebContainer.content(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // Logo/Title section
            if (widget.showLogo || widget.title != null)
              GestureDetector(
                onTap: widget.onLogoTap ?? () => context.go('/'),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showLogo) ...[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isDark
                                ? WebColors.darkPrimary
                                : WebColors.lightPrimary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: isDark
                                ? WebColors.darkPrimaryForeground
                                : WebColors.lightPrimaryForeground,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (widget.title != null)
                        Text(
                          widget.title!,
                          style: WebTypography.baseTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? WebColors.darkForeground
                                : WebColors.lightForeground,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            const SizedBox(width: 32),

            // Navigation items (desktop only)
            if (context.isDesktop && widget.items.isNotEmpty) ...[
              Expanded(
                child: Row(
                  children: widget.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 32),
                      child: _WebNavbarButton(item: item),
                    );
                  }).toList(),
                ),
              ),
            ] else
              const Spacer(),

            // Actions section
            if (widget.actions != null) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.actions!.map((action) {
                  final index = widget.actions!.indexOf(action);
                  return Padding(
                    padding: EdgeInsets.only(left: index > 0 ? 8 : 0),
                    child: action,
                  );
                }).toList(),
              ),
            ],

            // Mobile menu button
            if (!context.isDesktop && widget.items.isNotEmpty) ...[
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  _showMobileMenu(context);
                },
                icon: Icon(
                  Icons.menu,
                  color: isDark
                      ? WebColors.darkForeground
                      : WebColors.lightForeground,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MobileMenu(items: widget.items),
    );
  }
}

class _WebNavbarButton extends StatefulWidget {
  final WebNavbarItem item;

  const _WebNavbarButton({required this.item});

  @override
  State<_WebNavbarButton> createState() => _WebNavbarButtonState();
}

class _WebNavbarButtonState extends State<_WebNavbarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = widget.item.isActive?.call() ?? false;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? WebColors.darkPrimary : WebColors.lightPrimary)
                    .withOpacity(0.1)
                : _isHovered
                    ? (isDark ? WebColors.darkBorder : WebColors.lightBorder)
                        .withOpacity(0.5)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.item.label,
            style: WebTypography.navigationText.copyWith(
              color: isActive
                  ? (isDark ? WebColors.darkPrimary : WebColors.lightPrimary)
                  : (isDark
                      ? WebColors.darkForeground
                      : WebColors.lightForeground),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  final List<WebNavbarItem> items;

  const _MobileMenu({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? WebColors.darkSecondary : WebColors.lightCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border.all(
          color: isDark ? WebColors.darkBorder : WebColors.lightBorder,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? WebColors.darkBorder : WebColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ...items.map((item) {
              final isActive = item.isActive?.call() ?? false;
              return ListTile(
                title: Text(
                  item.label,
                  style: WebTypography.baseTextStyle.copyWith(
                    color: isActive
                        ? (isDark
                            ? WebColors.darkPrimary
                            : WebColors.lightPrimary)
                        : (isDark
                            ? WebColors.darkForeground
                            : WebColors.lightForeground),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  item.onTap();
                },
                selected: isActive,
                selectedTileColor:
                    (isDark ? WebColors.darkPrimary : WebColors.lightPrimary)
                        .withOpacity(0.1),
              );
            }).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class WebNavbarItem {
  final String label;
  final VoidCallback onTap;
  final bool Function()? isActive;

  const WebNavbarItem({
    required this.label,
    required this.onTap,
    this.isActive,
  });
}
