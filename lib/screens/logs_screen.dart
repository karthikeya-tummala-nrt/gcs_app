import 'package:flutter/material.dart';
import '../widgets/alert_panel.dart';
import '../services/alert_service.dart';
import '../controllers/dashboard_controller.dart';

class LogsScreen extends StatelessWidget {
  final AlertService alertService;
  final DashboardController
  controller; // Add the controller to get telemetry history

  const LogsScreen({
    super.key,
    required this.alertService,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1117),
        appBar: AppBar(
          backgroundColor: const Color(0xFF161B22),
          title: const Text(
            "SYSTEM LOGS",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(text: "TELEMETRY"),
              Tab(text: "ALERTS"),
              Tab(text: "MISSIONS"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1. Telemetry Data Tab
            ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                return _buildTelemetryLog();
              },
            ),

            // 2. Alerts Tab (Already listening to alertService)
            ListenableBuilder(
              listenable: alertService,
              builder: (context, _) => AlertPanel(alerts: alertService.recentAlerts),
            ),

            // 3. Mission Records Tab
            _buildMissionLog(),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryLog() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _logTile(
          "Current Battery",
          "${controller.battery}%",
          Icons.battery_charging_full,
        ),
        _logTile(
          "Max Altitude",
          "${controller.altitude.toStringAsFixed(1)}m",
          Icons.height,
        ),
        _logTile(
          "Signal Strength",
          "${controller.rssi} dBm",
          Icons.signal_cellular_alt,
        ),
        const Divider(color: Colors.grey),
        const Center(
          child: Text(
            "Live Telemetry Stream Active",
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildMissionLog() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _logTile(
          "Mission #42",
          "COMPLETED",
          Icons.check_circle,
          color: Colors.green,
        ),
        _logTile("Mission #41", "ABORTED", Icons.cancel, color: Colors.red),
        _logTile(
          "Mission #40",
          "COMPLETED",
          Icons.check_circle,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _logTile(
    String title,
    String value,
    IconData icon, {
    Color color = Colors.blueAccent,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      trailing: Text(
        value,
        style: const TextStyle(color: Colors.white70, fontFamily: 'Monospace'),
      ),
    );
  }
}
