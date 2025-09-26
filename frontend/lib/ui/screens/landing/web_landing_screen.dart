import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:giving_bridge/l10n/app_localizations.dart';
import '../../widgets/web_navbar.dart';
import '../../widgets/web_button.dart';
import '../../widgets/web_card.dart';
import '../../widgets/web_container.dart';
import '../../theme/web_colors.dart';
import '../../theme/web_typography.dart';

class WebLandingScreen extends StatelessWidget {
  const WebLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: WebNavbar(
        title: 'Giving Bridge',
        items: [
          WebNavbarItem(
            label: 'الميزات',
            onTap: () {
              // Scroll to features section
            },
          ),
          WebNavbarItem(
            label: 'كيف يعمل',
            onTap: () {
              // Scroll to how it works section
            },
          ),
          WebNavbarItem(
            label: 'حول',
            onTap: () {
              // Scroll to about section
            },
          ),
        ],
        actions: [
          WebButton(
            text: l10n.login,
            variant: WebButtonVariant.ghost,
            onPressed: () => context.go('/login'),
          ),
          WebButton(
            text: l10n.register,
            variant: WebButtonVariant.primary,
            onPressed: () => context.go('/register'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context, l10n),
            _buildFeaturesSection(context, l10n),
            _buildHowItWorksSection(context, l10n),
            _buildStatsSection(context, l10n),
            _buildFooter(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isDark ? WebColors.darkBackground : WebColors.lightBackground,
            isDark
                ? WebColors.darkSecondary.withOpacity(0.3)
                : WebColors.lightAccent.withOpacity(0.3),
          ],
        ),
      ),
      child: WebContainer.content(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
        child: ResponsiveRow(
          breakpoint: 768,
          children: [
            Expanded(
              flex: context.isDesktop ? 1 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'جسر العطاء',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: isDark
                          ? WebColors.darkForeground
                          : WebColors.lightForeground,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'منصة تربط المتبرعين والمحتاجين لنشر الخير في المجتمع',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: isDark
                          ? WebColors.darkMutedForeground
                          : WebColors.lightMutedForeground,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'انضم إلى مجتمعنا من المتبرعين والمحتاجين واصنع فرقاً في حياة الآخرين. منصة آمنة وسهلة الاستخدام لتبادل العطاء.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? WebColors.darkMutedForeground
                          : WebColors.lightMutedForeground,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ResponsiveRow(
                    breakpoint: 480,
                    spacing: 16,
                    children: [
                      WebButton(
                        text: 'ابدأ التبرع',
                        variant: WebButtonVariant.primary,
                        size: WebButtonSize.large,
                        icon: Icons.favorite,
                        onPressed: () => context.go('/register'),
                      ),
                      WebButton(
                        text: 'تصفح التبرعات',
                        variant: WebButtonVariant.outline,
                        size: WebButtonSize.large,
                        icon: Icons.search,
                        onPressed: () => context.go('/register'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (context.isDesktop) ...[
              const SizedBox(width: 80),
              Expanded(
                flex: 1,
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        isDark ? WebColors.darkPrimary : WebColors.lightPrimary,
                        isDark
                            ? WebColors.darkPrimary.withOpacity(0.7)
                            : WebColors.lightPrimary.withOpacity(0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark
                                ? WebColors.darkPrimary
                                : WebColors.lightPrimary)
                            .withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.favorite,
                      size: 120,
                      color: isDark
                          ? WebColors.darkPrimaryForeground
                          : WebColors.lightPrimaryForeground,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final features = [
      {
        'icon': Icons.security,
        'title': 'آمن وموثوق',
        'description':
            'نظام آمان متقدم لحماية بياناتك وضمان وصول التبرعات للمستحقين',
      },
      {
        'icon': Icons.speed,
        'title': 'سريع وسهل',
        'description':
            'واجهة مستخدم بسيطة تمكنك من التبرع أو طلب المساعدة في دقائق',
      },
      {
        'icon': Icons.people,
        'title': 'مجتمع متصل',
        'description':
            'ربط المتبرعين والمحتاجين في مجتمع واحد يساعد بعضه البعض',
      },
      {
        'icon': Icons.verified,
        'title': 'شفافية كاملة',
        'description':
            'تتبع التبرعات والطلبات بشفافية كاملة لضمان وصولها للمستحقين',
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      color: isDark ? WebColors.darkBackground : WebColors.lightBackground,
      child: WebContainer.content(
        child: Column(
          children: [
            Text(
              'لماذا تختار جسر العطاء؟',
              style: theme.textTheme.displayMedium?.copyWith(
                color: isDark
                    ? WebColors.darkForeground
                    : WebColors.lightForeground,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'منصة شاملة تجمع بين الأمان والسهولة والشفافية',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? WebColors.darkMutedForeground
                    : WebColors.lightMutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            ResponsiveGrid(
              itemMinWidth: 280,
              maxCrossAxisCount: 2,
              childAspectRatio: 1.2,
              children: features.map((feature) {
                return WebCard(
                  isHoverable: true,
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: (isDark
                                  ? WebColors.darkPrimary
                                  : WebColors.lightPrimary)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          feature['icon'] as IconData,
                          size: 32,
                          color: isDark
                              ? WebColors.darkPrimary
                              : WebColors.lightPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        feature['title'] as String,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        feature['description'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? WebColors.darkMutedForeground
                              : WebColors.lightMutedForeground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final steps = [
      {
        'number': '1',
        'title': 'انشئ حسابك',
        'description': 'سجل في المنصة واختر نوع حسابك (متبرع أو محتاج)',
      },
      {
        'number': '2',
        'title': 'تصفح أو أضف',
        'description': 'تصفح التبرعات المتاحة أو أضف تبرعك الجديد',
      },
      {
        'number': '3',
        'title': 'تواصل وساعد',
        'description': 'تواصل مع الطرف الآخر وأكمل عملية التبرع',
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        color: isDark
            ? WebColors.darkSecondary.withOpacity(0.3)
            : WebColors.lightAccent.withOpacity(0.3),
      ),
      child: WebContainer.content(
        child: Column(
          children: [
            Text(
              'كيف يعمل جسر العطاء؟',
              style: theme.textTheme.displayMedium?.copyWith(
                color: isDark
                    ? WebColors.darkForeground
                    : WebColors.lightForeground,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'ثلاث خطوات بسيطة للمشاركة في العطاء',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? WebColors.darkMutedForeground
                    : WebColors.lightMutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            ResponsiveRow(
              spacing: 40,
              children: steps.map((step) {
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              isDark
                                  ? WebColors.darkPrimary
                                  : WebColors.lightPrimary,
                              isDark
                                  ? WebColors.darkPrimary.withOpacity(0.8)
                                  : WebColors.lightPrimary.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (isDark
                                      ? WebColors.darkPrimary
                                      : WebColors.lightPrimary)
                                  .withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            step['number'] as String,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: isDark
                                  ? WebColors.darkPrimaryForeground
                                  : WebColors.lightPrimaryForeground,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        step['title'] as String,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        step['description'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? WebColors.darkMutedForeground
                              : WebColors.lightMutedForeground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final stats = [
      {'number': '1000+', 'label': 'متبرع نشط'},
      {'number': '5000+', 'label': 'عملية تبرع'},
      {'number': '500+', 'label': 'أسرة استفادت'},
      {'number': '50+', 'label': 'مدينة مغطاة'},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isDark ? WebColors.darkPrimary : WebColors.lightPrimary,
            isDark
                ? WebColors.darkPrimary.withOpacity(0.8)
                : WebColors.lightPrimary.withOpacity(0.8),
          ],
        ),
      ),
      child: WebContainer.content(
        child: Column(
          children: [
            Text(
              'تأثيرنا في المجتمع',
              style: theme.textTheme.displayMedium?.copyWith(
                color: isDark
                    ? WebColors.darkPrimaryForeground
                    : WebColors.lightPrimaryForeground,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            ResponsiveRow(
              spacing: 40,
              children: stats.map((stat) {
                return Expanded(
                  child: Column(
                    children: [
                      Text(
                        stat['number'] as String,
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: isDark
                              ? WebColors.darkPrimaryForeground
                              : WebColors.lightPrimaryForeground,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stat['label'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: (isDark
                                  ? WebColors.darkPrimaryForeground
                                  : WebColors.lightPrimaryForeground)
                              .withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64),
      decoration: BoxDecoration(
        color: isDark ? WebColors.darkSecondary : WebColors.lightMuted,
        border: Border(
          top: BorderSide(
            color: isDark ? WebColors.darkBorder : WebColors.lightBorder,
          ),
        ),
      ),
      child: WebContainer.content(
        child: Column(
          children: [
            ResponsiveRow(
              spacing: 60,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
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
                          Text(
                            'جسر العطاء',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'منصة تربط المتبرعين والمحتاجين لنشر الخير في المجتمع. نسعى لبناء جسر من العطاء يصل بين قلوب المحبين للخير.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? WebColors.darkMutedForeground
                              : WebColors.lightMutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'روابط مهمة',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FooterLink(text: 'حول المنصة', onTap: () {}),
                      _FooterLink(text: 'كيف يعمل', onTap: () {}),
                      _FooterLink(text: 'الأسئلة الشائعة', onTap: () {}),
                      _FooterLink(text: 'اتصل بنا', onTap: () {}),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الحساب',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FooterLink(
                        text: 'تسجيل الدخول',
                        onTap: () => context.go('/login'),
                      ),
                      _FooterLink(
                        text: 'إنشاء حساب',
                        onTap: () => context.go('/register'),
                      ),
                      _FooterLink(text: 'سياسة الخصوصية', onTap: () {}),
                      _FooterLink(text: 'شروط الاستخدام', onTap: () {}),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            Container(
              height: 1,
              width: double.infinity,
              color: isDark ? WebColors.darkBorder : WebColors.lightBorder,
            ),
            const SizedBox(height: 24),
            Text(
              '© 2024 جسر العطاء. جميع الحقوق محفوظة.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? WebColors.darkMutedForeground
                    : WebColors.lightMutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink({
    required this.text,
    required this.onTap,
  });

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: theme.textTheme.bodyMedium!.copyWith(
              color: _isHovered
                  ? (isDark ? WebColors.darkPrimary : WebColors.lightPrimary)
                  : (isDark
                      ? WebColors.darkMutedForeground
                      : WebColors.lightMutedForeground),
            ),
            child: Text(widget.text),
          ),
        ),
      ),
    );
  }
}
