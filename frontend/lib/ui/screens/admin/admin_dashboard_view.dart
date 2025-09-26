import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/services/donation_service.dart';
import 'package:giving_bridge/services/request_service.dart';
import 'package:giving_bridge/ui/theme/app_colors.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  Map<String, dynamic>? _donationStats;
  Map<String, dynamic>? _requestStats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() => _isLoading = true);
    final donationService = context.read<DonationService>();
    final requestService = context.read<RequestService>();

    final donationStats = await donationService.getDonationStats();
    final requestStats = await requestService.getRequestStats();

    if (mounted) {
      setState(() {
        _donationStats = donationStats;
        _requestStats = requestStats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchStats,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildStatsGrid(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsGrid() {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        _StatCard(
          icon: Icons.people_alt_outlined,
          label: 'Total Users',
          value: _donationStats?['totalUsers']?.toString() ?? 'N/A',
          color: Colors.blue,
        ),
        _StatCard(
          icon: Icons.volunteer_activism_outlined,
          label: 'Total Donations',
          value: _donationStats?['totalDonations']?.toString() ?? 'N/A',
          color: Colors.green,
        ),
        _StatCard(
          icon: Icons.hourglass_top_outlined,
          label: 'Pending Requests',
          value: _requestStats?['pendingRequests']?.toString() ?? 'N/A',
          color: Colors.orange,
        ),
        _StatCard(
          icon: Icons.check_circle_outline,
          label: 'Completed Donations',
          value: _donationStats?['completedDonations']?.toString() ?? 'N/A',
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: AppColors.lightTextSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
