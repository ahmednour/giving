import 'package:flutter/material.dart';
import 'package:giving_bridge/ui/screens/admin/admin_dashboard_view.dart';
import 'package:giving_bridge/ui/screens/admin/admin_requests_view.dart';
import 'package:giving_bridge/ui/screens/admin/admin_users_view.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  final List<Widget> _adminPages = [
    const AdminDashboardView(),
    const AdminUsersView(),
    const AdminRequestsView(),
  ];

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to create a responsive layout
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout with BottomNavigationBar
          return Scaffold(
            body: _adminPages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_alt_outlined),
                  label: 'Users',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.rule_outlined),
                  label: 'Requests',
                ),
              ],
            ),
          );
        } else {
          // Desktop/Web layout with NavigationRail
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_alt_outlined),
                      label: Text('Users'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.rule_outlined),
                      label: Text('Requests'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: _adminPages[_selectedIndex],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
