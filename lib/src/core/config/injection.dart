library dependency_injection;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DependencyInjection {
  // init get_it
  static final GetIt getIt = GetIt.instance;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // register dependencies
    _setDependencies();
  }

  static void _setDependencies() {

  }
}
