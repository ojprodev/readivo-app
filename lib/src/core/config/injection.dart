// lib/core/config/injection.dart
library dependency_injection;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:readivo_app/src/core/services/database_service.dart';
import 'package:readivo_app/src/core/services/file_system_service.dart';
import 'package:readivo_app/src/core/services/permission_service.dart';
import 'package:readivo_app/src/features/library/data/remote/data_sources/remote_book_data_source.dart';
import 'package:readivo_app/src/features/library/data/repositories/local_book_repository_impl.dart';
import 'package:readivo_app/src/features/library/data/repositories/note_repository_impl.dart';
import 'package:readivo_app/src/features/library/data/repositories/reading_session_repository_impl.dart';
import 'package:readivo_app/src/features/library/data/repositories/remote_book_repository_impl.dart';
import 'package:readivo_app/src/features/library/data/repositories/shelf_repository_impl.dart';
import 'package:readivo_app/src/features/library/data/repositories/tag_repository_impl.dart';
import 'package:readivo_app/src/features/library/domain/repositories/local_book_repository.dart';
import 'package:readivo_app/src/features/library/domain/repositories/note_repository.dart';
import 'package:readivo_app/src/features/library/domain/repositories/reading_session_repository.dart';
import 'package:readivo_app/src/features/library/domain/repositories/remote_book_repository.dart';
import 'package:readivo_app/src/features/library/domain/repositories/shelf_repository.dart';
import 'package:readivo_app/src/features/library/domain/repositories/tag_repository.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/books_use_case.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/note_use_case.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/reading_session_use_case.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/shelf_use_case.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/tag_use_case.dart';
import 'package:readivo_app/src/features/library/presentation/bloc/library_cubit.dart';

class DependencyInjection {
  // init get_it
  static final GetIt getIt = GetIt.instance;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // register dependencies
    await _setDependencies();
  }

  static Future<void> _setDependencies() async {
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

    getIt.registerLazySingleton<TagRepository>(
        () => TagRepositoryImpl(isar: getIt()));

    getIt.registerLazySingleton<ShelfRepository>(
        () => ShelfRepositoryImpl(isar: getIt()));

    getIt.registerLazySingleton<NoteRepository>(
        () => NoteRepositoryImpl(isar: getIt()));

    getIt.registerLazySingleton<ReadingSessionRepository>(
        () => ReadingSessionRepositoryImpl(isar: getIt()));

    // Use Cases
    getIt.registerLazySingleton(() => BooksUseCase(
          localBookRepository: getIt(),
          remoteBookRepository: getIt(),
        ));

    getIt.registerLazySingleton(() => TagUseCase(tagRepository: getIt()));
    getIt.registerLazySingleton(() => ShelfUseCase(shelfRepository: getIt()));
    getIt.registerLazySingleton(() => NoteUseCase(noteRepository: getIt()));
    getIt.registerLazySingleton(
        () => ReadingSessionUseCase(readingSessionRepository: getIt()));

    // Cubits
    getIt.registerFactory<LibraryCubit>(() => LibraryCubit(
          booksUseCase: getIt(),
          permissionService: getIt(),
          fileSystemService: getIt(),
          tagUseCase: getIt(),
          shelfUseCase: getIt(),
          noteUseCase: getIt(),
          readingSessionUseCase: getIt(),
        ));
  }
}
