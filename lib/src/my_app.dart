import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/bloc/app_states.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_cubit.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(create: (context) => AppCubit()),
        BlocProvider<LibraryCubit>(create: (context) => LibraryCubit()),
      ],
      child: MaterialApp(
        title: 'Readivo',
        home: BlocConsumer<AppCubit, AppStates>(
          builder: _buildContent,
          listener: _handleStateChange,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppStates state) {
    return const LibraryHomeScreen();
  }

  void _handleStateChange(BuildContext context, state) {
    // handle screen change
    if (state is AppScreenChangedState) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AppScreenChangedState.nextScreen,
        ),
      );
    }
  }
}
