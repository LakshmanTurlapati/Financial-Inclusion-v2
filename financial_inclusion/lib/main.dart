import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      theme: ThemeData(
        primaryColor: const Color(0xFFF4792A),   // Set the orange color
        textTheme: GoogleFonts.interTextTheme(    // Apply Inter globally
          Theme.of(context).textTheme,
        ),),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/dashboard': (context) => DashboardPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
