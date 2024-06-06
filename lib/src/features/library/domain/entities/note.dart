import 'package:isar/isar.dart';

part 'note.g.dart';

enum NoteCategoryEnum { quote, thought, question, summary }

@collection
@Name('notes')
class Note {
  Id id = Isar.autoIncrement;
  String content;
  @Enumerated(EnumType.name)
  late NoteCategoryEnum noteCategory;
  late String? author;
  late int reads;
  late bool isFavorite;

  late DateTime? updatedAt;
  late DateTime createdAt;

  Note({
    required this.content,
    required this.noteCategory,
    this.author,
    this.reads = 0,
    this.isFavorite = false,
    this.updatedAt,
    required this.createdAt,
  });
}
