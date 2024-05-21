import 'package:readivo_app/src/core/enums/enums.dart';

class BookEntity {
  final String? id;
  final String title;
  final String? author;
  final String? coverURI;
  final String? isbn;
  final int? totalPages;
  final String? description;
  final String? publishDate;
  final ReadingStatus? readingStatus;
  final double? globalRating;
  final int? ratingCount;
  final BookType? bookType;
  final DateTime? updatedAt;
  final DateTime createdAt;

  BookEntity({
    this.id,
    required this.title,
    this.author,
    this.coverURI,
    this.isbn,
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
