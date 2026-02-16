import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';
import '../services/alert_service.dart';
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

  final AlertService _sharedAlertService = AlertService();
  final DashboardController _sharedDashboardController = DashboardController();

  @override
  void initState() {
    super.initState();
    // 3. START THE CONTROLLER HERE
    // This ensures the drone starts "flying" as soon as the app opens
    _sharedDashboardController.start(context, _sharedAlertService);
  }

  @override
  void dispose() {
    _sharedDashboardController.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      DashboardScreen(
        alertService: _sharedAlertService,
        controller: _sharedDashboardController,
      ),
      const MissionPlannerScreen(),
      LogsScreen(
        alertService: _sharedAlertService,
        controller: _sharedDashboardController,
      ),
    ];
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
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'DASHBOARD',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'MISSION',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'LOGS'),
          ],
        ),
      ),
    );
  }
}
