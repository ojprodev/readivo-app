import 'package:isar/isar.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';

part 'shelf.g.dart';


@collection
@Name('shelves')
class Shelf{
  Id id = Isar.autoIncrement;
  late String name;
  late String? description;
  late DateTime? updatedAt;
  late DateTime createdAt;

  // links
  @Backlink(to: 'shelves')
  final books = IsarLinks<Book>();
}