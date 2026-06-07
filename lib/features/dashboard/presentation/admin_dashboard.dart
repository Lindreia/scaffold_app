import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/auth_gate.dart';
import '../../scaffold_requests/presentation/scaffold_requests_screen.dart';
import '../../scaffold_requests/presentation/add_scaffold_request_screen.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: Color(0xFF102A44),
        title: Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => AuthGate()),
                  (route) => false,
                );
              }
            },
          )
        ],
      ),
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 240,
            color: Color(0xFF102A44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                _SidebarItem(
                  icon: Icons.dashboard,
                  label: "Dashboard",
                ),
                _SidebarItem(
                  icon: Icons.assignment,
                  label: "Requests",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScaffoldRequestsScreen(),
                      ),
                    );
                  },
                ),
                _SidebarItem(
                  icon: Icons.people,
                  label: "Workers",
                ),
                _SidebarItem(
                  icon: Icons.business,
                  label: "Subcontractors",
                ),
                _SidebarItem(
                  icon: Icons.map,
                  label: "Site Plans",
                ),
                _SidebarItem(
                  icon: Icons.settings,
                  label: "Settings",
                ),
              ],
            ),
          ),

          // MAIN CONTENT
          Expanded(
            child: Column(
              children: [
                // HEADER IMAGE RIBBON
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/blueprint_scaffold.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                    ),
                    child: Text(
                      "Admin Dashboard",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // WHITE DASHBOARD AREA
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Overview",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            _QuickActionCard(
                              icon: Icons.add_box,
                              label: "Add Request",
                              onTap: () async {
                                final created = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddScaffoldRequestScreen(),
                                  ),
                                );
                                if (created == true) {
                                  // optional: trigger a refresh or show a snackbar
                                }
                              },
                            ),
                            SizedBox(width: 16),
                            _QuickActionCard(
                              icon: Icons.person_add,
                              label: "Add Worker",
                              onTap: () {},
                            ),
                            SizedBox(width: 16),
                            _QuickActionCard(
                              icon: Icons.map,
                              label: "Upload Site Plan",
                              onTap: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Active Jobs",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListView(
                              children: [
                                _JobTile(
                                  title: "Auckland CBD Tower Scaffold",
                                  status: "In Progress",
                                  workers: 12,
                                ),
                                _JobTile(
                                  title: "Warehouse Extension – Manukau",
                                  status: "Pending",
                                  workers: 5,
                                ),
                                _JobTile(
                                  title: "Bridge Maintenance – North Shore",
                                  status: "Completed",
                                  workers: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  _SidebarItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  _QuickActionCard({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blueGrey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.blueGrey.shade800, size: 32),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.blueGrey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JobTile extends StatelessWidget {
  final String title;
  final String status;
  final int workers;

  _JobTile({
    required this.title,
    required this.status,
    required this.workers,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.black87)),
      subtitle: Text(
        "$status • $workers workers",
        style: TextStyle(color: Colors.black54),
      ),
    );
  }
}
