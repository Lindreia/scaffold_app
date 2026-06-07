import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Screens
import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/admin_dashboard.dart';
import '../features/dashboard/presentation/worker_dashboard.dart';
import '../features/scaffold_tracker/presentation/scaffold_tracker_screen.dart';
import '../features/financials/presentation/financial_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _client = Supabase.instance.client;
  late final Stream<AuthState> _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = _client.auth.onAuthStateChange;
  }

  Future<String?> _getUserRole() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final response = await _client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    return response?['role'];
  }

  Widget _routeForRole(String? role) {
    switch (role) {
      case 'admin':
        return AdminDashboard();

      case 'supervisor':
        return ScaffoldTrackerScreen();

      case 'qs':
        return FinancialScreen();

      case 'worker':
        return WorkerDashboard();

      default:
        return BlueprintLoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: _authStream,
      builder: (context, snapshot) {
        final session = snapshot.data?.session;

        // Not logged in → Login screen
        if (session == null) {
          return BlueprintLoginScreen();
        }

        // Logged in → fetch role
        return FutureBuilder<String?>(
          future: _getUserRole(),
          builder: (context, roleSnapshot) {
            if (!roleSnapshot.hasData) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }

            final role = roleSnapshot.data;
            return _routeForRole(role);
          },
        );
      },
    );
  }
}
