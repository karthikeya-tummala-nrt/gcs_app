import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import '../models/waypoint.dart';
import '../widgets/panel.dart';
import 'package:file_picker/file_picker.dart';

class MissionPlannerScreen extends StatefulWidget {
  const MissionPlannerScreen({super.key});

  @override
  State<MissionPlannerScreen> createState() => _MissionPlannerScreenState();
}

class _MissionPlannerScreenState extends State<MissionPlannerScreen> {
  final List<Waypoint> _waypoints = [];
  final MapController _mapController = MapController();

  double defaultAltitude = 50.0;
  double defaultSpeed = 5.0;

  void _handleTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _waypoints.add(
        Waypoint(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          location: point,
          altitude: defaultAltitude,
          speed: defaultSpeed,
        ),
      );
    });
  }

  double _calculateTotalDistance() {
    double total = 0;
    const Distance distance = Distance();
    for (int i = 0; i < _waypoints.length - 1; i++) {
      total += distance.as(
        LengthUnit.Meter,
        _waypoints[i].location,
        _waypoints[i + 1].location,
      );
    }
    return total;
  }

  Future<File> _getAvailableFile() async {
    final directory = await getApplicationDocumentsDirectory();
    int counter = 0;
    String fileName = 'mission.json';
    File file = File('${directory.path}/$fileName');

    while (await file.exists()) {
      counter++;
      fileName = 'mission($counter).json';
      file = File('${directory.path}/$fileName');
    }
    return file;
  }

  Future<void> _saveMission() async {
    try {
      final file = await _getAvailableFile();
      final String jsonData = jsonEncode(
        _waypoints.map((wp) => wp.toJson()).toList(),
      );
      await file.writeAsString(jsonData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Saved as: ${file.path.split('/').last}"),
            backgroundColor: Colors.green.withValues(alpha: 0.8),
          ),
        );
      }
    } catch (e) {
      debugPrint("Save Error: $e");
    }
  }

  Future<void> _loadMission() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final String content = await file.readAsString();
        final List<dynamic> decoded = jsonDecode(content);

        setState(() {
          _waypoints.clear();
          _waypoints.addAll(
            decoded.map((item) => Waypoint.fromJson(item)).toList(),
          );
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Loaded: ${result.files.single.name}")),
          );
        }
      }
    } catch (e) {
      debugPrint("Load Error: $e");
    }
  }

  void _editWaypoint(int index) {
    final wp = _waypoints[index];
    final altController = TextEditingController(text: wp.altitude.toString());
    final speedController = TextEditingController(text: wp.speed.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: Text(
          "Edit WP ${index + 1}",
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: altController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Altitude (m)",
                labelStyle: TextStyle(color: Colors.blueAccent),
              ),
            ),
            TextField(
              controller: speedController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Speed (m/s)",
                labelStyle: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                wp.altitude =
                    double.tryParse(altController.text) ?? wp.altitude;
                wp.speed = double.tryParse(speedController.text) ?? wp.speed;
              });
              Navigator.pop(context);
            },
            child: const Text("SAVE"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        title: const Text(
          "MISSION PLANNER",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(13.0763, 77.6101),
              initialZoom: 16.0,
              onTap: _handleTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.gcs_app',
              ),
              PolylineLayer(
                polylines: _waypoints.length < 2
                    ? <Polyline<Object>>[]
                    : <Polyline<Object>>[
                        Polyline<Object>(
                          points: _waypoints.map((wp) => wp.location).toList(),
                          color: Colors.blueAccent,
                          strokeWidth: 3,
                        ),
                      ],
              ),
              MarkerLayer(
                markers: _waypoints.asMap().entries.map((entry) {
                  return Marker(
                    point: entry.value.location,
                    width: 30,
                    height: 30,
                    child: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        "${entry.key + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          Positioned(
            left: 16,
            top: 16,
            bottom: 16,
            width: 260,
            child: Panel(
              title: "Waypoint Editor",
              child: Column(
                children: [
                  Expanded(
                    child: _waypoints.isEmpty
                        ? const Center(
                            child: Text(
                              "Tap map to add waypoints",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : ReorderableListView(
                            // FIX 1: Prevent automatic drag handles at the end of the row
                            buildDefaultDragHandles: false,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) newIndex -= 1;
                                final item = _waypoints.removeAt(oldIndex);
                                _waypoints.insert(newIndex, item);
                              });
                            },
                            children: [
                              for (int i = 0; i < _waypoints.length; i++)
                                _waypointTile(i, _waypoints[i]),
                            ],
                          ),
                  ),
                  const Divider(color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: _saveMission,
                        icon: const Icon(Icons.save, size: 16),
                        label: const Text("SAVE"),
                      ),
                      TextButton.icon(
                        onPressed: _loadMission,
                        icon: const Icon(Icons.file_open, size: 16),
                        label: const Text("LOAD"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _waypointTile(int index, Waypoint wp) {
    return Dismissible(
      key: ValueKey(wp.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => setState(() => _waypoints.removeAt(index)),
      background: Container(
        color: Colors.red.withValues(alpha: 0.1),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: const Icon(Icons.delete, color: Colors.red, size: 20),
      ),
      child: Container(
        // ReorderableListView needs the same key on the immediate child
        key: ValueKey(wp.id),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
          ),
        ),
        child: Row(
          children: [
            // FIX 2: Explicit width for the custom drag handle at the start
            ReorderableDragStartListener(
              index: index,
              child: const SizedBox(
                width: 32,
                height: 40,
                child: Icon(Icons.drag_handle, color: Colors.grey, size: 18),
              ),
            ),

            // INFO SECTION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "WP ${index + 1}",
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    "${wp.location.latitude.toStringAsFixed(4)}, ${wp.location.longitude.toStringAsFixed(4)}",
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                  Text(
                    "ALT: ${wp.altitude}m | SPD: ${wp.speed}m/s",
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // FIX 3: Constrained Settings button with compact density
            SizedBox(
              width: 32,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.settings, size: 16, color: Colors.grey),
                onPressed: () => _editWaypoint(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
