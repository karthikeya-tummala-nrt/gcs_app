import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // New import
import 'package:latlong2/latlong.dart';      // New import
import 'panel.dart';

class MapPanel extends StatelessWidget {
  const MapPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Panel(
      title: 'GCS Map',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4), // Keeps the map inside your panel corners
        child: FlutterMap(
          options: const MapOptions(
            // Center on a default location
            initialCenter: LatLng(13.076352 , 77.610125),
            initialZoom: 16.0,
            interactionOptions: InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.gcs_app',
            ),

          ],
        ),
      ),
    );
  }
}