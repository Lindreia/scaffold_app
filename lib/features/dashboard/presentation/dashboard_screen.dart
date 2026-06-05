import 'package:flutter/material.dart';

class BlueprintDashboardScreen extends StatelessWidget {
  const BlueprintDashboardScreen({super.key});

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Branding
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BUILT ENVIRONS',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.5,
                            color: Colors.white.withOpacity(0.95),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'SCAFFOLD MANAGEMENT SYSTEM',
                          style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 1.3,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Section Title
                  Text(
                    'ADMIN DASHBOARD',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dashboard Tiles
                  Expanded(
                    child: GridView(
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 22,
                        mainAxisSpacing: 22,
                        childAspectRatio: 1.05,
                      ),
                      children: [
                        DashboardTile(
                          title: 'SCAFFOLD REQUESTS',
                          icon: Icons.assignment,
                          accent: Colors.orange,
                          onTap: () {},
                        ),
                        DashboardTile(
                          title: 'SCAFFOLD TRACKER',
                          icon: Icons.construction,
                          accent: Colors.blue,
                          onTap: () {},
                        ),
                        DashboardTile(
                          title: 'FINANCIALS (QS)',
                          icon: Icons.attach_money,
                          accent: Colors.green,
                          onTap: () {},
                        ),
                        DashboardTile(
                          title: 'NOTIFICATIONS',
                          icon: Icons.notifications,
                          accent: Colors.red,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const DashboardTile({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.blueGrey.shade900,
            width: 2.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon bubble
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withOpacity(0.25),
                border: Border.all(
                  color: Colors.blueGrey.shade900,
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                size: 36,
                color: Colors.blueGrey.shade900,
              ),
            ),

            const SizedBox(height: 18),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.blueGrey.shade900,
              ),
            ),
          ],
        ),
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

    const gridSize = 32.0;

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
