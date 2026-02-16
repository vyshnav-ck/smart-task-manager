import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../tasks/presentation/screens/task_list_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';



class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      TaskListScreen(userId: widget.userId),
      ProfileScreen(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
  height: 70,
  selectedIndex: _currentIndex,
  onDestinationSelected: (index) {
    setState(() {
      _currentIndex = index;
    });
  },
  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: "Dashboard",
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: "Profile",
    ),
  ],
),
    );
  }
}
