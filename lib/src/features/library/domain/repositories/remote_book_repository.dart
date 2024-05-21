import 'package:readivo_app/src/features/library/domain/entities/book_entity.dart';

abstract class RemoteBookRepository{
  Future<List<BookEntity>> searchBooks(String query);
}