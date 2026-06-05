import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FinancialsScreen extends StatefulWidget {
  const FinancialsScreen({super.key});

  @override
  State<FinancialsScreen> createState() => _FinancialsScreenState();
}

class _FinancialsScreenState extends State<FinancialsScreen> {
  final _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _fetchFinancials() async {
    final response = await _client
        .from('scaffold_financials')
        .select('*, subcontractors(name), scaffold_tracker(scaffold_type, location)')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Color _costColor(num cost) {
    if (cost > 5000) return Colors.red.shade700;
    if (cost > 2000) return Colors.orange.shade700;
    return Colors.green.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Blueprint background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0A2A43),
                  Color(0xFF0D3B66),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Blueprint grid overlay
          CustomPaint(
            painter: BlueprintGridPainter(),
            size: Size.infinite,
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'FINANCIAL OVERVIEW (QS)',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.95),
                      letterSpacing: 2,
                    ),
                  ),
                ),

                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchFinancials(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      final items = snapshot.data!;

                      if (items.isEmpty) {
                        return Center(
                          child: Text(
                            'No financial records found',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final f = items[index];

                          final scaffold = f['scaffold_tracker'];
                          final subcontractor = f['subcontractors'];
                          final totalCost = f['total_cost'] ?? 0;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blueGrey.shade900,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  scaffold?['scaffold_type'] ?? 'Unknown Scaffold',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade900,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Details
                                Text('Subcontractor: ${subcontractor?['name'] ?? 'N/A'}'),
                                Text('Location: ${scaffold?['location'] ?? 'N/A'}'),
                                Text('Daily Rate: \$${f['daily_rate']}'),
                                Text('Total Days: ${f['total_days']}'),

                                const SizedBox(height: 12),

                                // Cost badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _costColor(totalCost),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'TOTAL COST: \$${totalCost.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BlueprintGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    const gridSize = 30.0;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
