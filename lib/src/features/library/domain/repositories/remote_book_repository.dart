import 'dart:typed_data';

import 'package:readivo_app/src/features/library/domain/entities/book.dart';

abstract class RemoteBookRepository{
  Future<List<Book>> searchBooks(String query);

  Future<ByteData> downloadImageAsBytes(String url);

  Future<String?> saveBookThumbnail(Book book);
}