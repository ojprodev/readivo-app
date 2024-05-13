import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readivo_app/src/core/bloc/app_cubit.dart';
import 'package:readivo_app/src/core/bloc/app_states.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(create: (context) => AppCubit())
      ],
      child: MaterialApp(
        title: 'Readivo',
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AppCubit, AppStates>(
          builder: (context, state) => _buildContent(context, state),
          listener: (context, state) => _handleStateChange(context, state),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppStates state) {
    return const LibraryHomeScreen();
  }

  void _handleStateChange(BuildContext context, AppStates state) {
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
