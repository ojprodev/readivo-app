import 'package:flutter/material.dart';
import 'package:readivo_app/src/my_app.dart';

abstract class AppStates {}

class AppInitState extends AppStates {}

class AppScreenChangedState extends AppStates {
  static Widget nextScreen = const MyApp();
  static Widget previousScreen = const MyApp();

  AppScreenChangedState(Widget screen) {
    previousScreen = nextScreen;
    nextScreen = screen;
  }
}

