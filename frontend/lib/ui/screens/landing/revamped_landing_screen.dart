import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import '../../widgets/primary_button.dart';

class RevampedLandingScreen extends StatelessWidget {
  const RevampedLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          _SliverAppBar(),
          SliverToBoxAdapter(child: _HeroSection()),
          SliverToBoxAdapter(child: _FeaturesSection()),
          SliverToBoxAdapter(child: _HowItWorksSection()),
          SliverToBoxAdapter(child: _Footer()),
        ],
      ),
    );
  }
}

class _SliverAppBar extends StatelessWidget {
  const _SliverAppBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: false,
      backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      title: Row(
        children: [
          const Icon(Icons.favorite_border, color: AppColors.primary),
          const SizedBox(width: 8),
          Text('Giving Bridge', style: theme.textTheme.titleLarge),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.go('/login'),
          child: const Text('تسجيل الدخول'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => context.go('/register'),
          child: const Text('إنشاء حساب'),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 24, vertical: size.height * 0.15),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Text(
                'جسر العطاء: نصل بين من يريد العطاء بمن يحتاج إليه',
                style: size.width > 600
                    ? textTheme.displayMedium
                    : textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'منصة سهلة وآمنة تمكنك من التبرع بالأشياء التي لم تعد بحاجتها، أو طلب المساعدة من مجتمعك.',
                style: textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                onPressed: () => context.go('/register'),
                text: 'ابدأ الآن',
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'لماذا تختار جسر العطاء؟',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'نحن نؤمن بقوة المجتمع في إحداث التغيير الإيجابي.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              const Wrap(
                spacing: 40,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: [
                  _FeatureCard(
                    icon: Icons.volunteer_activism_outlined,
                    title: 'سهولة التبرع',
                    description:
                        'تبرع بأغراضك ببضع نقرات فقط، وساهم في مساعدة الآخرين.',
                  ),
                  _FeatureCard(
                    icon: Icons.search_outlined,
                    title: 'إيجاد المساعدة',
                    description:
                        'ابحث عن الأغراض التي تحتاجها واحصل عليها بسهولة من مجتمعك.',
                  ),
                  _FeatureCard(
                    icon: Icons.security_outlined,
                    title: 'آمن وموثوق',
                    description:
                        'بيئة آمنة تضمن وصول تبرعاتك للمحتاجين الفعليين.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Icon(icon, size: 32, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 24),
          Text(title,
              style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'كيف يعمل؟',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Wrap(
                spacing: 40,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: [
                  _StepCard(
                    step: '1',
                    title: 'أنشئ حسابك',
                    description: 'سجل كمتبرع أو مستقبل للمساعدة في دقائق.',
                    color: AppColors.primary,
                  ),
                  _StepCard(
                    step: '2',
                    title: 'اعرض أو اطلب',
                    description:
                        'اعرض تبرعاتك أو ابحث عن ما تحتاجه من الأغراض.',
                    color: AppColors.accent,
                  ),
                  _StepCard(
                    step: '3',
                    title: 'تواصل وتوصيل',
                    description:
                        'تواصل بشكل آمن لترتيب عملية التسليم والاستلام.',
                    color: AppColors.success,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final String title;
  final String description;
  final Color color;

  const _StepCard({
    required this.step,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: color.withOpacity(0.1),
            child: Text(step,
                style: theme.textTheme.headlineMedium?.copyWith(color: color)),
          ),
          const SizedBox(height: 24),
          Text(title,
              style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      color: theme.colorScheme.surface,
      child: Center(
        child: Text(
          '© 2025 Giving Bridge. جميع الحقوق محفوظة.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
