import 'dart:io';

import 'package:isar/isar.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/core/services/file_system_service.dart';
import 'package:readivo_app/src/features/library/data/local/models/local_book.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/repositories/local_book_repository.dart';

class LocalBookRepositoryImpl extends LocalBookRepository {
  final FileSystemService fileSystemService;
  final Isar isar;

  LocalBookRepositoryImpl({
    required this.fileSystemService,
    required this.isar,
  });

  @override
  Future<LocalBook?> scanBook(FileSystemEntity file) async {
    LocalBook? book = await fileSystemService.generateBookData(file);

    return book;
  }

  @override
  Future<void> addBook(Book book) async {
    await isar.writeTxn(() async {
      await isar.books.put(book);
    });
  }

  @override
  Future<void> deleteBook(int id) async {
    await isar.writeTxn(() async {
      await isar.books.delete(id);
    });
  }

  @override
  Future<List<Book>> getAllBooks({bool localOnly = false}) async {
    if(localOnly){
      return await isar.books.filter().sourceEqualTo(BookSourceEnums.local).findAll();
    }else{
      return await isar.books.where().findAll();
    }
  }

  @override
  Future<Book?> readBook(int id) async {
    return await isar.books.get(id);
  }

  @override
  Future<void> updateBook(Book book) async {
    await isar.writeTxn(() async {
      await isar.books.put(book);
    });
  }
}
