import 'package:readivo_app/src/core/utils/utils.dart';
import 'package:readivo_app/src/features/library/domain/entities/book_entity.dart';

class RemoteBook extends BookEntity {
  RemoteBook({
    required super.title,
    required super.createdAt,
    super.author,
    super.coverURI,
    super.isbn,
    super.totalPages,
    super.description,
    super.publishDate,
    super.globalRating,
    super.ratingCount,
    super.bookType,
  });

  factory RemoteBook.fromJson(Map<String, dynamic> json) {
    return RemoteBook(
      title: json['title'],
      author: json['author_name'].toString(),
      globalRating: parseRatingsAverage(json['ratings_average'].toString()),
      publishDate: json['first_publish_year'].toString(),
      coverURI: "https://covers.openlibrary.org/b/id/${json['cover_i']}-M.jpg",
      totalPages: parseTotalPages(json['number_of_pages_median']),
      createdAt: DateTime.now(),
    );
  }
}
