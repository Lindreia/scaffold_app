import 'package:flutter/material.dart';

class BlueprintBackground extends StatelessWidget {
  final Widget child;

  const BlueprintBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Deep blueprint gradient
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

        // ⭐ The blueprint image you want (THIS is what was missing)
        Positioned.fill(
          child: Image.asset(
            'assets/images/blueprint_scaffold.png',
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.30),
          ),
        ),

        // ⭐ REMOVE THE GRID — mock‑up does NOT have it
        // (Delete your CustomPaint completely)

        // Foreground content
        child,
      ],
    );
  }
}
