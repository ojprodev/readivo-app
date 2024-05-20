import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readivo_app/src/core/bloc/app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());

  // create cubit instance
  static AppCubit get(context) => BlocProvider.of(context);

  // change screen
  void changeScreen(Widget screen) {
    // emit the a change event, so that can be handled later in the main bloc consumer
    emit(AppScreenChangedState(screen));
  }
}