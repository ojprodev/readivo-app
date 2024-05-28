import 'package:isar/isar.dart';

part 'note.g.dart';

enum NoteCategory{
  quote, thought, question, smmary
}

@collection
@Name('notes')
class Note{
  Id id = Isar.autoIncrement;
  late String content;
  @Enumerated(EnumType.name)
  late NoteCategory noteCategory;
  late String? author;
  late int reads;
  late bool isFavorite;

  late DateTime? updatedAt;
  late DateTime createdAt;
}