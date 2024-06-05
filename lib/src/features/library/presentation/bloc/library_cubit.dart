import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/core/services/file_system_service.dart';
import 'package:readivo_app/src/core/services/permission_service.dart';
import 'package:readivo_app/src/features/library/data/local/models/local_book.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/shelf.dart';
import 'package:readivo_app/src/features/library/domain/entities/tag.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/books_use_case.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/shelf_use_case.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/tag_use_case.dart';

part 'library_states.dart';

class LibraryCubit extends Cubit<LibraryStates> {
  final PermissionService permissionService;
  final FileSystemService fileSystemService;
  final BooksUseCase booksUseCase;
  final TagUseCase tagUseCase;
  final ShelfUseCase shelfUseCase;

  BookSourceEnums bookSource = BookSourceEnums.online;
  List<Book> books = [];
  List<Book> localBooks = [];
  List<Book> remoteBooks = [];
  List<Tag> tagsList = [];
  List<Shelf> shelvesList = [];
  bool isLoading = false;

  LibraryCubit({
    required this.booksUseCase,
    required this.permissionService,
    required this.fileSystemService,
    required this.tagUseCase,
    required this.shelfUseCase,
  }) : super(LibraryInitState());

  static LibraryCubit get(BuildContext context) =>
      BlocProvider.of<LibraryCubit>(context);

  void setIsLoading(bool state) => isLoading = state;

  // Search for books
  void search(String query) async {
    emit(LibrarySearchLoadingState());

    if (bookSource == BookSourceEnums.online) {
      remoteBooks = await booksUseCase.onlineSearch(query);
      emit(LibrarySearchLoadedState(remoteBooks));
    } else {
      List<Book> localResult = localBooks
          .where((book) =>
              book.title.toLowerCase().contains(query.toLowerCase()) ||
              (book.author != null &&
                  book.author!.contains(query.toLowerCase())))
          .toList();
      emit(LibrarySearchLoadedState(localResult));
    }
  }

  // Change book search source
  void changeBookSearchSource(BookSourceEnums source) {
    bookSource = source;
    emit(LibraryBookSourceChangeState(source));
  }

  Future<bool> handleStoragePermission(
      {required PermissionAction action}) async {
    bool permissionGranted;

    if (action == PermissionAction.request) {
      permissionGranted = await permissionService.requestStoragePermission();
    } else {
      permissionGranted = await permissionService.checkStoragePermission();
    }

    if (permissionGranted) {
      emit(LibraryStoragePermissionGrantedState());
    } else {
      emit(LibraryStoragePermissionDeniedState());
    }

    return permissionGranted;
  }

  Future<void> performLocalBooksScanning() async {
    if (!isLoading) {
      isLoading = true;

      emit(LibrarySearchLoadingState());

      // Ensure localBooks is initialized and up-to-date
      List<Book> localBooks = await booksUseCase.getBooks(localOnly: true);
      Set<String?> localBookPaths = localBooks.map((book) => book.path).toSet();

      List<FileSystemEntity> collectedFiles =
          await fileSystemService.collectFiles();

      for (FileSystemEntity file in collectedFiles) {
        if (!localBookPaths.contains(file.path)) {
          LocalBook? detectedBook = await booksUseCase.scanBook(file);

          if (detectedBook != null) {
            await booksUseCase.addBook(detectedBook);
            localBooks.add(detectedBook);
            localBookPaths.add(detectedBook.path);
            emit(LibraryNewBookDetectedState(detectedBook));
          }
        }
      }
      emit(LibrarySearchLoadedState(localBooks));

      isLoading = false;
    } else {
      emit(LibraryScanningAlreadyInProgress());
    }
  }

  Future<void> getLocalBooks() async {
    emit(LibrarySearchLoadingState());

    booksUseCase.getBooks(localOnly: true).then((books) {
      if (books.isNotEmpty) {
        localBooks = books;
      }
      emit(LibrarySearchLoadedState(localBooks));
    });
  }

  Future<void> updateBook(Book book) async {
    if (book.source == BookSourceEnums.online) {
      Book? alreadyAddedBook = await booksUseCase.bookExist(book);

      if (alreadyAddedBook != null) {
        book.id = alreadyAddedBook.id;
        book.updatedAt = DateTime.now();
        booksUseCase.updateBook(book).then((_) => print('book updated'));
      } else {
        String? thumbnailPath = await booksUseCase.saveBookThumbnail(book);

        if (thumbnailPath != null) {
          book.coverURI = thumbnailPath;
        }
        booksUseCase.addBook(book).then((_) => print('book added'));
      }
    } else {
      booksUseCase.updateBook(book).then((_) => print('book updated'));
    }
  }

  Future<void> getReadingBooks() async {
    List<Book> readingList =
        await booksUseCase.getBooks(status: ReadingStatus.reading);
    emit(LibraryFetchedReadingListState(readingList));
  }

  Future<void> newTag(String tagName) async {
    tagUseCase.newTag(tagName);
  }

  Future<void> fetchTags() async {
    tagsList = await tagUseCase.fetchTags();
  }

  Future<void> assignTags(Book book, List<Tag> tags) async {
    await tagUseCase.assignTags(book, tags);
  }

  Future<void> unassignTags(Book book, List<Tag> tags) async {
    await tagUseCase.unassignTags(book, tags);
  }

  // shelves
  Future<void> newShelf(String tagName) async {
    shelfUseCase.newShelf(tagName);
  }

  Future<void> fetchShelves() async {
    shelvesList = await shelfUseCase.fetchShelves();
  }

  Future<void> assignShelves(Book book, List<Shelf> shelves) async {
    await shelfUseCase.assignShelves(book, shelves);
  }

  Future<void> unassignShelves(Book book, List<Shelf> shelves) async {
    await shelfUseCase.unassignShelves(book, shelves);
  }
}
