import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/models/donation.dart';
import 'package:giving_bridge/services/donation_service.dart';
import 'package:giving_bridge/ui/widgets/donation_list_card.dart';

class MyDonationsScreen extends StatefulWidget {
  const MyDonationsScreen({super.key});

  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonationService>().getMyDonations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final donationService = context.watch<DonationService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Donations'),
      ),
      body: donationService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : donationService.myDonations.isEmpty
              ? const Center(
                  child: Text('You have not made any donations yet.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: donationService.myDonations.length,
                  itemBuilder: (context, index) {
                    final donation = donationService.myDonations[index];
                    return DonationListCard(
                      donation: donation,
                      onEdit: () {
                        // Note: Edit functionality might need to be passed down or handled differently
                      },
                    );
                  },
                ),
    );
  }
}
