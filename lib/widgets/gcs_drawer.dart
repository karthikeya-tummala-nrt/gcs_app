import 'dart:ui';
import 'package:flutter/material.dart';

class GCSDrawer extends StatelessWidget {
  const GCSDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent.withValues(alpha: 0.1)),
              currentAccountPicture: const CircleAvatar(child: Icon(Icons.person_outline)),
              accountName: const Text("PILOT_ALPHA"),
              accountEmail: const Text("operator@gcs.internal"),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("SETTINGS"),
              onTap: () => Navigator.pushNamed(context, '/settings', arguments: 'GCS System Settings'),
            ),
          ],
        ),
      ),
    );
  }
}