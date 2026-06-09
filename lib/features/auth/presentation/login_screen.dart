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
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.18),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.18),
                                  blurRadius: 28,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Manage Scaffold Projects & Assign Work in the Field',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.email, color: Colors.white70),
                                    labelText: 'Email',
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                TextField(
                                  controller: _passwordController,
                                  obscureText: !_showPassword,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _showPassword ? Icons.visibility : Icons.visibility_off,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        setState(() => _showPassword = !_showPassword);
                                      },
                                    ),
                                    labelText: 'Password',
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: _loading ? null : _signIn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E5AA8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: _loading
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : const Text(
                                            'Log In',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Create an Account',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),

                                if (_message != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    _message!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _message!.contains('success')
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (_loading)
              Container(
                color: Colors.black.withOpacity(0.25),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
