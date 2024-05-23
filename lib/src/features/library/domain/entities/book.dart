import 'package:isar/isar.dart';
import 'package:readivo_app/src/core/enums/enums.dart';

part 'book.g.dart';

@collection
class Book {
  Id id = Isar.autoIncrement;
  late String title;
  late String? author;
  late String? coverURI;
  late String? isbn;
  late String? path;
  late int? fileSize;
  late DateTime? lastTimeOpened;
  @Enumerated(EnumType.name)
  late BookSourceEnums source;
  late int? totalPages;
  late String? description;
  late String? publishDate;
  @Enumerated(EnumType.name)
  late ReadingStatus? readingStatus;
  late double? globalRating;
  late int? ratingCount;
  @Enumerated(EnumType.name)
  late BookType? bookType;
  late DateTime? updatedAt;
  late DateTime createdAt;

  Book({
    required this.title,
    this.author,
    this.coverURI,
    this.isbn,
    this.path,
    this.fileSize,
    this.lastTimeOpened,
    required this.source,
    this.totalPages,
    this.description,
    this.publishDate,
    this.readingStatus,
    this.globalRating,
    this.ratingCount,
    this.bookType,
    this.updatedAt,
    required this.createdAt,
  });
}
