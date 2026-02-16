import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../services/alert_service.dart';
import '../models/alert.dart';

class DashboardController extends ChangeNotifier {
  final Random _random = Random();
  late Timer _timer;

  int battery = 95;
  int gps = 10;
  int signal = 80;
  bool armed = false;

  double altitude = 120;
  double groundSpeed = 7;
  double verticalSpeed = -0.3;
  int heading = 245;

  double voltage = 14.8;
  double current = 9.2;
  double consumed = 1.6;

  int rssi = -62;
  int latency = 120;

  bool _lowBatteryWarned = false;
  bool _criticalBatteryWarned = false;
  bool _gpsLostWarned = false;
  bool _signalLostWarned = false;

  void start(BuildContext context, AlertService alertService) {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (armed) {
        // Simulated climb/descent physics
        verticalSpeed = (_random.nextDouble() * 2 - 1).clamp(-2, 2);
        altitude = (altitude + verticalSpeed).clamp(0, 500);

        // Ground speed tied to activity
        groundSpeed = (groundSpeed + (_random.nextDouble() - 0.5))
            .clamp(0, 20);

        // Battery drain proportional to current
        current = 6 + groundSpeed * 0.4;
        voltage = (voltage - 0.005).clamp(13.5, 16.8);
        consumed += current * 0.0003;
        battery = (battery - 1).clamp(0, 100);
      }

      if (battery <= 20 && battery > 10 && !_lowBatteryWarned) {
        alertService.triggerAlert(context, AlertLevel.warning, "Battery Low: $battery%");
        _lowBatteryWarned = true;
      }
      else if (battery <= 10 && !_criticalBatteryWarned) {
        alertService.triggerAlert(context, AlertLevel.critical, "CRITICAL BATTERY: $battery%");
        _criticalBatteryWarned = true;
      }

      gps = 10 + _random.nextInt(8);
      if (gps < 11 && !_gpsLostWarned) {
        alertService.triggerAlert(context, AlertLevel.warning, "GPS Signal Weak: $gps Sats");
        _gpsLostWarned = true;
      }

      // 4. Connection Lost (Rare dip simulation)
      if (signal < 65 && !_signalLostWarned) {
        alertService.triggerAlert(context, AlertLevel.critical, "LINK QUALITY DEGRADED: $signal%");
        _signalLostWarned = true;
      }

      // Reset flags if battery is recharged (for your simulation loop)
      if (battery > 90) {
        _lowBatteryWarned = false;
        _criticalBatteryWarned = false;
      }

      if (battery < 10) {
        battery = 100;
      }

      // GPS realistic range
      gps = 10 + _random.nextInt(8); // 10–17 sats

      armed = _random.nextBool();

      // Signal affects RSSI
      const int targetSignal = 88;

      // Mean reversion
      signal += ((targetSignal - signal) * 0.15).round();

      // Small noise
      signal += _random.nextInt(5) - 2;

      // Rare dip
      if (_random.nextDouble() < 0.02) {
        signal -= 20;
      }

      // Clamp
      signal = signal.clamp(60, 100);

      // Realistic RSSI mapping
      rssi = -90 + (signal - 60);

      // Latency correlation
      latency = (200 - signal).clamp(40, 200);


      // Heading continuous rotation
      heading = (heading + _random.nextInt(10)) % 360;

      notifyListeners();
    });
  }

  void disposeController() {
    _timer.cancel();
  }
}
