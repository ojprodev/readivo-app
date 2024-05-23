import 'dart:io';

import 'package:readivo_app/src/features/library/data/local/models/local_book.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/repositories/local_book_repository.dart';
import 'package:readivo_app/src/features/library/domain/repositories/remote_book_repository.dart';

class SearchBooksUseCase {
  final RemoteBookRepository remoteBookRepository;
  final LocalBookRepository localBookRepository;

  SearchBooksUseCase(
      {required this.remoteBookRepository, required this.localBookRepository});

  Future<List<Book>> onlineSearch(String query) async {
    return await remoteBookRepository.searchBooks(query);
  }

  Future<LocalBook?> scanBook(FileSystemEntity file) async {
    return await localBookRepository.scanBook(file);
  }

  Future<void> addBook(Book book) async {
    return await localBookRepository.addBook(book);
  }

  Future<List<Book>?> getBooks({bool localOnly = false}) async {
    return await localBookRepository.getAllBooks(localOnly: localOnly);
  }
}
