import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'mission_planner_screen.dart';
import 'logs_screen.dart';
import '../widgets/gcs_drawer.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const MissionPlannerScreen(),
    const LogsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const GCSDrawer(),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Theme(
        data: ThemeData(canvasColor: const Color(0xFF161B22)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'DASHBOARD'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'MISSION'),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'LOGS'),
          ],
        ),
      ),
    );
  }
}