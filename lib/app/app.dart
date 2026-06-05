import 'package:flutter/material.dart';
import 'auth_gate.dart';
import 'theme.dart';

class BEApp extends StatelessWidget {
  const BEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Built Environs Scaffold System',
      debugShowCheckedModeBanner: false,
      theme: BETheme.blueprintTheme,
      home: const AuthGate(),
    );
  }
}
