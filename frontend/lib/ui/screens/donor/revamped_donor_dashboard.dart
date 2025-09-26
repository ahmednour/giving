import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/models/donation.dart';
import 'package:giving_bridge/services/donation_service.dart';
import 'package:giving_bridge/ui/screens/donor/donation_form.dart';
import 'package:giving_bridge/ui/widgets/primary_button.dart';
import 'package:giving_bridge/ui/theme/app_colors.dart';
import 'package:giving_bridge/ui/widgets/donation_list_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:giving_bridge/ui/widgets/app_bar_notification_icon.dart';

class RevampedDonorDashboard extends StatefulWidget {
  const RevampedDonorDashboard({super.key});

  @override
  State<RevampedDonorDashboard> createState() => _RevampedDonorDashboardState();
}

class _RevampedDonorDashboardState extends State<RevampedDonorDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonationService>().getMyDonations();
    });
  }

  void _showDonationForm({Donation? donation}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DonationForm(donation: donation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تبرعاتي'),
        actions: [
          const AppBarNotificationIcon(),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'الملف الشخصي',
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: Consumer<DonationService>(
        builder: (context, donationService, child) {
          if (donationService.isLoading &&
              donationService.myDonations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (donationService.myDonations.isEmpty) {
            return _buildEmptyState();
          }
          return _buildDonationsList(donationService.myDonations);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDonationForm(),
        tooltip: 'إضافة تبرع',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined,
                size: 80, color: AppColors.lightTextDisabled),
            const SizedBox(height: 24),
            Text(
              'لم تقم بأي تبرعات بعد',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'ابدأ بمشاركة العطاء. انقر على الزر أدناه لإضافة تبرعك الأول.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              onPressed: () => _showDonationForm(),
              text: 'إضافة تبرع جديد',
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationsList(List<Donation> donations) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: donations.length,
      itemBuilder: (context, index) {
        return DonationListCard(
          donation: donations[index],
          onEdit: () => _showDonationForm(donation: donations[index]),
        )
            .animate()
            .fade(delay: (100 * index).ms, duration: 500.ms)
            .slideY(begin: 0.5);
      },
    );
  }
}
