import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/core/services/file_system_service.dart';
import 'package:readivo_app/src/core/services/permission_service.dart';
import 'package:readivo_app/src/features/library/data/local/models/local_book.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/books_use_case.dart';

part 'library_states.dart';

class LibraryCubit extends Cubit<LibraryStates> {
  final PermissionService permissionService;
  final FileSystemService fileSystemService;
  final BooksUseCase booksUseCase;

  BookSourceEnums bookSource = BookSourceEnums.online;
  List<Book> books = [];
  List<Book> localBooks = [];
  List<Book> remoteBooks = [];

  LibraryCubit({
    required this.booksUseCase,
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
      remoteBooks = await booksUseCase.onlineSearch(query);

      emit(LibrarySearchLoadedState(remoteBooks));
    } else {
      // search on the localBooks list
      List<Book> localResult = localBooks
          .where((book) =>
              book.title.toLowerCase().contains(query.toLowerCase()) ||
              (book.author != null &&
                  book.author!.contains(query.toLowerCase())))
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
        LocalBook? detectedBook = await booksUseCase.scanBook(file);

        if (detectedBook != null) {
          // add the book to the database
          await booksUseCase.addBook(detectedBook);

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
    booksUseCase
        .getBooks(localOnly: true)
        .whenComplete(() => null)
        .then((books) {
      if (books != null && books.isNotEmpty) {
        // fill the local books
        localBooks = books;
      }
    }).then((_) => emit(LibrarySearchLoadedState(localBooks)));
  }

  Future<void> updateBook(Book book) async {
    // if book source is online
    if (book.source == BookSourceEnums.online) {
      // chekc if the book already saved, (using title)
      Book? alreadyAddedBook = await booksUseCase.bookExist(book);
      // if already exist
      if (alreadyAddedBook != null) {
        book.id = alreadyAddedBook.id;
        book.coverURI = alreadyAddedBook.coverURI;
        book.updatedAt = DateTime.now();

        //  updated it
        booksUseCase.updateBook(book).then((_) => print('book updated'));
        // otherwise, proccess into
      } else {
        // saving the book thumbnail
        String? thumbnailPath = await booksUseCase.saveBookThumbnail(book);
        if (thumbnailPath != null) {
          // then change the book remote url to local one
          book.coverURI = thumbnailPath;
        }
        // and finaly add the book
        booksUseCase.addBook(book).then((_) => print('book added'));
      }
    } else {
      // if not online just update it ;)
      booksUseCase.updateBook(book).then((_) => print('book updated'));
    }
  }


}
