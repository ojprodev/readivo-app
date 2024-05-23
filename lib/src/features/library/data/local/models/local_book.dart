import 'package:readivo_app/src/features/library/domain/entities/book.dart';

class LocalBook extends Book {
  LocalBook({
    required super.title,
    super.bookType,
    super.coverURI,
    super.fileSize,
    super.lastTimeOpened,
    super.path,
    super.totalPages,
    required super.source,
    required super.createdAt,
  });
}
