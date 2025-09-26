import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/responsive.dart';
import '../components/navigation/navbar.dart';
import '../components/buttons/custom_button.dart';
import '../components/common/custom_card.dart';
import '../providers/auth_provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideAnimationController,
            curve: Curves.easeOut,
          ),
        );

    // Start animations
    _fadeAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: const AppNavbar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildHeroSection(context, authProvider),
            _buildFeaturesSection(context),
            _buildStatsSection(context),
            _buildTestimonialsSection(context),
            _buildCTASection(context, authProvider),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, AuthProvider authProvider) {
    return Container(
      height: Responsive.responsiveValue(
        context,
        mobile: 600,
        tablet: 700,
        desktop: 800,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1559526324-593bc073d938?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Content
          Positioned.fill(
            child: Container(
              padding: Responsive.responsivePadding(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: Responsive.responsiveValue(
                                context,
                                mobile: double.infinity,
                                tablet: 600,
                                desktop: 800,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Bridge the Gap Between\nGenerosity and Need',
                                  style:
                                      Responsive.responsiveValue(
                                        context,
                                        mobile: AppTypography.displaySmall,
                                        tablet: AppTypography.displayMedium,
                                        desktop: AppTypography.displayLarge,
                                      ).copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        height: 1.1,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Connect donors with those in need through our secure, transparent platform. Make a difference in your community with verified requests and direct impact tracking.',
                                  style:
                                      Responsive.responsiveValue(
                                        context,
                                        mobile: AppTypography.bodyLarge,
                                        tablet: AppTypography.titleMedium,
                                        desktop: AppTypography.titleLarge,
                                      ).copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.5,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                ResponsiveWidget(
                                  mobile: Column(
                                    children: [
                                      CustomButton(
                                        text: authProvider.isAuthenticated
                                            ? 'Go to Dashboard'
                                            : 'Start Giving Today',
                                        onPressed: () {
                                          if (authProvider.isAuthenticated) {
                                            context.goNamed('dashboard');
                                          } else {
                                            context.pushNamed('register');
                                          }
                                        },
                                        size: ButtonSize.large,
                                        isFullWidth: true,
                                      ),
                                      const SizedBox(height: 16),
                                      CustomButton(
                                        text: 'Learn More',
                                        onPressed: () => _scrollToFeatures(),
                                        variant: ButtonVariant.outline,
                                        size: ButtonSize.large,
                                        isFullWidth: true,
                                      ),
                                    ],
                                  ),
                                  tablet: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomButton(
                                        text: authProvider.isAuthenticated
                                            ? 'Go to Dashboard'
                                            : 'Start Giving Today',
                                        onPressed: () {
                                          if (authProvider.isAuthenticated) {
                                            context.goNamed('dashboard');
                                          } else {
                                            context.pushNamed('register');
                                          }
                                        },
                                        size: ButtonSize.large,
                                        icon: const Icon(Icons.favorite),
                                      ),
                                      const SizedBox(width: 16),
                                      CustomButton(
                                        text: 'Learn More',
                                        onPressed: () => _scrollToFeatures(),
                                        variant: ButtonVariant.outline,
                                        size: ButtonSize.large,
                                        icon: const Icon(Icons.info_outline),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      {
        'icon': Icons.verified_user,
        'title': 'Verified Requests',
        'description':
            'All donation requests are thoroughly verified to ensure authenticity and legitimate need.',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.track_changes,
        'title': 'Impact Tracking',
        'description':
            'See exactly how your donations are making a difference with real-time updates and photos.',
        'color': AppColors.secondary,
      },
      {
        'icon': Icons.security,
        'title': 'Secure Platform',
        'description':
            'Bank-level security protects your donations and personal information at every step.',
        'color': AppColors.accent,
      },
      {
        'icon': Icons.group,
        'title': 'Community Driven',
        'description':
            'Connect with your local community and build lasting relationships through giving.',
        'color': AppColors.warning,
      },
      {
        'icon': Icons.mobile_friendly,
        'title': 'Easy to Use',
        'description':
            'Intuitive design makes it simple to give, request, and track donations from any device.',
        'color': AppColors.info,
      },
      {
        'icon': Icons.trending_up,
        'title': 'Growing Impact',
        'description':
            'Join thousands of users who have already made a difference in their communities.',
        'color': AppColors.success,
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: Responsive.responsiveValue(
          context,
          mobile: 16,
          tablet: 32,
          desktop: 64,
        ),
      ),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                Text(
                  'Why Choose Giving Bridge?',
                  style: Responsive.responsiveValue(
                    context,
                    mobile: AppTypography.headlineMedium,
                    desktop: AppTypography.headlineLarge,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Our platform provides everything you need to make meaningful connections and create positive impact in your community.',
                  style: AppTypography.titleMedium.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                ResponsiveGrid(
                  mobileColumns: 1,
                  tabletColumns: 2,
                  desktopColumns: 3,
                  spacing: 24,
                  runSpacing: 24,
                  children: features
                      .map(
                        (feature) => _buildFeatureCard(
                          context,
                          feature['icon'] as IconData,
                          feature['title'] as String,
                          feature['description'] as String,
                          feature['color'] as Color,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return CustomCard(
      variant: CardVariant.outlined,
      isClickable: true,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final stats = [
      {'value': '10,000+', 'label': 'Donations Made'},
      {'value': '\$2.5M+', 'label': 'Total Donated'},
      {'value': '5,000+', 'label': 'Lives Impacted'},
      {'value': '150+', 'label': 'Communities Served'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurfaceVariant
            : AppColors.surfaceVariant,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: Responsive.responsivePadding(context),
        child: ResponsiveGrid(
          mobileColumns: 2,
          tabletColumns: 4,
          desktopColumns: 4,
          spacing: 32,
          runSpacing: 32,
          children: stats
              .map(
                (stat) => Column(
                  children: [
                    Text(
                      stat['value']!,
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stat['label']!,
                      style: AppTypography.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context) {
    final testimonials = [
      {
        'name': 'Sarah Johnson',
        'role': 'Community Volunteer',
        'quote':
            'Giving Bridge made it so easy to help families in my neighborhood. The verification process gives me confidence that my donations are making a real difference.',
        'avatar':
            'https://images.unsplash.com/photo-1494790108755-2616b612b169?w=150&h=150&fit=crop&crop=face',
      },
      {
        'name': 'Michael Chen',
        'role': 'Regular Donor',
        'quote':
            'I love being able to track the impact of my donations. Seeing the thank you messages and photos from recipients makes giving so much more meaningful.',
        'avatar':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      },
      {
        'name': 'Emily Rodriguez',
        'role': 'Grateful Recipient',
        'quote':
            'When our family was struggling, Giving Bridge connected us with amazing people who helped us get back on our feet. Forever grateful for this platform.',
        'avatar':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: Responsive.responsiveValue(
          context,
          mobile: 16,
          tablet: 32,
          desktop: 64,
        ),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'What Our Community Says',
              style: Responsive.responsiveValue(
                context,
                mobile: AppTypography.headlineMedium,
                desktop: AppTypography.headlineLarge,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            ResponsiveGrid(
              mobileColumns: 1,
              tabletColumns: 2,
              desktopColumns: 3,
              spacing: 24,
              runSpacing: 24,
              children: testimonials
                  .map(
                    (testimonial) => CustomCard(
                      variant: CardVariant.outlined,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              testimonial['avatar']!,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '"${testimonial['quote']!}"',
                            style: AppTypography.bodyLarge.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            testimonial['name']!,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            testimonial['role']!,
                            style: AppTypography.bodyMedium.copyWith(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTASection(BuildContext context, AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: Responsive.responsivePadding(context),
        child: Column(
          children: [
            Text(
              'Ready to Make a Difference?',
              style: Responsive.responsiveValue(
                context,
                mobile: AppTypography.headlineMedium,
                desktop: AppTypography.headlineLarge,
              ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Join our community of givers and make an impact in your neighborhood today.',
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ResponsiveWidget(
              mobile: Column(
                children: [
                  CustomButton(
                    text: authProvider.isAuthenticated
                        ? 'Go to Dashboard'
                        : 'Get Started Now',
                    onPressed: () {
                      if (authProvider.isAuthenticated) {
                        context.goNamed('dashboard');
                      } else {
                        context.pushNamed('register');
                      }
                    },
                    variant: ButtonVariant.secondary,
                    size: ButtonSize.large,
                    isFullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  if (!authProvider.isAuthenticated)
                    TextButton(
                      onPressed: () => context.pushNamed('login'),
                      child: Text(
                        'Already have an account? Sign in',
                        style: AppTypography.labelLarge.copyWith(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
              desktop: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: authProvider.isAuthenticated
                        ? 'Go to Dashboard'
                        : 'Get Started Now',
                    onPressed: () {
                      if (authProvider.isAuthenticated) {
                        context.goNamed('dashboard');
                      } else {
                        context.pushNamed('register');
                      }
                    },
                    variant: ButtonVariant.secondary,
                    size: ButtonSize.large,
                  ),
                  if (!authProvider.isAuthenticated) ...[
                    const SizedBox(width: 24),
                    TextButton(
                      onPressed: () => context.pushNamed('login'),
                      child: Text(
                        'Already have an account? Sign in',
                        style: AppTypography.labelLarge.copyWith(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.surfaceVariant,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkBorder
                : AppColors.border,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Giving Bridge',
                style: AppTypography.titleMedium.copyWith(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© 2024 Giving Bridge. All rights reserved.',
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToFeatures() {
    _scrollController.animateTo(
      600, // Hero section height
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }
}
