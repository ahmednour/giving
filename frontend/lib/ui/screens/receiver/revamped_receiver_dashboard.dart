import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/models/donation.dart';
import 'package:giving_bridge/services/donation_service.dart';
import 'package:giving_bridge/ui/widgets/donation_grid_card.dart';
import 'package:giving_bridge/ui/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:giving_bridge/ui/widgets/app_bar_notification_icon.dart';

class RevampedReceiverDashboard extends StatefulWidget {
  const RevampedReceiverDashboard({super.key});

  @override
  State<RevampedReceiverDashboard> createState() =>
      _RevampedReceiverDashboardState();
}

class _RevampedReceiverDashboardState extends State<RevampedReceiverDashboard> {
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDonations();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDonations({String? category, String? search}) async {
    context
        .read<DonationService>()
        .getDonations(status: 'AVAILABLE', category: category, search: search);
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _fetchDonations(category: category, search: _searchController.text);
  }

  void _onSearchChanged(String query) {
    _fetchDonations(category: _selectedCategory, search: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تصفح التبرعات'),
        actions: [
          const AppBarNotificationIcon(),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'الملف الشخصي',
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: Consumer<DonationService>(
              builder: (context, donationService, child) {
                if (donationService.isLoading &&
                    donationService.donations.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (donationService.donations.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildDonationsGrid(donationService.donations);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for donations...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _CategoryChip(
                  label: 'All',
                  isSelected: _selectedCategory == null,
                  onSelected: () => _onCategorySelected(null),
                ),
                ...DonationCategory.values.map((category) {
                  final categoryName = category.toString().split('.').last;
                  return _CategoryChip(
                    label: categoryName,
                    isSelected: _selectedCategory == categoryName,
                    onSelected: () => _onCategorySelected(categoryName),
                  );
                }),
              ],
            ),
          ),
        ],
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
            const Icon(Icons.search_off_outlined,
                size: 80, color: AppColors.lightTextDisabled),
            const SizedBox(height: 24),
            Text(
              'لا توجد تبرعات متاحة حالياً',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'يرجى التحقق مرة أخرى قريباً، قد تتم إضافة تبرعات جديدة.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationsGrid(List<Donation> donations) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: donations.length,
      itemBuilder: (context, index) {
        return DonationGridCard(donation: donations[index])
            .animate()
            .fade(delay: (100 * index).ms, duration: 500.ms)
            .slideY(begin: 0.5);
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => onSelected(),
        selectedColor: Theme.of(context).colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : null,
        ),
      ),
    );
  }
}
