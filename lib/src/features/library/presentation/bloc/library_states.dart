part of 'library_cubit.dart';

abstract class LibraryStates extends Equatable {

  @override
  List<Object> get props => [];
}

class LibraryInitState extends LibraryStates {}

class LibrarySearchLoadingState extends LibraryStates {}

class LibrarySearchLoadedState extends LibraryStates {
  final List<BookEntity> books;

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
