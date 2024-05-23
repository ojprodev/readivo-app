import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:readivo_app/src/core/bloc/bloc_observer.dart';
import 'package:readivo_app/src/core/config/config.dart';
import 'package:readivo_app/src/my_app.dart';

void main() async {
  // insure flutter app initialization
  WidgetsFlutterBinding.ensureInitialized();

  // initialize dependency injection
  await DependencyInjection.init();

  // Initialize Isar
  await Isar.initializeIsarCore();

  // init bloc observer
  Bloc.observer = MyBlocObserver();

  // run the application
  runApp(const MyApp());
}
