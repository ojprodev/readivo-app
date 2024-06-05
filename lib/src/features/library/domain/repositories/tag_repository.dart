import 'package:readivo_app/src/features/library/domain/entities/tag.dart';

abstract class TagRepository {
  Future<void> addTag(String tagName);
  Future<List<Tag>> fetchTags();
}
