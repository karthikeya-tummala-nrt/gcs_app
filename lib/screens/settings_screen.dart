import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive data from route arguments
    final String pageTitle = ModalRoute.of(context)?.settings.arguments as String? ?? "Settings";

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.wifi), title: Text("Datalink Frequency")),
          ListTile(leading: Icon(Icons.storage), title: Text("Offline Map Cache")),
        ],
      ),
    );
  }
}