import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readivo_app/src/core/enums/enums.dart';

import 'library_states.dart';

class LibraryCubit extends Cubit<LibraryStates> {

  LibraryCubit() : super(LibraryInitState());

  static LibraryCubit get(context) => BlocProvider.of(context);

  void changeSearchSource(SearchSourceEnums source) {
    emit(LibraryChangeSearchSource(source));
  }

  void toggleSearchDisplayOption() {
    if(LibraryStates.searchDisplayOption == SearchDisplayOption.list){
      emit(LibraryChangeSearchDisplayOption(SearchDisplayOption.grid));
    }else{
      emit(LibraryChangeSearchDisplayOption(SearchDisplayOption.list));
    }
  }
}
