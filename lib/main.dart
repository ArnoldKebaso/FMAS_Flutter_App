import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/home_screen.dart';

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage(); // Changed from HomeScreen to HomePage
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: '/reset-password/:email/:token',
      builder: (BuildContext context, GoRouterState state) {
        final email = state.pathParameters['email']!;
        final token = state.pathParameters['token']!;
        return ResetPasswordScreen(email: email, token: token);
      },
    ),
    GoRoute(
      path: '/about',
      builder: (BuildContext context, GoRouterState state) {
        return const PlaceholderScreen(title: 'About');
      },
    ),
    GoRoute(
      path: '/donate',
      builder: (BuildContext context, GoRouterState state) {
        return const PlaceholderScreen(title: 'Donate');
      },
    ),
    GoRoute(
      path: '/userResources',
      builder: (BuildContext context, GoRouterState state) {
        return const PlaceholderScreen(title: 'Resources');
      },
    ),
    GoRoute(
      path: '/contact',
      builder: (BuildContext context, GoRouterState state) {
        return const PlaceholderScreen(title: 'Contact');
      },
    ),
    GoRoute(
      path: '/faq',
      builder: (BuildContext context, GoRouterState state) {
        return const PlaceholderScreen(title: 'FAQ');
      },
    ),
    GoRoute(
      path: '/alerts',
      builder: (BuildContext context, GoRouterState state) {
        return const PlaceholderScreen(title: 'Alerts');
      },
    ),
    GoRoute(
      path: '/report',
      builder: (BuildContext context, GoRouterState state) {
        return const PlaceholderScreen(title: 'Report');
      },
    ),
  ],
);

class FMASApp extends StatelessWidget {
  const FMASApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FMAS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        inputDecorationTheme: const InputDecorationTheme(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ), // Made const
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title Page')),
    );
  }
}