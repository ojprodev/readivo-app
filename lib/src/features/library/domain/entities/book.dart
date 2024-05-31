import 'package:isar/isar.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/features/library/domain/entities/note.dart';
import 'package:readivo_app/src/features/library/domain/entities/reading_session.dart';
import 'package:readivo_app/src/features/library/domain/entities/review.dart';
import 'package:readivo_app/src/features/library/domain/entities/shelf.dart';
import 'package:readivo_app/src/features/library/domain/entities/tag.dart';

part 'book.g.dart';

@collection
@Name('books')
class Book {
  Id id = Isar.autoIncrement;
  late String? uid;
  late String title;
  late String? author;
  late String? coverURI;
  late String? isbn;
  late String? path;
  late int? fileSize;
  late String? language;
  late DateTime? lastTimeOpened;
  @Enumerated(EnumType.name)
  late BookSourceEnums source;
  late int? totalPages;
  late String? description;
  late DateTime? publishDate;
  late int? readCount;
  @Enumerated(EnumType.name)
  late ReadingStatus? readingStatus;
  late double? globalRating;
  late int? ratingCount;
  @Enumerated(EnumType.name)
  late BookType? bookType;
  late String? publishYear;
  late DateTime? updatedAt;
  late DateTime createdAt;

  // links
  final shelves = IsarLinks<Shelf>();
  final tags = IsarLinks<Tag>();
  final review = IsarLink<Review>();
  final readingSessions = IsarLinks<ReadingSession>();
  final notes = IsarLinks<Note>();

  Book({
    required this.title,
    this.uid,
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
    this.publishYear,
    this.language,
    this.globalRating,
    this.ratingCount,
    this.bookType,
    this.readCount,
    this.updatedAt,
    required this.createdAt,
  });
}
