import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';

// Screens
import 'screens/auth_screen.dart';
import 'screens/mood_checkin_screen.dart';
import 'screens/support_choice_screen.dart';
import 'screens/comfort_screen.dart';
import 'screens/breathing_screen.dart';
import 'screens/reflection_screen.dart';
import 'screens/history_screen.dart';
import 'screens/resources_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notification_screen.dart';

// Header
import 'widgets/app_header.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindEase',
      home: const AuthGate(),
      routes: {
        '/mood-checkin': (_) =>
            const ScreenWrapper(child: MoodCheckinScreen()),
        '/support-choice': (_) =>
            const ScreenWrapper(child: SupportChoiceScreen()),
        '/comfort': (_) => const ScreenWrapper(child: ComfortScreen()),
        '/breathing': (_) => const ScreenWrapper(child: BreathingScreen()),
        '/reflection': (_) => const ScreenWrapper(child: ReflectionScreen()),
        '/history': (_) => const ScreenWrapper(child: HistoryScreen()),
        '/resources': (_) => const ScreenWrapper(child: ResourcesScreen()),
        '/settings': (_) => const ScreenWrapper(child: SettingsScreen()),
        '/profile': (_) => const ScreenWrapper(child: ProfileScreen()),
        '/notifications': (_) =>
            const ScreenWrapper(child: NotificationScreen()),
      },
    );
  }
}

/// 🔐 AUTH GUARD
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    if (!app.state.isAuthenticated) {
      return const AuthScreen();
    }

    return const ScreenWrapper(child: MoodCheckinScreen());
  }
}

/// 🧱 LAYOUT WITH ROUTE-AWARE NAV BAR
class ScreenWrapper extends StatelessWidget {
  final Widget child;

  const ScreenWrapper({super.key, required this.child});

  static const List<String> _routes = [
    '/support-choice',
    '/history',
    '/resources',
    '/settings',
    '/profile',
  ];

  int _currentIndex(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;
    final index = _routes.indexOf(route ?? '');
    return index == -1 ? 0 : index;
  }

  String _getTitle(BuildContext context) {
    switch (ModalRoute.of(context)?.settings.name) {
      case '/history':
        return 'Insights';
      case '/resources':
        return 'Support';
      case '/settings':
        return 'Settings';
      case '/profile':
        return 'Profile';
      default:
        return 'MindEase';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: _getTitle(context),
              onNotificationTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: child,
              ),
            ),
          ],
        ),
      ),

      /// ✅ NAV BAR (NOW HIGHLIGHTS CORRECTLY)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0D9488),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          final target = _routes[index];
          if (ModalRoute.of(context)?.settings.name == target) return;
          Navigator.pushReplacementNamed(context, target);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Support'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
