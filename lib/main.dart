import 'package:flutter/material.dart';
import 'package:fmas_app/screens/auth/login_screen.dart';

void main() {
  runApp(const FMASApp());
}

class FMASApp extends StatelessWidget {
  const FMASApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FMAS',
      theme: ThemeData(
        primarySwatch: Colors.blue,                      // Tailwind blues
        scaffoldBackgroundColor: Colors.grey[100],       // bg-gray-100
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),      // rounded-lg
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),    // rounded-lg
            ),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
