import 'package:flutter/material.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1117), //
        appBar: AppBar(
          // Solid background matching Mission Planner exactly
          backgroundColor: const Color(0xFF161B22), //
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, size: 20),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          title: const Text(
            "SYSTEM LOGS",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 14),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.blueAccent, //
            labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "TELEMETRY"),
              Tab(text: "ALERTS"),
              Tab(text: "MISSIONS"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTelemetryLog(),
            _buildAlertLog(),
            _buildMissionHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryLog() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 25,
      itemBuilder: (context, i) {
        final timestamp = "14:20:${(i * 2).toString().padLeft(2, '0')}";
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            "[$timestamp] ALT: ${120 + i}m | SPD: ${7.2}m/s | BATT: ${95 - (i ~/ 5)}%",
            style: const TextStyle(
                fontFamily: 'Monospace',
                fontSize: 11,
                color: Colors.greenAccent
            ), //
          ),
        );
      },
    );
  }

  Widget _buildAlertLog() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _LogEntry("14:20:05", Icons.warning, "Low Battery", "Level 15%", Colors.orange),
        _LogEntry("14:18:30", Icons.error, "GPS Glitch", "Sats dropped to 4", Colors.red),
        _LogEntry("14:15:12", Icons.info, "Mode Change", "Switched to RTL", Colors.blueAccent),
      ],
    );
  }

  Widget _buildMissionHistory() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _MissionTile("2026-02-12 10:30", "00:14:22", "SUCCESS"),
        _MissionTile("2026-02-12 09:15", "00:05:10", "ABORTED"),
        _MissionTile("2026-02-11 16:45", "00:22:15", "SUCCESS"),
      ],
    );
  }
}

// Sub-widget for Alert Entries
class _LogEntry extends StatelessWidget {
  final String time, title, msg;
  final IconData icon;
  final Color color;

  const _LogEntry(this.time, this.icon, this.title, this.msg, this.color);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(time, style: const TextStyle(fontFamily: 'Monospace', fontSize: 10, color: Colors.grey)),
      title: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Text(msg, style: const TextStyle(fontSize: 11, color: Colors.white70)),
      ),
    );
  }
}

// Sub-widget for Mission History Cards
class _MissionTile extends StatelessWidget {
  final String date, duration, status;
  const _MissionTile(this.date, this.duration, this.status);

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = status == "SUCCESS";
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22), //
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              const SizedBox(height: 4),
              Text("DURATION: $duration", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          Text(
            status,
            style: TextStyle(color: isSuccess ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}