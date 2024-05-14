import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/bloc/app_states.dart';
import 'package:readivo_app/src/core/layouts/basic_layout.dart';
import 'package:readivo_app/src/features/settings/presentation/screens/settings_screen.dart';

class LibraryHomeScreen extends StatefulWidget {
  const LibraryHomeScreen({super.key});

  @override
  State<LibraryHomeScreen> createState() => _LibraryHomeScreenState();
}

class _LibraryHomeScreenState extends State<LibraryHomeScreen> {
  late AppCubit appCubit;

  @override
  void initState() {
    super.initState();

    appCubit = AppCubit.get(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: _buildHomeScreen,
      listener: _buildListener,
    );
  }

  Widget _buildHomeScreen(BuildContext context, state) {
    return BasicLayout(
      title: 'Good Evening',
      showBackButton: false,
      body: Center(
        child: TextButton(
          child: const Text('Settings'),
          onPressed: () {
            appCubit.changeScreen(screen: const SettingsScreen());
          },
        ),
      ),
    );
  }

  void _buildListener(BuildContext context, state) {}
}
