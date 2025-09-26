import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'l10n/app_localizations.dart';

import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'services/donation_service.dart';
import 'services/request_service.dart';
import 'services/notification_service.dart';
import 'providers/theme_provider.dart';
import 'ui/theme/app_theme.dart';

// Screens
import 'ui/screens/auth/web_login_screen.dart';
import 'ui/screens/auth/revamped_register_screen.dart';
import 'ui/screens/landing/web_landing_screen.dart';
import 'ui/screens/donor/revamped_donor_dashboard.dart';
import 'ui/screens/receiver/revamped_receiver_dashboard.dart';
import 'ui/screens/receiver/donation_detail_screen.dart';
import 'package:giving_bridge/models/donation.dart';
import 'ui/screens/admin/admin_screen.dart';
import 'services/admin_service.dart';
import 'ui/screens/profile/revamped_profile_screen.dart';
import 'ui/screens/notifications/revamped_notifications_screen.dart';
import 'ui/screens/profile/my_donations_screen.dart';
import 'ui/screens/profile/my_requests_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services and providers
  final apiService = ApiService();
  final authService = AuthService(apiService);
  final notificationService = NotificationService(apiService);

  // Provide NotificationService to AuthService
  authService.setNotificationService(notificationService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DonationService(apiService)),
        ChangeNotifierProvider(create: (_) => RequestService(apiService)),
        ChangeNotifierProvider(create: (_) => AdminService(apiService)),
        ChangeNotifierProvider.value(value: notificationService),
      ],
      child: const GivingBridgeApp(),
    ),
  );
}

class GivingBridgeApp extends StatelessWidget {
  const GivingBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      title: 'Giving Bridge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: const Locale('ar', ''),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // Arabic
        Locale('en', ''), // English
      ],
      routerConfig:
          _createRouter(Provider.of<AuthService>(context, listen: false)),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox(),
        );
      },
    );
  }

  GoRouter _createRouter(AuthService authService) {
    return GoRouter(
      refreshListenable: authService,
      initialLocation: authService.isAuthenticated ? '/home' : '/landing',
      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = authService.isAuthenticated;
        final bool loggingIn = state.uri.toString() == '/login' ||
            state.uri.toString() == '/register' ||
            state.uri.toString() == '/landing';

        if (!loggedIn && !loggingIn) {
          return '/landing';
        }
        if (loggedIn && loggingIn) {
          return '/home';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/landing',
          builder: (context, state) => const WebLandingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const WebLoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RevampedRegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) {
            final userRole = authService.currentUser?.role;
            if (userRole == 'DONOR') {
              return const RevampedDonorDashboard();
            } else if (userRole == 'RECEIVER') {
              return const RevampedReceiverDashboard();
            } else if (userRole == 'ADMIN') {
              return const AdminScreen();
            }
            return const WebLandingScreen(); // Fallback
          },
        ),
        GoRoute(
          path: '/donations/:id',
          builder: (context, state) {
            final donation = state.extra as Donation?;
            if (donation != null) {
              return DonationDetailScreen(donation: donation);
            }
            return const SizedBox.shrink(); // Or a proper error screen
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const RevampedProfileScreen(),
        ),
        GoRoute(
          path: '/my-donations',
          builder: (context, state) => const MyDonationsScreen(),
        ),
        GoRoute(
          path: '/my-requests',
          builder: (context, state) => const MyRequestsScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const RevampedNotificationsScreen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminScreen(),
        ),
      ],
    );
  }
}
