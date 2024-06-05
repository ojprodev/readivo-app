import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/tag.dart';
import 'package:readivo_app/src/features/library/domain/repositories/tag_repository.dart';

class TagUseCase {
  final TagRepository tagRepository;

  TagUseCase({required this.tagRepository});

  Future<void> newTag(String tagName) async {
    await tagRepository.addTag(tagName);
  }

  Future<List<Tag>> fetchTags() async {
    return await tagRepository.fetchTags();
  }

  Future<void> assignTags(Book book, List<Tag> tags) async {
    return await tagRepository.assignTags(book, tags);
  }

  Future<void> unassignTags(Book book, List<Tag> tags) async {
    return await tagRepository.unassignTags(book, tags);
  }
}
