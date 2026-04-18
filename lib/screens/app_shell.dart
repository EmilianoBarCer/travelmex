import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';
import '../screens/home/home_screen.dart';
import '../screens/map_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search/search_screen.dart';

/// 🏗️ AppShell
/// Main app shell with bottom navigation and IndexedStack for tab persistence
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const MapScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // Floating Glass Bottom Navigation
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),

      // Custom page transitions for details screen
      // Routes are handled in main.dart
    );
  }
}