import 'dart:io';

import 'package:readivo_app/src/features/library/data/local/models/local_book.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';

abstract class LocalBookRepository {
  Future<LocalBook?> scanBook(FileSystemEntity file);

  Future<void> addBook(Book book);

  Future<Book?> readBook(int id);

  Future<void> updateBook(Book book);

  Future<void> deleteBook(int id);

  Future<List<Book>> getAllBooks();
}
