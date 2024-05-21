part of 'library_cubit.dart';

abstract class LibraryEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class LibrarySearchEvent extends LibraryEvents{
  final String query;

  LibrarySearchEvent(this.query);

  @override
  List<Object> get props => [query];
}