import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/auth_gate.dart';

class SupervisorDashboard extends StatelessWidget {
  const SupervisorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102A44),
        title: const Text(
          "Supervisor Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthGate()),
                  (route) => false,
                );
              }
            },
          )
        ],
      ),

      body: Row(
        children: [
          // -----------------------------------
          // SIDEBAR (Supervisor Permissions)
          // -----------------------------------
          Container(
            width: 240,
            color: const Color(0xFF102A44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 30),
                _SidebarItem(icon: Icons.dashboard, label: "Dashboard"),
                _SidebarItem(icon: Icons.assignment, label: "Jobs"),
                _SidebarItem(icon: Icons.people, label: "Workers"),
                _SidebarItem(icon: Icons.map, label: "Site Plans"),
              ],
            ),
          ),

          // -----------------------------------
          // MAIN CONTENT
          // -----------------------------------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Overview",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // QUICK ACTIONS (Supervisor Level)
                  Row(
                    children: const [
                      _QuickActionCard(
                        icon: Icons.assignment_turned_in,
                        label: "Update Job Status",
                      ),
                      SizedBox(width: 16),
                      _QuickActionCard(
                        icon: Icons.group_add,
                        label: "Assign Workers",
                      ),
                      SizedBox(width: 16),
                      _QuickActionCard(
                        icon: Icons.upload_file,
                        label: "Upload Site Plan",
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Active Jobs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView(
                        children: const [
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
    );
  }
}

// -----------------------------------
// SIDEBAR ITEM
// -----------------------------------
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SidebarItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------
// QUICK ACTION CARD
// -----------------------------------
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickActionCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------
// JOB TILE
// -----------------------------------
class _JobTile extends StatelessWidget {
  final String title;
  final String status;
  final int workers;

  const _JobTile({
    required this.title,
    required this.status,
    required this.workers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
          Text(
            "$status • $workers workers",
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
