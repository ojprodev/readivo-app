import 'package:readivo_app/src/features/library/data/remote/data_sources/remote_book_data_source.dart';
import 'package:readivo_app/src/features/library/domain/entities/book_entity.dart';
import 'package:readivo_app/src/features/library/domain/repositories/remote_book_repository.dart';

class RemoteBookRepositoryImpl implements RemoteBookRepository{
  final RemoteBookDataSource remoteBookDataSource;

  RemoteBookRepositoryImpl({required this.remoteBookDataSource});

  @override
  Future<List<BookEntity>> searchBooks(String query) async {
    return await remoteBookDataSource.searchBooks(query);
  }
}