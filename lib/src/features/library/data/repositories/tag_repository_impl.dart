import 'package:isar/isar.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
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
  Future<List<Tag>> fetchTags() async {
    return await isar.tags.where().findAll();
  }

  @override
  Future<void> assignTags(Book book, List<Tag> tags) async {
    book.tags.addAll(tags);

    await isar.writeTxn(() async {
      await book.tags.save();
    });
  }

  @override
  Future<void> unassignTags(Book book, List<Tag> tags) async {
    book.tags.removeAll(tags);

    await isar.writeTxn(() async {
      await book.tags.save();
    });
  }
}
