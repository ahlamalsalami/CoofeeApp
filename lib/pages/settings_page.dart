import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
    );
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: Colors.brown,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider
                          : null,
                  child:
                      _profileImage == null
                          ? const Icon(
                            Icons.person,
                            size: 46,
                            color: Colors.brown,
                          )
                          : null,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('اختر صورة الملف الشخصي'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const ListTile(leading: Icon(Icons.language), title: Text('اللغة')),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('الإشعارات'),
          ),
          const ListTile(leading: Icon(Icons.info), title: Text('حول التطبيق')),
        ],
      ),
    );
  }
}
