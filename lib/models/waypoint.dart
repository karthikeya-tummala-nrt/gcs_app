import 'package:latlong2/latlong.dart';

class Waypoint {
  final String id;
  LatLng location;
  double altitude;
  double speed;

  Waypoint({
    required this.id,
    required this.location,
    required this.altitude,
    required this.speed,
  });

  // Task 6: Convert to JSON for saving
  Map<String, dynamic> toJson() => {
    'id': id,
    'lat': location.latitude,
    'lng': location.longitude,
    'alt': altitude,
    'speed': speed,
  };

  // Task 6: Create from JSON for loading
  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
    id: json['id'],
    location: LatLng(json['lat'], json['lng']),
    altitude: json['alt'],
    speed: json['speed'],
  );
}