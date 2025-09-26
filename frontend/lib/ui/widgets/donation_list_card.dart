import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/models/donation.dart';
import 'package:giving_bridge/services/donation_service.dart';
import 'package:giving_bridge/ui/theme/app_colors.dart';

class DonationListCard extends StatelessWidget {
  final Donation donation;
  final VoidCallback onEdit;
  const DonationListCard(
      {super.key, required this.donation, required this.onEdit});

  Future<void> _deleteDonation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this donation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success =
          await context.read<DonationService>().deleteDonation(donation.id);
      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.read<DonationService>().error ??
                'Failed to delete donation.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(donation.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              donation.description,
              style: theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                StatusChip(status: donation.status),
                const Spacer(),
                TextButton(onPressed: onEdit, child: const Text('تعديل')),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _deleteDonation(context),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: const Text('حذف'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> statusInfo = _getStatusInfo(status);
    return Chip(
      avatar: Icon(statusInfo['icon'], color: statusInfo['color'], size: 16),
      label: Text(statusInfo['text']),
      backgroundColor: statusInfo['color'].withOpacity(0.1),
      labelStyle: TextStyle(color: statusInfo['color']),
      side: BorderSide.none,
    );
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status.toUpperCase()) {
      case 'AVAILABLE':
        return {
          'text': 'متاح',
          'color': AppColors.success,
          'icon': Icons.check_circle_outline
        };
      case 'RESERVED':
        return {
          'text': 'محجوز',
          'color': AppColors.warning,
          'icon': Icons.bookmark_border
        };
      case 'COLLECTED':
        return {
          'text': 'تم الاستلام',
          'color': AppColors.info,
          'icon': Icons.inventory_2_outlined
        };
      default:
        return {
          'text': 'غير معروف',
          'color': AppColors.lightTextDisabled,
          'icon': Icons.help_outline
        };
    }
  }
}
