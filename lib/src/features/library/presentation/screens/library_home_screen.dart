import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/features/settings/presentation/screens/settings_screen.dart';

class LibraryHomeScreen extends StatelessWidget {
  const LibraryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BasicLayout(
      title: 'Good Evening',
      body: Center(
        child: TextButton(
          child: const Text('Settings'),
          onPressed: () => appCubit.changeScreen(
            screen: const SettingsScreen(),
          ),
        ),
      ),
    );
  }
}
