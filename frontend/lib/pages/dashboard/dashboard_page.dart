import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../utils/responsive.dart';
import '../../components/navigation/sidebar.dart';
import '../../components/navigation/navbar.dart';
import '../../components/common/custom_card.dart';
import '../../components/buttons/custom_button.dart';
import '../../providers/auth_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isSidebarCollapsed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      appBar: Responsive.showSidebar(context)
          ? null
          : AppNavbar(
              title: 'Dashboard',
              actions: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ],
            ),
      drawer: Responsive.showDrawer(context)
          ? Drawer(
              child: Sidebar(currentRoute: '/dashboard', isCollapsed: false),
            )
          : null,
      body: Row(
        children: [
          if (Responsive.showSidebar(context))
            Sidebar(
              currentRoute: '/dashboard',
              isCollapsed: _isSidebarCollapsed,
              onToggle: () {
                setState(() {
                  _isSidebarCollapsed = !_isSidebarCollapsed;
                });
              },
            ),
          Expanded(child: _buildMainContent(context, authProvider, isDarkMode)),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    AuthProvider authProvider,
    bool isDarkMode,
  ) {
    return Container(
      color: isDarkMode ? AppColors.darkBackground : AppColors.background,
      child: SingleChildScrollView(
        padding: Responsive.responsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(authProvider, isDarkMode),
            const SizedBox(height: 32),
            _buildStatsCards(context),
            const SizedBox(height: 32),
            _buildQuickActions(context),
            const SizedBox(height: 32),
            _buildRecentActivity(context, isDarkMode),
            const SizedBox(height: 32),
            _buildUpcomingEvents(context, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(AuthProvider authProvider, bool isDarkMode) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, ${authProvider.user?.firstName ?? 'User'}!',
          style:
              Responsive.responsiveValue(
                context,
                mobile: AppTypography.headlineMedium,
                desktop: AppTypography.headlineLarge,
              ).copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome back to your giving dashboard. Here\'s what\'s happening in your community today.',
          style: AppTypography.bodyLarge.copyWith(
            color: isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    final stats = [
      {
        'title': 'Total Donated',
        'value': '\$2,450',
        'subtitle': 'This month',
        'icon': Icons.volunteer_activism,
        'color': AppColors.primary,
        'trend': '+12%',
        'isPositive': true,
      },
      {
        'title': 'Requests Helped',
        'value': '28',
        'subtitle': 'This month',
        'icon': Icons.help_outline,
        'color': AppColors.secondary,
        'trend': '+5',
        'isPositive': true,
      },
      {
        'title': 'Impact Score',
        'value': '95',
        'subtitle': 'Community rating',
        'icon': Icons.star,
        'color': AppColors.warning,
        'trend': '+3',
        'isPositive': true,
      },
      {
        'title': 'Active Requests',
        'value': '12',
        'subtitle': 'Needs attention',
        'icon': Icons.notifications_active,
        'color': AppColors.accent,
        'trend': 'New',
        'isPositive': true,
      },
    ];

    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 4,
      spacing: 16,
      runSpacing: 16,
      children: stats
          .map(
            (stat) => StatCard(
              title: stat['title'] as String,
              value: stat['value'] as String,
              subtitle: stat['subtitle'] as String,
              icon: Icon(stat['icon'] as IconData),
              color: stat['color'] as Color,
              trend: stat['trend'] as String,
              isPositiveTrend: stat['isPositive'] as bool,
            ),
          )
          .toList(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'title': 'Browse Requests',
        'subtitle': 'Find people who need help',
        'icon': Icons.search,
        'color': AppColors.primary,
      },
      {
        'title': 'Create Request',
        'subtitle': 'Ask for help from community',
        'icon': Icons.add_circle,
        'color': AppColors.secondary,
      },
      {
        'title': 'View Donations',
        'subtitle': 'Track your giving history',
        'icon': Icons.history,
        'color': AppColors.accent,
      },
      {
        'title': 'Community Stories',
        'subtitle': 'See impact stories',
        'icon': Icons.article,
        'color': AppColors.warning,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ResponsiveGrid(
          mobileColumns: 1,
          tabletColumns: 2,
          desktopColumns: 4,
          spacing: 16,
          runSpacing: 16,
          children: actions
              .map(
                (action) => InfoCard(
                  title: action['title'] as String,
                  subtitle: action['subtitle'] as String,
                  icon: Icon(action['icon'] as IconData),
                  iconColor: action['color'] as Color,
                  onTap: () => _handleQuickAction(action['title'] as String),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context, bool isDarkMode) {
    final activities = [
      {
        'type': 'donation',
        'title': 'Donated to Sarah\'s Medical Fund',
        'amount': '\$150',
        'time': '2 hours ago',
        'status': 'completed',
      },
      {
        'type': 'request',
        'title': 'Your request for winter clothes was fulfilled',
        'amount': '',
        'time': '1 day ago',
        'status': 'fulfilled',
      },
      {
        'type': 'message',
        'title': 'Thank you message from Mike Johnson',
        'amount': '',
        'time': '2 days ago',
        'status': 'new',
      },
      {
        'type': 'donation',
        'title': 'Donated to Community Food Bank',
        'amount': '\$75',
        'time': '3 days ago',
        'status': 'completed',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomCard(
          variant: CardVariant.outlined,
          padding: EdgeInsets.zero,
          child: Column(
            children: activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              final isLast = index == activities.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getActivityColor(
                              activity['type'] as String,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getActivityIcon(activity['type'] as String),
                            color: _getActivityColor(
                              activity['type'] as String,
                            ),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity['title'] as String,
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                activity['time'] as String,
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDarkMode
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if ((activity['amount'] as String).isNotEmpty)
                          Text(
                            activity['amount'] as String,
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: isDarkMode
                          ? AppColors.darkBorder
                          : AppColors.border,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents(BuildContext context, bool isDarkMode) {
    final events = [
      {
        'title': 'Community Food Drive',
        'date': 'Tomorrow, 10:00 AM',
        'location': 'Central Community Center',
        'type': 'volunteer',
      },
      {
        'title': 'Winter Clothes Collection',
        'date': 'Dec 15, 2:00 PM',
        'location': 'Local Church',
        'type': 'donation',
      },
      {
        'title': 'Holiday Gift Wrapping',
        'date': 'Dec 20, 6:00 PM',
        'location': 'Community Hall',
        'type': 'volunteer',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Events',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            CustomButton(
              text: 'View Calendar',
              onPressed: () {},
              variant: ButtonVariant.outline,
              size: ButtonSize.medium,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: events
              .map(
                (event) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InfoCard(
                    title: event['title'] as String,
                    subtitle: '${event['date']} • ${event['location']}',
                    icon: Icon(_getEventIcon(event['type'] as String)),
                    iconColor: _getEventColor(event['type'] as String),
                    onTap: () => _handleEventTap(event['title'] as String),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.calendar_today, size: 20),
                        onPressed: () {},
                        tooltip: 'Add to Calendar',
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'donation':
        return AppColors.success;
      case 'request':
        return AppColors.primary;
      case 'message':
        return AppColors.info;
      default:
        return AppColors.secondary;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'donation':
        return Icons.volunteer_activism;
      case 'request':
        return Icons.help_outline;
      case 'message':
        return Icons.message;
      default:
        return Icons.event;
    }
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'volunteer':
        return AppColors.accent;
      case 'donation':
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'volunteer':
        return Icons.volunteer_activism;
      case 'donation':
        return Icons.card_giftcard;
      default:
        return Icons.event;
    }
  }

  void _handleQuickAction(String action) {
    // TODO: Implement navigation to specific pages
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action feature will be implemented soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleEventTap(String eventTitle) {
    // TODO: Implement event details view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening details for $eventTitle'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
