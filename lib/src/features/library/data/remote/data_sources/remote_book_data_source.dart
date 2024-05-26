import 'package:dio/dio.dart';
import 'package:readivo_app/src/core/enums/book_remote_source.dart';
import 'package:readivo_app/src/features/library/data/remote/models/remote_book.dart';

abstract class RemoteBookDataSource {
  Future<List<RemoteBook>> searchBooks(String query);

  Future<List<RemoteBook>> googleBooks(String query);

  Future<List<RemoteBook>> openLibrary(String query);
}

class RemoteBookDataSourceImpl implements RemoteBookDataSource {
  final Dio dio;

  RemoteBookDataSourceImpl({required this.dio});

  @override
  Future<List<RemoteBook>> searchBooks(String query,
      {BookRemoteSource source = BookRemoteSource.googleBooks}) async {
    if (source == BookRemoteSource.openLibrary) {
      return openLibrary(query);
    } else {
      return googleBooks(query);
    }
  }

  @override
  Future<List<RemoteBook>> googleBooks(String query) async {
    // send request
    final response = await dio.get(
        'https://www.googleapis.com/books/v1/volumes',
        queryParameters: {'q': query, 'printType': 'books'});
    // check response
    if (response.statusCode == 200) {
      // extract targeted data
      final List books = response.data['items'];
      // convert into valid models
      return books.map((book) => RemoteBook.fromGoogleBooksJson(book)).toList();
    } else {
      // throw error in-case of issues
      throw Exception('[DataSource]: Failed to load books');
    }
  }

  @override
  Future<List<RemoteBook>> openLibrary(String query) async {
    // send request
    final response = await dio.get('https://openlibrary.org/search.json',
        queryParameters: {'q': query, 'limit': 30});
    // check response
    if (response.statusCode == 200) {
      // extract targeted data
      final List books = response.data['docs'];
      // convert into valid models
      return books.map((book) => RemoteBook.fromOpenLibraryJson(book)).toList();
    } else {
      // throw error in-case of issues
      throw Exception('[DataSource]: Failed to load books');
    }
  }
}
