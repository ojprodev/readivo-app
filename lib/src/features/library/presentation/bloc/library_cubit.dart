import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/core/services/permission_service.dart';
import 'package:readivo_app/src/core/services/file_system_service.dart';
import 'package:readivo_app/src/features/library/data/local/models/local_book.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/search_books_use_case.dart';

part 'library_states.dart';

class LibraryCubit extends Cubit<LibraryStates> {
  final PermissionService permissionService;
  final FileSystemService fileSystemService;
  final SearchBooksUseCase searchBooksUseCase;

  BookSourceEnums bookSource = BookSourceEnums.online;
  List<Book> books = [];
  List<Book> localBooks = [];
  List<Book> remoteBooks = [];

  LibraryCubit({
    required this.searchBooksUseCase,
    required this.permissionService,
    required this.fileSystemService,
  }) : super(LibraryInitState());

  static LibraryCubit get(context) => BlocProvider.of(context);

  // search for books
  void search(String query) async {
    emit(LibrarySearchLoadingState());

    // check the source
    if (bookSource == BookSourceEnums.online) {
      // perform search
      remoteBooks = await searchBooksUseCase.onlineSearch(query);

      emit(LibrarySearchLoadedState(remoteBooks));
    } else {
      // search on the localBooks list
      List<Book> localResult = localBooks
          .where((book) =>
              book.title.toLowerCase().contains(query.toLowerCase()) ||
              (book.author != null && book.author!.contains(query.toLowerCase())))
          .toList();

      emit(LibrarySearchLoadedState(localResult));
    }
  }

  // change book search source
  void changeBookSearchSource(BookSourceEnums source) {
    bookSource = source;

    emit(LibraryBookSourceChangeState(source));
  }

  Future<bool> handleStoragePermission(
      {required PermissionAction action}) async {
    bool permissionGranted;
    // perform based on the selected action
    if (action == PermissionAction.request) {
      permissionGranted = await permissionService.requestStoragePermission();
    } else {
      permissionGranted = await permissionService.checkStoragePermission();
    }

    // emit status state
    if (permissionGranted == true) {
      emit(LibraryStoragePermissionGrantedState());
    } else {
      emit(LibraryStoragePermissionDeniedState());
    }

    return permissionGranted;
  }

  Future<void> performLocalBooksScanning() async {
    // emit scan loading
    emit(LibrarySearchLoadingState());

    // scan all existing books in the storage
    List<FileSystemEntity> collectedFiles =
        await fileSystemService.collectFiles();

    for (FileSystemEntity file in collectedFiles) {
      // only process if the book is new
      if (!localBooks.any((book) => book.path == file.path)) {
        // collect book data
        LocalBook? detectedBook = await searchBooksUseCase.scanBook(file);

        if (detectedBook != null) {
          // add the book to the database
          await searchBooksUseCase.addBook(detectedBook);

          // add to the local list
          localBooks.add(detectedBook);

          // emit new detect state
          emit(LibraryNewBookDetectedState(detectedBook));
        }
      }
    }

    // finish scanning
    emit(LibrarySearchLoadedState(localBooks));
  }

  Future<void> getLocalBooks() async {
    // emit scan loading
    emit(LibrarySearchLoadingState());

    // search in the database
    searchBooksUseCase
        .getBooks(localOnly: true)
        .whenComplete(() => null)
        .then((books) {
      if (books != null && books.isNotEmpty) {
        // fill the local books
        localBooks = books;
      }
    }).then((_) => emit(LibrarySearchLoadedState(localBooks)));
  }
}
