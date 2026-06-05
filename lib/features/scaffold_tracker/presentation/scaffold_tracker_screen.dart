import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScaffoldTrackerScreen extends StatefulWidget {
  const ScaffoldTrackerScreen({super.key});

  @override
  State<ScaffoldTrackerScreen> createState() => _ScaffoldTrackerScreenState();
}

class _ScaffoldTrackerScreenState extends State<ScaffoldTrackerScreen> {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _fetchTracker() async {
    final response = await _client
        .from('scaffold_tracker')
        .select('*, subcontractors(name)')
        .order('date_erected', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'up':
        return Colors.green.shade700;
      case 'scheduled_removal':
        return Colors.orange.shade700;
      case 'overdue':
        return Colors.red.shade700;
      case 'removed':
        return Colors.blueGrey.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scaffold Tracker'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchTracker(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data;
          if (items == null || items.isEmpty) {
            return const Center(
              child: Text('No scaffold tracker records found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final scaffold = items[index];
              final status = scaffold['status'] as String? ?? 'unknown';
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(scaffold['scaffold_type']?.toString() ?? 'Unknown'),
                  subtitle: Text(scaffold['location']?.toString() ?? 'No location'),
                  trailing: Text(
                    status.toUpperCase(),
                    style: TextStyle(color: _statusColor(status)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
