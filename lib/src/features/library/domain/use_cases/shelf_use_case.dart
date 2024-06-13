import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/shelf.dart';
import 'package:readivo_app/src/features/library/domain/repositories/shelf_repository.dart';

class ShelfUseCase{
  final ShelfRepository shelfRepository;

  ShelfUseCase({required this.shelfRepository});

  Future<void> newShelf(String tagName) async {
    await shelfRepository.addShelf(tagName);
  }

  Future<List<Shelf>> fetchShelves() async {
    return await shelfRepository.fetchShelves();
  }

  Future<void> assignShelves(Book book, List<Shelf> shelves) async {
    return await shelfRepository.assignShelves(book, shelves);
  }

  Future<void> unassignShelves(Book book, List<Shelf> shelves) async {
    return await shelfRepository.unassignShelves(book, shelves);
  }

  Future<int> totalBooks(Shelf shelf) async {
    return await shelfRepository.totalBooks(shelf);
  }
}