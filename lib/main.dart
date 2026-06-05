import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/login_screen.dart';
import 'features/scaffold_requests/presentation/scaffold_request_form.dart';
import 'features/scaffold_requests/presentation/scaffold_requests_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _decideHome() async {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;

    if (session == null) {
      return const LoginScreen();
    }

    final profile = await client
        .from('profiles')
        .select('role')
        .eq('id', session.user.id)
        .maybeSingle();

    final role = profile?['role'] ?? 'public';

    if (role == 'admin' || role == 'supervisor' || role == 'qs') {
      return const ScaffoldRequestsScreen();
    }

    return const ScaffoldRequestForm();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scaffold Manager',
      theme: ThemeData.dark(),
      home: FutureBuilder<Widget>(
        future: _decideHome(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!;
        },
      ),
    );
  }
}