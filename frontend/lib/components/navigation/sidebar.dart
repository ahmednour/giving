import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../utils/responsive.dart';
import '../../providers/auth_provider.dart';

class SidebarItem {
  final String label;
  final IconData icon;
  final String route;
  final List<SidebarItem>? children;
  final bool isSelected;

  const SidebarItem({
    required this.label,
    required this.icon,
    required this.route,
    this.children,
    this.isSelected = false,
  });
}

class Sidebar extends StatefulWidget {
  final bool isCollapsed;
  final VoidCallback? onToggle;
  final String currentRoute;

  const Sidebar({
    super.key,
    this.isCollapsed = false,
    this.onToggle,
    required this.currentRoute,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  final Map<String, bool> _expandedItems = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _widthAnimation = Tween<double>(begin: 280.0, end: 80.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.isCollapsed) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(Sidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCollapsed != oldWidget.isCollapsed) {
      if (widget.isCollapsed) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<SidebarItem> get _menuItems {
    return [
      const SidebarItem(
        label: 'Dashboard',
        icon: Icons.dashboard,
        route: '/dashboard',
      ),
      const SidebarItem(
        label: 'Donations',
        icon: Icons.favorite,
        route: '/donations',
        children: [
          SidebarItem(
            label: 'My Donations',
            icon: Icons.volunteer_activism,
            route: '/donations/my',
          ),
          SidebarItem(
            label: 'Browse Requests',
            icon: Icons.search,
            route: '/donations/browse',
          ),
        ],
      ),
      const SidebarItem(
        label: 'Requests',
        icon: Icons.help_outline,
        route: '/requests',
        children: [
          SidebarItem(
            label: 'My Requests',
            icon: Icons.list_alt,
            route: '/requests/my',
          ),
          SidebarItem(
            label: 'Create Request',
            icon: Icons.add_circle_outline,
            route: '/requests/create',
          ),
        ],
      ),
      const SidebarItem(
        label: 'Messages',
        icon: Icons.message,
        route: '/messages',
      ),
      const SidebarItem(
        label: 'Analytics',
        icon: Icons.analytics,
        route: '/analytics',
      ),
      const SidebarItem(
        label: 'Settings',
        icon: Icons.settings,
        route: '/settings',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();

    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        final isCollapsed = _animationController.value > 0.5;

        return Container(
          width: _widthAnimation.value,
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkSurface : AppColors.surface,
            border: Border(
              right: BorderSide(
                color: isDarkMode ? AppColors.darkBorder : AppColors.border,
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(2, 0),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                height: 72,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDarkMode
                          ? AppColors.darkBorder
                          : AppColors.border,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    if (!isCollapsed) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Giving Bridge',
                          style: AppTypography.titleMedium.copyWith(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    IconButton(
                      icon: Icon(
                        isCollapsed ? Icons.menu : Icons.menu_open,
                        size: 20,
                      ),
                      onPressed: widget.onToggle,
                      tooltip: isCollapsed
                          ? 'Expand Sidebar'
                          : 'Collapse Sidebar',
                    ),
                  ],
                ),
              ),

              // User Profile Section
              if (!isCollapsed) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          authProvider.user?.initials ?? 'U',
                          style: AppTypography.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authProvider.user?.fullName ?? 'User',
                              style: AppTypography.labelLarge.copyWith(
                                color: isDarkMode
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              authProvider.user?.email ?? 'user@example.com',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDarkMode
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDarkMode ? AppColors.darkBorder : AppColors.border,
                ),
              ] else ...[
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    authProvider.user?.initials ?? 'U',
                    style: AppTypography.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: _menuItems
                      .map(
                        (item) => _buildMenuItem(
                          context,
                          item,
                          isCollapsed,
                          isDarkMode,
                        ),
                      )
                      .toList(),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDarkMode
                          ? AppColors.darkBorder
                          : AppColors.border,
                      width: 1,
                    ),
                  ),
                ),
                child: isCollapsed
                    ? IconButton(
                        icon: const Icon(Icons.logout, size: 20),
                        onPressed: () => _handleLogout(context, authProvider),
                        tooltip: 'Sign Out',
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _handleLogout(context, authProvider),
                          icon: const Icon(Icons.logout, size: 18),
                          label: const Text('Sign Out'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                            side: BorderSide(
                              color: isDarkMode
                                  ? AppColors.darkBorder
                                  : AppColors.border,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    SidebarItem item,
    bool isCollapsed,
    bool isDarkMode,
  ) {
    final isSelected = widget.currentRoute.startsWith(item.route);
    final hasChildren = item.children != null && item.children!.isNotEmpty;
    final isExpanded = _expandedItems[item.route] ?? false;

    if (isCollapsed) {
      return Tooltip(
        message: item.label,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: InkWell(
            onTap: () => _handleItemTap(context, item),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.icon,
                color: isSelected
                    ? AppColors.primary
                    : (isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary),
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: InkWell(
            onTap: () => _handleItemTap(context, item),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: AppTypography.labelLarge.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : (isDarkMode
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (hasChildren)
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (hasChildren && isExpanded)
          ...item.children!.map(
            (child) => Container(
              margin: const EdgeInsets.only(left: 20),
              child: _buildMenuItem(context, child, false, isDarkMode),
            ),
          ),
      ],
    );
  }

  void _handleItemTap(BuildContext context, SidebarItem item) {
    if (item.children != null && item.children!.isNotEmpty) {
      setState(() {
        _expandedItems[item.route] = !(_expandedItems[item.route] ?? false);
      });
    } else {
      context.go(item.route);
    }
  }

  Future<void> _handleLogout(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    await authProvider.logout();
    if (context.mounted) {
      context.goNamed('landing');
    }
  }
}
