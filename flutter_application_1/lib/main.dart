import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth/login_screen.dart';
//import 'package:flutter_application_1/screens/auth/splash_screen.dart';
import 'core/theme/app_theme.dart';
//import 'screens/auth/login_screen.dart';

void main() {
  runApp(const BusTrackingApp());
}

class BusTrackingApp extends StatelessWidget {
  const BusTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kathmandu Bus Tracker',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
