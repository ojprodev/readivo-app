import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/tag.dart';

abstract class TagRepository {
  Future<void> addTag(String tagName);
  Future<List<Tag>> fetchTags();
  Future<void> assignTags(Book book, List<Tag> tags);
  Future<void> unassignTags(Book book, List<Tag> tags);
}
