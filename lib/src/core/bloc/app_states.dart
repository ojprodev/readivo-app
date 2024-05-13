import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:readivo_app/src/features/library/presentation/screens/library_home_screen.dart';

abstract class AppStates extends Equatable {
  @override
  List<Object> get props => [];
}

class AppInitState extends AppStates {}

class AppScreenChangedState extends AppStates {
  static Widget nextScreen = const LibraryHomeScreen();

  AppScreenChangedState(Widget screen) {
    nextScreen = screen;
  }
}
