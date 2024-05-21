import 'package:dio/dio.dart';
import 'package:readivo_app/src/features/library/data/remote/models/remote_book.dart';

abstract class RemoteBookDataSource {
  Future<List<RemoteBook>> searchBooks(String query);
}

class RemoteBookDataSourceImpl implements RemoteBookDataSource {
  final Dio dio;

  RemoteBookDataSourceImpl({required this.dio});

  @override
  Future<List<RemoteBook>> searchBooks(String query) async {
    // send request
    final response = await dio.get('https://openlibrary.org/search.json', queryParameters: {'q': query, 'limit': 25, 'sort': 'rating'});
    // check response
    if(response.statusCode == 200){
      // extract targeted data
      final List books = response.data['docs'];
      // convert into valid models
      return books.map((book) => RemoteBook.fromJson(book)).toList();
    }else{
      // throw error in-case of issues
      throw Exception('[DataSource]: Failed to load books');
    }
  }
}
