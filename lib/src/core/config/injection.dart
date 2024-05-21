// lib/core/config/injection.dart
library dependency_injection;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:readivo_app/src/features/library/data/remote/data_sources/remote_book_data_source.dart';
import 'package:readivo_app/src/features/library/data/repositories/remote_book_repository_impl.dart';
import 'package:readivo_app/src/features/library/domain/repositories/remote_book_repository.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/search_books_use_case.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_cubit.dart';

class DependencyInjection {
  // init get_it
  static final GetIt getIt = GetIt.instance;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // register dependencies
    _setDependencies();
  }

  static void _setDependencies() {
    // Dio
    getIt.registerLazySingleton(() => Dio());

    // Data Sources
    getIt.registerLazySingleton<RemoteBookDataSource>(
        () => RemoteBookDataSourceImpl(dio: getIt()));

    // Repositories
    getIt.registerLazySingleton<RemoteBookRepository>(
        () => RemoteBookRepositoryImpl(remoteBookDataSource: getIt()));

    // Use Cases
    getIt.registerLazySingleton(
        () => SearchBooksUseCase(remoteBookRepository: getIt()));

    // Cubit
    getIt.registerFactory(() => LibraryCubit(searchBooksUseCase: getIt()));
  }
}
