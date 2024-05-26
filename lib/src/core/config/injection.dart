// lib/core/config/injection.dart
library dependency_injection;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:readivo_app/src/core/services/database_service.dart';
import 'package:readivo_app/src/core/services/permission_service.dart';
import 'package:readivo_app/src/core/services/file_system_service.dart';
import 'package:readivo_app/src/features/library/data/remote/data_sources/remote_book_data_source.dart';
import 'package:readivo_app/src/features/library/data/repositories/local_book_repository_impl.dart';
import 'package:readivo_app/src/features/library/data/repositories/remote_book_repository_impl.dart';
import 'package:readivo_app/src/features/library/domain/repositories/local_book_repository.dart';
import 'package:readivo_app/src/features/library/domain/repositories/remote_book_repository.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/books_use_case.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_cubit.dart';

class DependencyInjection {
  // init get_it
  static final GetIt getIt = GetIt.instance;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // register dependencies
    _setDependencies();
  }

  static void _setDependencies() async {
    Isar isar = await DatabaseService.initIsar();
    // Dio
    getIt.registerLazySingleton(() => Dio());

    // Isar
    getIt.registerLazySingleton(() => isar);

    // Permission Service
    getIt.registerLazySingleton<PermissionService>(() => PermissionService());

    // System IO Service
    getIt.registerLazySingleton<FileSystemService>(() => FileSystemService());

    // Data Sources
    getIt.registerLazySingleton<RemoteBookDataSource>(
        () => RemoteBookDataSourceImpl(dio: getIt()));

    // Repositories
    getIt.registerLazySingleton<RemoteBookRepository>(
        () => RemoteBookRepositoryImpl(remoteBookDataSource: getIt()));

    getIt.registerLazySingleton<LocalBookRepository>(() =>
        LocalBookRepositoryImpl(fileSystemService: getIt(), isar: getIt()));

    // Use Cases
    getIt.registerLazySingleton(() => BooksUseCase(
          localBookRepository: getIt(),
          remoteBookRepository: getIt(),
        ));

    // Cubit
    getIt.registerFactory(() => LibraryCubit(
          booksUseCase: getIt(),
          permissionService: getIt(),
          fileSystemService: getIt(),
        ));
  }
}
