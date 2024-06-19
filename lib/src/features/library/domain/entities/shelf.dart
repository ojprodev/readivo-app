import 'package:isar/isar.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';

part 'shelf.g.dart';


@collection
@Name('shelves')
class Shelf{
  Id id = Isar.autoIncrement;
  late String name;
  late int totalBooks = 0;
  late String? description;
  late DateTime? updatedAt;
  late DateTime createdAt;

  // links
  @Backlink(to: 'shelves')
  final books = IsarLinks<Book>();

  Shelf({required this.name, this.description, this.updatedAt, required this.createdAt});
}