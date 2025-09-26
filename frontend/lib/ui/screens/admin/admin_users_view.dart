import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/models/user.dart';
import 'package:giving_bridge/services/admin_service.dart';
import 'package:giving_bridge/ui/theme/app_colors.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminService>().getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminService = context.watch<AdminService>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                adminService.getUsers(page: adminService.currentPage),
          ),
        ],
      ),
      body: adminService.isLoading && adminService.users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildUsersTable(adminService.users, theme),
                    const SizedBox(height: 24),
                    _buildPaginationControls(adminService, theme),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildUsersTable(List<User> users, ThemeData theme) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Role')),
        DataColumn(label: Text('Actions')),
      ],
      rows: users
          .map((user) => DataRow(
                cells: [
                  DataCell(Text(user.id.toString())),
                  DataCell(Text(user.name)),
                  DataCell(Text(user.email)),
                  DataCell(_RoleChip(role: user.role)),
                  DataCell(Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () {}),
                      IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.error),
                          onPressed: () {}),
                    ],
                  )),
                ],
              ))
          .toList(),
    );
  }

  Widget _buildPaginationControls(AdminService service, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Page ${service.currentPage} of ${service.totalPages}'),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: service.currentPage > 1
              ? () => service.getUsers(page: service.currentPage - 1)
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: service.currentPage < service.totalPages
              ? () => service.getUsers(page: service.currentPage + 1)
              : null,
        ),
      ],
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String role;
  const _RoleChip({required this.role});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> roleInfo = _getRoleInfo(role);
    return Chip(
      label: Text(roleInfo['text']),
      backgroundColor: roleInfo['color'].withOpacity(0.1),
      labelStyle: TextStyle(color: roleInfo['color']),
      side: BorderSide.none,
    );
  }

  Map<String, dynamic> _getRoleInfo(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return {'text': 'Admin', 'color': AppColors.error};
      case 'DONOR':
        return {'text': 'Donor', 'color': AppColors.success};
      case 'RECEIVER':
        return {'text': 'Receiver', 'color': AppColors.info};
      default:
        return {'text': 'Unknown', 'color': AppColors.lightTextDisabled};
    }
  }
}
