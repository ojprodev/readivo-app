import 'package:readivo_app/src/features/library/domain/entities/book_entity.dart';
import 'package:readivo_app/src/features/library/domain/repositories/remote_book_repository.dart';

class SearchBooksUseCase{
  final RemoteBookRepository remoteBookRepository;

  SearchBooksUseCase({required this.remoteBookRepository});

  Future<List<BookEntity>> call(String query) async{
    return await remoteBookRepository.searchBooks(query);
  }
}