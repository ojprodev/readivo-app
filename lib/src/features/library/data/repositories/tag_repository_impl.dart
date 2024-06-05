import 'package:isar/isar.dart';
import 'package:readivo_app/src/features/library/domain/entities/tag.dart';
import 'package:readivo_app/src/features/library/domain/repositories/tag_repository.dart';

class TagRepositoryImpl extends TagRepository {
  final Isar isar;

  TagRepositoryImpl({required this.isar});

  @override
  Future<void> addTag(String tagName) async {
    Tag tag = Tag(name: tagName, createdAt: DateTime.now());
    await isar.writeTxn(() async {
      await isar.tags.put(tag);
    });
  }

  @override
  Future<List<Tag>> fetchTags() async{
    return await isar.tags.where().findAll();
  }
}
