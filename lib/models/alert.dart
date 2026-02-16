import 'package:flutter/material.dart';

enum AlertLevel { info, warning, critical, emergency }

class Alert {
  final String id;
  final AlertLevel level;
  final String message;
  final DateTime timestamp;

  Alert({
    required this.id,
    required this.level,
    required this.message,
    required this.timestamp,
  });

  // Maps priority to your theme's colors
  Color get color {
    switch (level) {
      case AlertLevel.info: return Colors.blueAccent;
      case AlertLevel.warning: return Colors.orange;
      case AlertLevel.critical: return Colors.red;
      case AlertLevel.emergency: return Colors.redAccent;
    }
  }

  IconData get icon {
    switch (level) {
      case AlertLevel.info: return Icons.info_outline;
      case AlertLevel.warning: return Icons.warning_amber_rounded;
      case AlertLevel.critical: return Icons.report_problem;
      case AlertLevel.emergency: return Icons.flash_on;
    }
  }
}