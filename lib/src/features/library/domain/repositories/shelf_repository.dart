import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/shelf.dart';

abstract class ShelfRepository{
  Future<void> addShelf(String shelfName);
  Future<List<Shelf>> fetchShelves();
  Future<void> assignShelves(Book book, List<Shelf> shelves);
  Future<void> unassignShelves(Book book, List<Shelf> shelves);
}