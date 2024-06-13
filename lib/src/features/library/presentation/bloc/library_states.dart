part of 'library_cubit.dart';

abstract class LibraryStates extends Equatable {
  @override
  List<Object> get props => [];
}

class LibraryInitState extends LibraryStates {}

class LibrarySearchLoadingState extends LibraryStates {}

class LibraryStoragePermissionGrantedState extends LibraryStates {}

class LibraryScanningAlreadyInProgress extends LibraryStates {}

class LibraryStoragePermissionDeniedState extends LibraryStates {}

class LibraryFetchedReadingListState extends LibraryStates {
  final List<Book> books;

  LibraryFetchedReadingListState(this.books);

  @override
  List<Object> get props => [books];
}

class LibrarySearchLoadedState extends LibraryStates {
  final List<Book> books;

  LibrarySearchLoadedState(this.books);

  @override
  List<Object> get props => [books];
}

class LibrarySearchErrorState extends LibraryStates {
  final String message;

  LibrarySearchErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class LibraryBookSourceChangeState extends LibraryStates {
  final BookSourceEnums source;

  LibraryBookSourceChangeState(this.source);

  @override
  List<Object> get props => [source];
}

class LibraryNewBookDetectedState extends LibraryStates {
  final Book book;

  LibraryNewBookDetectedState(this.book);

  @override
  List<Object> get props => [book];
}

class LibraryNewNoteAddedState extends LibraryStates {
  final Note note;

  LibraryNewNoteAddedState({required this.note});

  @override
  List<Object> get props => [note];
}

class LibraryShelvesListLoaded extends LibraryStates{
  final List<dynamic> shelves;

  LibraryShelvesListLoaded({required this.shelves});

  @override
  List<Object> get props => [shelves];
}