import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/admin/presentation/admin_dashboard.dart';
import '../features/supervisor/presentation/supervisor_dashboard.dart';
import '../features/viewer/presentation/viewer_dashboard.dart';
import '../features/public/scaffold_request_form.dart';
import '../features/auth/presentation/login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _client = Supabase.instance.client;

  Future<String?> _getUserRole(String userId) async {
    final response = await _client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .maybeSingle();

    return response?['role'];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: _client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session;

        // Not logged in → login screen
        if (session == null) {
          return const BlueprintLoginScreen();
        }

        // Logged in → fetch role
        return FutureBuilder<String?>(
          future: _getUserRole(session.user.id),
          builder: (context, roleSnapshot) {
            if (!roleSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final role = roleSnapshot.data;

            switch (role) {
              case 'admin':
                return const AdminDashboard();

              case 'supervisor':
                return const SupervisorDashboard();

              case 'viewer':
                return const ViewerDashboard();

              case 'subcontractor':
                return const ScaffoldRequestForm();

              default:
                return const Scaffold(
                  body: Center(
                    child: Text(
                      'No valid role assigned. Contact your administrator.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
            }
          },
        );
      },
    );
  }
}
