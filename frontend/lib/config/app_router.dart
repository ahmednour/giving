import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../pages/landing_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/error_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Landing Page
      GoRoute(
        path: '/',
        name: 'landing',
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const LandingPage()),
      ),

      // Authentication Routes
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const LoginPage()),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const RegisterPage()),
      ),

      // Protected Routes
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const DashboardPage()),
        redirect: (context, state) => _authGuard(context),
      ),

      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const SettingsPage()),
        redirect: (context, state) => _authGuard(context),
      ),

      // Error Route
      GoRoute(
        path: '/error',
        name: 'error',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          ErrorPage(
            error: state.extra as String? ?? 'An unknown error occurred',
          ),
        ),
      ),
    ],

    // Global error handler
    errorPageBuilder: (context, state) => _buildPageWithTransition(
      context,
      state,
      ErrorPage(error: 'Page not found: ${state.uri.path}', statusCode: 404),
    ),

    // Global redirect logic
    redirect: (context, state) {
      final authProvider = context.read<AuthProvider>();
      final isAuthenticated = authProvider.isAuthenticated;
      final isAuthRoute =
          state.uri.path.startsWith('/login') ||
          state.uri.path.startsWith('/register');
      final isLandingRoute = state.uri.path == '/';

      // If user is authenticated and trying to access auth pages, redirect to dashboard
      if (isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }

      // If user is not authenticated and trying to access protected routes
      if (!isAuthenticated &&
          !isAuthRoute &&
          !isLandingRoute &&
          state.uri.path != '/error') {
        return '/login';
      }

      return null; // No redirect needed
    },
  );

  // Auth guard for protected routes
  static String? _authGuard(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return authProvider.isAuthenticated ? null : '/login';
  }

  // Page transition builder
  static Page<void> _buildPageWithTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(0.0, 0.02),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOut)),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

// Navigation helper methods
class AppNavigation {
  static void goToLanding(BuildContext context) {
    GoRouter.of(context).goNamed('landing');
  }

  static void goToLogin(BuildContext context) {
    GoRouter.of(context).goNamed('login');
  }

  static void goToRegister(BuildContext context) {
    GoRouter.of(context).goNamed('register');
  }

  static void goToDashboard(BuildContext context) {
    GoRouter.of(context).goNamed('dashboard');
  }

  static void goToSettings(BuildContext context) {
    GoRouter.of(context).goNamed('settings');
  }

  static void goBack(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    } else {
      GoRouter.of(context).goNamed('landing');
    }
  }

  static void pushToLogin(BuildContext context) {
    GoRouter.of(context).pushNamed('login');
  }

  static void pushToRegister(BuildContext context) {
    GoRouter.of(context).pushNamed('register');
  }

  static void replaceWithDashboard(BuildContext context) {
    GoRouter.of(context).pushReplacementNamed('dashboard');
  }

  static void replaceWithLogin(BuildContext context) {
    GoRouter.of(context).pushReplacementNamed('login');
  }
}
