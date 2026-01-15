import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/app_header.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AppScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'MindEase';
      case 1:
        return 'Insights';
      case 2:
        return 'Support';
      case 3:
        return 'Settings';
      case 4:
        return 'Profile';
      default:
        return 'MindEase';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppProvider>().state;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            AppHeader(
              title: _getTitle(currentIndex),
              onNotificationTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),

            /// MAIN CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 96),
                child: child,
              ),
            ),
          ],
        ),
      ),

      
    );
  }

  String _routeForIndex(int index) {
    switch (index) {
      case 0:
        return '/support-choice';
      case 1:
        return '/history';
      case 2:
        return '/resources';
      case 3:
        return '/settings';
      case 4:
        return '/profile';
      default:
        return '/support-choice';
    }
  }
}
