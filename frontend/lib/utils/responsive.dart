import 'package:flutter/material.dart';

class ResponsiveBreakpoints {
  static const double mobile = 450;
  static const double tablet = 800;
  static const double desktop = 1200;
  static const double ultraWide = 1920;
}

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < ResponsiveBreakpoints.mobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.mobile &&
      MediaQuery.of(context).size.width < ResponsiveBreakpoints.desktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.desktop;

  static bool isUltraWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveBreakpoints.ultraWide;

  // Helper methods for specific layout decisions
  static bool showSidebar(BuildContext context) => isDesktop(context);

  static bool showBottomNavigation(BuildContext context) => isMobile(context);

  static bool showDrawer(BuildContext context) => !isDesktop(context);

  // Responsive values
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? ultraWide,
  }) {
    if (isUltraWide(context) && ultraWide != null) return ultraWide;
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  // Responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: responsiveValue(
        context,
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
        ultraWide: 48.0,
      ),
      vertical: 16.0,
    );
  }

  // Responsive margin
  static EdgeInsets responsiveMargin(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: responsiveValue(
        context,
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
        ultraWide: 64.0,
      ),
    );
  }

  // Container max width for content
  static double maxContentWidth(BuildContext context) {
    return responsiveValue(
      context,
      mobile: double.infinity,
      tablet: 768.0,
      desktop: 1200.0,
      ultraWide: 1400.0,
    );
  }

  // Grid columns
  static int gridColumns(BuildContext context) {
    return responsiveValue(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
      ultraWide: 4,
    );
  }

  // Card width
  static double cardWidth(BuildContext context) {
    return responsiveValue(
      context,
      mobile: double.infinity,
      tablet: 350.0,
      desktop: 320.0,
      ultraWide: 400.0,
    );
  }

  // Sidebar width
  static double sidebarWidth(BuildContext context) {
    return responsiveValue(
      context,
      mobile: 280.0,
      tablet: 300.0,
      desktop: 280.0,
      ultraWide: 320.0,
    );
  }

  // App bar height
  static double appBarHeight(BuildContext context) {
    return responsiveValue(context, mobile: 56.0, tablet: 64.0, desktop: 72.0);
  }

  // Text scaling
  static double textScale(BuildContext context) {
    return responsiveValue(
      context,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.0,
      ultraWide: 1.1,
    );
  }

  // Button height
  static double buttonHeight(BuildContext context) {
    return responsiveValue(context, mobile: 48.0, tablet: 52.0, desktop: 48.0);
  }

  // Form field spacing
  static double formFieldSpacing(BuildContext context) {
    return responsiveValue(context, mobile: 16.0, tablet: 20.0, desktop: 24.0);
  }
}

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? ultraWide;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.ultraWide,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive.responsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      ultraWide: ultraWide,
    );
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => builder(context, constraints),
    );
  }
}

// Responsive Grid
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double? childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.responsiveValue(
      context,
      mobile: mobileColumns ?? 1,
      tablet: tabletColumns ?? 2,
      desktop: desktopColumns ?? 3,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: childAspectRatio ?? 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

// Responsive Wrap
class ResponsiveWrap extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;

  const ResponsiveWrap({
    super.key,
    required this.children,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}
