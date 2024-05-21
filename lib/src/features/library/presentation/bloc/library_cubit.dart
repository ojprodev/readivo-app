import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/features/library/domain/entities/book_entity.dart';
import 'package:readivo_app/src/features/library/domain/use_cases/search_books_use_case.dart';

part 'library_states.dart';
part 'library_events.dart';

class LibraryCubit extends Cubit<LibraryStates> {
  final SearchBooksUseCase searchBooksUseCase;

  LibraryCubit({required this.searchBooksUseCase}) : super(LibraryInitState());

  static LibraryCubit get(context) => BlocProvider.of(context);

  void changeSearchSource(SearchSourceEnums source) {
    emit(LibraryChangeSearchSourceState(source));
  }

  void toggleSearchDisplayOption() {
    if(LibraryStates.searchDisplayOption == SearchDisplayOption.list){
      emit(LibraryChangeSearchDisplayOptionState(SearchDisplayOption.grid));
    }else{
      emit(LibraryChangeSearchDisplayOptionState(SearchDisplayOption.list));
    }
  }

  void search(String query) async {
    emit(LibrarySearchLoadingState());

    final books = await searchBooksUseCase(query);

    emit(LibrarySearchLoadedState(books));
  }
}
