import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/admin/presentation/photo_viewer_screen.dart';


class RequestDetailsScreen extends StatefulWidget {
  final String requestId;

  const RequestDetailsScreen({super.key, required this.requestId});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  final _client = Supabase.instance.client;

  Map<String, dynamic>? request;
  List<dynamic> photos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final req = await _client
        .from('scaffold_requests')
        .select()
        .eq('id', widget.requestId)
        .single();

    final attachments = await _client
        .from('scaffold_attachments')
        .select()
        .eq('request_id', widget.requestId)
        .eq('file_type', 'photo');

    setState(() {
      request = req;
      photos = attachments;
      loading = false;
    });
  }

  String _format(dynamic date) {
    if (date == null) return "N/A";
    return DateFormat("dd MMM yyyy").format(DateTime.parse(date));
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green.shade700;
      case 'declined':
        return Colors.red.shade700;
      case 'completed':
        return Colors.blue.shade700;
      case 'overdue':
        return Colors.red.shade900;
      default:
        return Colors.orange.shade700;
    }
  }

  Future<void> _updateStatus(String status) async {
    await _client
        .from('scaffold_requests')
        .update({'status': status})
        .eq('id', widget.requestId);

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final req = request!;
    final removalDate = req['removal_date'] != null
        ? DateTime.parse(req['removal_date'])
        : null;

    final today = DateTime.now();
    final overdue = removalDate != null && today.isAfter(removalDate);
    final dueSoon = removalDate != null &&
        removalDate.difference(today).inDays <= 2 &&
        removalDate.isAfter(today);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102A44),
        title: const Text("Request Details", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              req['subcontractor_name'] ?? "Unknown Subcontractor",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(req['status']),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                req['status'].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            if (overdue)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "⚠ OVERDUE — Removal date has passed",
                  style: TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              ),
            if (dueSoon && !overdue)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "⚠ Due in less than 2 days",
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 16),
                ),
              ),
            const SizedBox(height: 20),
            _info("Location", req['location']),
            _info("Scaffold Type", req['scaffold_type']),
            _info("Height", req['height']),
            _info("Weight Capacity", req['weight_capacity']),
            _info("Contact Person", req['contact_person']),
            _info("Phone", req['phone']),
            _info("Email", req['email']),
            _info("Description", req['description']),
            const SizedBox(height: 20),
            _info("Date Required", _format(req['date_required'])),
            _info("Removal Date", _format(req['removal_date'])),
            _info("Completed Date", _format(req['date_completed'])),
            const SizedBox(height: 30),
            const Text(
              "Photos",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            photos.isEmpty
                ? const Text("No photos uploaded", style: TextStyle(color: Colors.white70))
                : SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        final url = photos[index]['file_url'];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PhotoViewerScreen(
                                  photos: photos.map<String>((p) => p['file_url']).toList(),
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                url,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 30),
            if (req['status'] == 'pending')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateStatus("approved"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                      child: const Text("APPROVE"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateStatus("declined"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                      child: const Text("DECLINE"),
                    ),
                  ),
                ],
              ),
            if (req['status'] == 'approved')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _updateStatus("completed"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700),
                  child: const Text("MARK AS COMPLETED"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        "$label: ${value ?? 'N/A'}",
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
