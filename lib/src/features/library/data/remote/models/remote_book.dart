import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/core/utils/utils.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';

class RemoteBook extends Book {
  RemoteBook({
    super.uid,
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
    super.publishYear,
    super.language,
    super.bookType,
    required super.source,
  });

  factory RemoteBook.fromOpenLibraryJson(Map<String, dynamic> json) {
    DateTime? publishDate = Utils.parseToDate(json['first_publish_year']);
    return RemoteBook(
      title: json['title'],
      author: json['author_name'] != null ? json['author_name'].join(', ') : '',
      source: BookSourceEnums.online,
      globalRating:
          Utils.parseRatingsAverage(json['ratings_average'].toString()),
      publishDate: publishDate,
      publishYear: publishDate?.year.toString(),
      coverURI: "https://covers.openlibrary.org/b/id/${json['cover_i']}-M.jpg",
      totalPages: Utils.parseTotalPages(json['number_of_pages_median']),
      createdAt: DateTime.now(),
    );
  }

  factory RemoteBook.fromGoogleBooksJson(Map<String, dynamic> json) {
    var book = json['volumeInfo'];
    DateTime? publishDate = Utils.parseToDate(book['publishedDate']);
    return RemoteBook(
      uid: json['id'],
      title: book['title'],
      author: book['authors'] != null ? book['authors'].join(', ') : '',
      source: BookSourceEnums.online,
      bookType: BookType.paperBook,
      globalRating: Utils.safeConvertToDouble(book['averageRating']),
      description: book['description'],
      publishDate: publishDate,
      publishYear: publishDate?.year.toString(),
      language: book['language'].toString().toUpperCase(),
      coverURI:
          book['imageLinks'] != null ? book['imageLinks']['thumbnail'] : null,
      totalPages: book['pageCount'] ?? 0,
      createdAt: DateTime.now(),
    );
  }
}
