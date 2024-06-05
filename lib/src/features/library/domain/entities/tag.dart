import 'package:isar/isar.dart';

part 'tag.g.dart';

@collection
@Name('tags')
class Tag {
  Id id = Isar.autoIncrement;
  late String name;
  late DateTime? updatedAt;
  late DateTime createdAt;

  Tag({required this.name, this.updatedAt, required this.createdAt});
}
