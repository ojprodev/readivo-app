import 'package:readivo_app/src/core/enums/enums.dart';

abstract class LibraryStates {
  static SearchSourceEnums searchSource = SearchSourceEnums.online;
  static SearchDisplayOption searchDisplayOption = SearchDisplayOption.list;
}

class LibraryInitState extends LibraryStates {}

class LibraryChangeSearchSource extends LibraryStates {
  LibraryChangeSearchSource(SearchSourceEnums newSource) {
    LibraryStates.searchSource = newSource;
  }
}

class LibraryChangeSearchDisplayOption extends LibraryStates {
  LibraryChangeSearchDisplayOption(SearchDisplayOption newOption) {
    LibraryStates.searchDisplayOption = newOption;
  }
}
