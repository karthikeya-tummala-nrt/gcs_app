import 'package:flutter/material.dart';
import 'package:gcs_app/screens/main_navigation_wrapper.dart';
import 'package:gcs_app/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ground Control Station',
      theme: ThemeData(
        brightness: Brightness.dark,

        scaffoldBackgroundColor: const Color(0xFF0D1117),

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
          surface: const Color(0xFF161B22), // Lighter slate for panels
        ),

        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
          labelSmall: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 2,
          foregroundColor: Colors.white,
          shadowColor: Colors.black12,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainNavigationWrapper(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
