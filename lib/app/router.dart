import 'package:flutter/material.dart';

// Screens
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/scaffold_requests/presentation/scaffold_requests_screen.dart';
import '../features/scaffold_tracker/presentation/scaffold_tracker_screen.dart';
import '../features/financials/presentation/financial_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/dashboard':
        return _page(const BlueprintDashboardScreen());

      case '/requests':
        return _page(const ScaffoldRequestsScreen());

      case '/tracker':
        return _page(const ScaffoldTrackerScreen());

      case '/financials':
        return _page(const FinancialsScreen());

      default:
        return _page(
          Scaffold(
            body: Center(
              child: Text(
                'Route not found: ${settings.name}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        );
    }
  }

  static MaterialPageRoute _page(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }
}
