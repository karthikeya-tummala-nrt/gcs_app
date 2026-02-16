import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/alert.dart';

class AlertService extends ChangeNotifier {
  final List<Alert> _history = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Alert> get recentAlerts => List.unmodifiable(_history.reversed.take(10));

  void triggerAlert(BuildContext context, AlertLevel level, String message) {
    final alert = Alert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      level: level,
      message: message,
      timestamp: DateTime.now(),
    );
    _history.add(alert);
    notifyListeners();

    if (level == AlertLevel.info || level == AlertLevel.warning) {
      _showSnackBar(context, alert);
    } else {
      _playAudio();
      _showAlertDialog(context, alert);
    }
  }

  void _showSnackBar(BuildContext context, Alert alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(alert.message),
        backgroundColor: alert.color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showAlertDialog(BuildContext context, Alert alert) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(alert.level.name.toUpperCase(), style: TextStyle(color: alert.color)),
        content: Text(alert.message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ACKNOWLEDGE")),
        ],
      ),
    );
  }

  void _playAudio() async {
    await _audioPlayer.play(AssetSource('sounds/alert_critical.mp3'));
  }
}

