import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: Colors.brown,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          ListTile(leading: Icon(Icons.language), title: Text('اللغة')),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('الإشعارات'),
          ),
          ListTile(leading: Icon(Icons.info), title: Text('حول التطبيق')),
        ],
      ),
    );
  }
}
