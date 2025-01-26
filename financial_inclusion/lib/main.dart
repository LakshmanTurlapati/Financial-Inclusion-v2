import 'package:flutter/material.dart';
import 'landing.dart';
import 'dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Inclusion',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/dashboard': (context) => DashboardPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
