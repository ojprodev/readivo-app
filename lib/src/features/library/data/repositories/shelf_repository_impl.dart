import 'package:isar/isar.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/shelf.dart';
import 'package:readivo_app/src/features/library/domain/repositories/shelf_repository.dart';

class ShelfRepositoryImpl extends ShelfRepository {
  final Isar isar;

  ShelfRepositoryImpl({ required this.isar});

  @override
  Future<void> addShelf(String shelfName) async {
    Shelf shelf = Shelf(name: shelfName, createdAt: DateTime.now());
    await isar.writeTxn(() async {
      await isar.shelfs.put(shelf);
    });
  }

  @override
  Future<List<Shelf>> fetchShelves() async {
    return await isar.shelfs.where().findAll();
  }

  @override
  Future<void> assignShelves(Book book, List<Shelf> shelves) async {
    book.shelves.addAll(shelves);

    await isar.writeTxn(() async {
      await book.shelves.save();
    });
  }

  @override
  Future<void> unassignShelves(Book book, List<Shelf> shelves) async {
    book.shelves.removeAll(shelves);

    await isar.writeTxn(() async {
      await book.shelves.save();
    });
  }

  @override
  Future<int> totalBooks(Shelf shelf) async {
    return shelf.books.length;
  }
}
