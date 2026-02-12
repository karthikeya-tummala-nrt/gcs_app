import 'package:flutter/material.dart';
import '../widgets/panel.dart';

class MissionPlannerScreen extends StatelessWidget {
  const MissionPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), //
      appBar: AppBar(
        // Solid background to match project theme
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        // Menu button added here to access the Drawer
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 20),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text(
            "MISSION PLANNER",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/static_map.png', fit: BoxFit.cover)),

          // Waypoint List Panel
          Positioned(
            left: 16,
            top: 16,
            bottom: 16,
            width: 220,
            child: Panel(
              title: "Waypoint Editor",
              child: ListView(
                children: [
                  _waypointTile("WP 01", "47.3769° N, 8.5417° E", "120m"),
                  _waypointTile("WP 02", "47.3780° N, 8.5430° E", "150m"),
                  _waypointTile("WP 03", "47.3795° N, 8.5455° E", "100m"),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text("ADD WAYPOINT"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
                      foregroundColor: Colors.blueAccent,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _waypointTile(String id, String coords, String alt) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(id, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12)),
      subtitle: Text("$coords\nALT: $alt", style: const TextStyle(fontSize: 10, color: Colors.grey)),
      isThreeLine: true,
    );
  }
}