// File: lib/routes/route_generator.dart

import 'package:flutter/material.dart';
import 'package:taskez/routes/app_routes.dart';
import 'package:taskez/Screens/splash_screen.dart';
import 'package:taskez/Screens/sample_screens.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Get the route name and arguments
    final String routeName = settings.name ?? '/';
    // final dynamic args = settings.arguments;

    // Define route mappings
    switch (routeName) {
      case AppRoutes.splash:
        return _buildRoute(SplashScreen(), settings);

      case AppRoutes.settings:
        return _buildRoute(
          Scaffold(
            appBar: AppBar(
              title: Text('Settings'),
              backgroundColor: Colors.blueGrey,
            ),
            body: Center(
              child: Text(
                'Settings Page',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          settings,
        );

      // Purchase routes
      case AppRoutes.purchaseOrders:
        return _buildRoute(
          GenericScreen(
            title: 'Achats',
            route: routeName,
            icon: Icons.shopping_cart,
            color: Colors.blue,
          ),
          settings,
        );

      // Sales routes
      case AppRoutes.saleOrders:
        return _buildRoute(
          GenericScreen(
            title: 'Ventes',
            route: routeName,
            icon: Icons.point_of_sale,
            color: Colors.green,
          ),
          settings,
        );

      // Import routes
      case AppRoutes.importsDeclaration:
        return _buildRoute(
          GenericScreen(
            title: 'Importations',
            route: routeName,
            icon: Icons.input,
            color: Colors.orange,
          ),
          settings,
        );

      // Export routes
      case AppRoutes.exportsDeclaration:
        return _buildRoute(
          GenericScreen(
            title: 'Exportations',
            route: routeName,
            icon: Icons.output,
            color: Colors.teal,
          ),
          settings,
        );

      // Receipt routes
      case AppRoutes.receiptsManagement:
        return _buildRoute(
          GenericScreen(
            title: 'Reçus',
            route: routeName,
            icon: Icons.receipt,
            color: Colors.amber,
          ),
          settings,
        );

      // Bank routes
      case AppRoutes.bankAccounts:
        return _buildRoute(
          GenericScreen(
            title: 'Banque',
            route: routeName,
            icon: Icons.account_balance,
            color: Colors.indigo,
          ),
          settings,
        );

      // CMI routes
      case AppRoutes.cmiInventory:
        return _buildRoute(
          GenericScreen(
            title: 'CMI',
            route: routeName,
            icon: Icons.inventory,
            color: Colors.cyan,
          ),
          settings,
        );

      // Default case for unknown routes
      default:
        return _buildRoute(_buildUnknownRoute(routeName), settings);
    }
  }

  // Helper method to build routes with consistent transition
  static Route<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide transition from right to left
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  // Widget for unknown routes
  static Widget _buildUnknownRoute(String routeName) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Not Found'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Route not found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The route "$routeName" does not exist.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
