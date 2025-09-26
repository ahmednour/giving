import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/models/donation.dart';
import 'package:giving_bridge/models/request.dart';
import 'package:giving_bridge/services/request_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:giving_bridge/ui/widgets/primary_button.dart';
import 'package:giving_bridge/ui/theme/app_colors.dart';

class DonationDetailScreen extends StatelessWidget {
  final Donation donation;
  const DonationDetailScreen({super.key, required this.donation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(donation.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: "http://localhost:8000${donation.imageUrl}",
              fit: BoxFit.cover,
              width: double.infinity,
              height: size.height * 0.4,
              placeholder: (context, url) => Container(
                height: size.height * 0.4,
                color: AppColors.lightBorder,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                height: size.height * 0.4,
                color: AppColors.lightBorder,
                child: const Icon(Icons.error_outline,
                    color: AppColors.lightTextSecondary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donation.category.name.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(donation.title, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Text(
                    donation.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Here you can add donor info if available
                  // For example:
                  // _buildDonorInfo(context, donation.donor),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          onPressed: () async {
            final success = await context
                .read<RequestService>()
                .createRequest(CreateRequestRequest(donationId: donation.id));
            if (context.mounted) {
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('تم إرسال طلبك بنجاح!'),
                  backgroundColor: AppColors.success,
                ));
                // Optionally pop or navigate away
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(context.read<RequestService>().error ??
                      'فشل إرسال الطلب.'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ));
              }
            }
          },
          text: 'طلب هذا التبرع',
          icon: const Icon(Icons.favorite_border),
        ),
      ),
    );
  }
}
