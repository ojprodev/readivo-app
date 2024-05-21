part of 'library_cubit.dart';

abstract class LibraryStates extends Equatable {
  static SearchSourceEnums searchSource = SearchSourceEnums.online;
  static SearchDisplayOption searchDisplayOption = SearchDisplayOption.list;

  @override
  List<Object> get props => [];
}

class LibraryInitState extends LibraryStates {}

class LibraryChangeSearchSourceState extends LibraryStates {
  LibraryChangeSearchSourceState(SearchSourceEnums newSource) {
    LibraryStates.searchSource = newSource;
  }
}

class LibraryChangeSearchDisplayOptionState extends LibraryStates {
  LibraryChangeSearchDisplayOptionState(SearchDisplayOption newOption) {
    LibraryStates.searchDisplayOption = newOption;
  }
}

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
