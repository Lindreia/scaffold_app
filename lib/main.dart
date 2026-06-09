import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase directly (no .env in release builds)
  await Supabase.initialize(
    url: "https://jndtshuyvyjvkhfufyr.supabase.co",  // <-- corrected URL
    anonKey: "sb_publishable_kgw_D5hl1nEmhac-EDawgg_080pF94H", // <-- your publishable key
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scaffold Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A1A2F),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF102A44),
          elevation: 0,
        ),
      ),
      home: AuthGate(),
    );
  }
}
