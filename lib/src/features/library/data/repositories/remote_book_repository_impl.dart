import 'package:readivo_app/src/features/library/data/remote/data_sources/remote_book_data_source.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/repositories/remote_book_repository.dart';

class RemoteBookRepositoryImpl implements RemoteBookRepository{
  final RemoteBookDataSource remoteBookDataSource;

  RemoteBookRepositoryImpl({required this.remoteBookDataSource});

  @override
  Future<List<Book>> searchBooks(String query) async {
    return await remoteBookDataSource.searchBooks(query);
  }
}