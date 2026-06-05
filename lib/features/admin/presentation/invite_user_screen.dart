import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InviteUserScreen extends StatefulWidget {
  const InviteUserScreen({super.key});

  @override
  State<InviteUserScreen> createState() => _InviteUserScreenState();
}

class _InviteUserScreenState extends State<InviteUserScreen> {
  final _email = TextEditingController();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();

  String _role = 'supervisor';
  bool _loading = false;

  Future<void> _inviteUser() async {
    setState(() => _loading = true);

    try {
      final client = Supabase.instance.client;

      // 1. Send Supabase invite email
      final res = await client.auth.admin.inviteUserByEmail(_email.text.trim());
      final user = res.user;

      if (user == null) {
        throw Exception("Supabase did not return a user ID");
      }

      // 2. Insert into profiles table
      await client.from('profiles').insert({
        'id': user.id,
        'full_name': _fullName.text.trim(),
        'phone': _phone.text.trim(),
        'email': _email.text.trim(),
        'role': _role,
        'company_id': null, // optional if you want to assign later
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User invited successfully")),
      );

      _email.clear();
      _fullName.clear();
      _phone.clear();
      setState(() => _role = 'supervisor');

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102A44),
        title: const Text("Invite User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _email,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _fullName,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Full Name",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Phone",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _role,
              dropdownColor: const Color(0xFF102A44),
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(value: 'admin', child: Text("Admin")),
                DropdownMenuItem(value: 'supervisor', child: Text("Supervisor")),
                DropdownMenuItem(value: 'subcontractor', child: Text("Subcontractor")),
                DropdownMenuItem(value: 'viewer', child: Text("Viewer")),
              ],
              onChanged: (v) => setState(() => _role = v ?? 'supervisor'),
              decoration: const InputDecoration(
                labelText: "Role",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _inviteUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Send Invite"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
