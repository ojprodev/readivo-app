part of 'library_cubit.dart';

abstract class LibraryStates extends Equatable {

  @override
  List<Object> get props => [];
}

class LibraryInitState extends LibraryStates {}

class LibrarySearchLoadingState extends LibraryStates {}

class LibraryStoragePermissionGrantedState extends LibraryStates {}

class LibraryStoragePermissionDeniedState extends LibraryStates {}

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

class LibraryBookSourceChangeState extends LibraryStates{
  final BookSourceEnums source;

  LibraryBookSourceChangeState(this.source);

  @override
  List<Object> get props => [source];
}

class LibraryNewBookDetectedState extends LibraryStates{
  final Book book;

  LibraryNewBookDetectedState(this.book);

  @override
  List<Object> get props => [book];
}
