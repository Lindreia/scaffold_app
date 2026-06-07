import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'request_details_screen.dart';

class ScaffoldRequestsScreen extends StatefulWidget {
  ScaffoldRequestsScreen({super.key});

  @override
  State<ScaffoldRequestsScreen> createState() =>
      _ScaffoldRequestsScreenState();
}

class _ScaffoldRequestsScreenState extends State<ScaffoldRequestsScreen> {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _fetchRequests() async {
    final response = await _client
        .from('scaffold_requests')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Color _statusColor(Map<String, dynamic> req) {
    final status = req['status'];
    final removalDate = req['removal_date'] != null
        ? DateTime.parse(req['removal_date'])
        : null;
    final today = DateTime.now();

    if (status == 'completed') return Colors.blue.shade700;
    if (status == 'declined') return Colors.red.shade700;
    if (status == 'approved') return Colors.green.shade700;

    if (removalDate != null && today.isAfter(removalDate)) {
      return Colors.red.shade900;
    }

    if (removalDate != null &&
        removalDate.isAfter(today) &&
        removalDate.difference(today).inDays <= 2) {
      return Colors.orange.shade800;
    }

    return Colors.orange.shade600;
  }

  String _format(dynamic date) {
    if (date == null) return "N/A";
    return DateFormat("dd MMM yyyy").format(DateTime.parse(date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER IMAGE RIBBON
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/blueprint_scaffold.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.all(24),
              color: Colors.black.withOpacity(0.4),
              child: Text(
                "Scaffold Requests",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // WHITE CONTENT AREA
          Expanded(
            child: Container(
              color: Colors.white,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchRequests(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueGrey,
                      ),
                    );
                  }

                  final requests = snapshot.data!;
                  if (requests.isEmpty) {
                    return Center(
                      child: Text(
                        'No scaffold requests found',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final req = requests[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RequestDetailsScreen(requestId: req['id'].toString()),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blueGrey.shade200,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                req['subcontractor_name'] ??
                                    'Unknown Subcontractor',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey.shade900,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Location: ${req['location']}'),
                              Text('Type: ${req['scaffold_type']}'),
                              Text('Height: ${req['height']}'),
                              Text(
                                  'Weight Capacity: ${req['weight_capacity']}'),
                              Text(
                                  'Contact: ${req['contact_person']} (${req['phone']})'),
                              SizedBox(height: 8),
                              Text(
                                  'Date Required: ${_format(req['date_required'])}'),
                              Text(
                                  'Removal Date: ${_format(req['removal_date'])}'),
                              SizedBox(height: 12),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _statusColor(req),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  req['status'].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
