import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasicLayout(
      title: 'Settings',
      body: Text('Settings'),
    );
  }
}
