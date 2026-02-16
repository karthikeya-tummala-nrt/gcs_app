import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/alert.dart';

class AlertPanel extends StatelessWidget {
  final List<Alert> alerts;
  const AlertPanel({super.key, required this.alerts});

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return "just now";
    return "${diff.inMinutes} min ago";
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return ListTile(
          leading: Icon(Icons.warning, color: alert.color),
          title: Text(alert.message),
          trailing: Text(_formatTime(alert.timestamp), style: const TextStyle(fontSize: 10)),
        );
      },
    );
  }
}