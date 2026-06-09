import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/widgets/blueprint_background.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class BlueprintLoginScreen extends StatefulWidget {
  BlueprintLoginScreen({super.key});

  @override
  State<BlueprintLoginScreen> createState() => _BlueprintLoginScreenState();
}

class _BlueprintLoginScreenState extends State<BlueprintLoginScreen> {
  final _client = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  bool _showPassword = false;
  String? _message;

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _message = "Please enter email and password");
      return;
    }

    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      // Attempt login
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // ⭐ DO NOT NAVIGATE ANYWHERE
      // AuthGate will automatically detect the new session
      // and redirect the user to AdminDashboard.
      setState(() => _loading = false);

    } on AuthException catch (e) {
      setState(() {
        _loading = false;
        _message = e.message;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _message = 'Unexpected error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlueprintBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),

                      SizedBox(
                        height: 140,
                        child: Image.asset(
                          'assets/images/blueprint_scaffold.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Scaffold Mobile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Opacity(
                        opacity: 0.85,
                        child: Text(
                          'Efficient Job Tracking & Scaffold Management',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 520),
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.14),
                              borderRadius: Border