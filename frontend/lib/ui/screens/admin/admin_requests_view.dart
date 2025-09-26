import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/models/request.dart';
import 'package:giving_bridge/services/admin_service.dart';
import 'package:giving_bridge/services/request_service.dart';
import 'package:giving_bridge/ui/theme/app_colors.dart';

class AdminRequestsView extends StatefulWidget {
  const AdminRequestsView({super.key});

  @override
  State<AdminRequestsView> createState() => _AdminRequestsViewState();
}

class _AdminRequestsViewState extends State<AdminRequestsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminService>().getPendingRequests();
    });
  }

  Future<void> _handleRequestUpdate(int requestId, String status) async {
    final requestService = context.read<RequestService>();
    final success = await requestService.updateRequestStatus(
      requestId,
      UpdateRequestStatusRequest(status: status, adminNotes: 'Action by admin'),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Request status updated successfully'
              : 'Failed to update request status'),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
      // Refresh the list
      context.read<AdminService>().getPendingRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminService = context.watch<AdminService>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => adminService.getPendingRequests(),
          ),
        ],
      ),
      body: adminService.isLoading && adminService.pendingRequests.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : adminService.pendingRequests.isEmpty
              ? const Center(child: Text('No pending requests found.'))
              : _buildRequestsTable(adminService.pendingRequests, theme),
    );
  }

  Widget _buildRequestsTable(List<DonationRequest> requests, ThemeData theme) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Request ID')),
        DataColumn(label: Text('Donation Title')),
        DataColumn(label: Text('Receiver Name')),
        DataColumn(label: Text('Actions')),
      ],
      rows: requests.map((request) {
        return DataRow(
          cells: [
            DataCell(Text(request.id.toString())),
            DataCell(Text(request.donation?.title ?? 'N/A')),
            DataCell(Text(request.receiver?.name ?? 'N/A')),
            DataCell(Row(
              children: [
                TextButton(
                  onPressed: () => _handleRequestUpdate(request.id, 'APPROVED'),
                  style:
                      TextButton.styleFrom(foregroundColor: AppColors.success),
                  child: const Text('Approve'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _handleRequestUpdate(request.id, 'REJECTED'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: const Text('Reject'),
                ),
              ],
            )),
          ],
        );
      }).toList(),
    );
  }
}
