import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'routes/route_generator.dart';
import 'routes/app_routes.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'EXPERIO',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      // Set initial route
      initialRoute: AppRoutes.splash,
      // Use our custom route generator
      onGenerateRoute: RouteGenerator.generateRoute,
      // Fallback for unknown routes
      onUnknownRoute: (settings) => RouteGenerator.generateRoute(
        RouteSettings(name: '/unknown', arguments: settings.arguments),
      ),
    );
  }
}
