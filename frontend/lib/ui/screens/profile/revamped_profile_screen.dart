import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/services/auth_service.dart';
import 'package:giving_bridge/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

class RevampedProfileScreen extends StatelessWidget {
  const RevampedProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
      ),
      body: user == null
          ? const Center(child: Text('User not found.'))
          : ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                _buildProfileHeader(user.name, user.email, theme),
                const SizedBox(height: 32),
                _buildSectionTitle('Activity', theme),
                const SizedBox(height: 16),
                if (user.isDonor)
                  _buildActivityCard(
                      'My Donations',
                      Icons.volunteer_activism_outlined,
                      () => context.go('/my-donations'),
                      theme),
                if (user.isReceiver) ...[
                  const SizedBox(height: 12),
                  _buildActivityCard('My Requests', Icons.redeem_outlined,
                      () => context.go('/my-requests'), theme),
                ],
                const SizedBox(height: 32),
                _buildSectionTitle('Settings', theme),
                const SizedBox(height: 16),
                _buildThemeSwitcher(context),
                const Divider(height: 32),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    await context.read<AuthService>().logout();
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildProfileHeader(String name, String email, ThemeData theme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'G',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(name, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(email, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        color: theme.textTheme.bodySmall?.color,
      ),
    );
  }

  Widget _buildActivityCard(
      String title, IconData icon, VoidCallback onTap, ThemeData theme) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildThemeSwitcher(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Theme'),
            DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark'),
                ),
              ],
              onChanged: (ThemeMode? newMode) {
                if (newMode != null) {
                  context.read<ThemeProvider>().setThemeMode(newMode);
                }
              },
              underline: const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
