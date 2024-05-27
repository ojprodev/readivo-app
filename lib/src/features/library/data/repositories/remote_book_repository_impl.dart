import 'dart:typed_data';

import 'package:readivo_app/src/core/services/file_system_service.dart';
import 'package:readivo_app/src/features/library/data/remote/data_sources/remote_book_data_source.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/repositories/remote_book_repository.dart';

class RemoteBookRepositoryImpl implements RemoteBookRepository {
  final RemoteBookDataSource remoteBookDataSource;

  RemoteBookRepositoryImpl({required this.remoteBookDataSource});

  @override
  Future<List<Book>> searchBooks(String query) async {
    return await remoteBookDataSource.searchBooks(query);
  }

  @override
  Future<ByteData> downloadImageAsBytes(String url) async {
    return await remoteBookDataSource.downloadImageAsBytes(url);
  }

  @override
  Future<String?> saveBookThumbnail(Book book) async {
    // define thumbnail file name
    String fileName =
        '${FileSystemService.thumbnailsDirectory}remote/${book.title.replaceAll(' ', '-')}.png';

    // check if there is a thumbnail to download first
    if (book.coverURI != null && book.coverURI!.isNotEmpty) {
      // get thumbnail image as byte data
      ByteData thumbnailByteData =
          await downloadImageAsBytes(book.coverURI ?? '');

      // save the thumbnail locally
      String thumnailPath = await FileSystemService.saveFileLocallyAsByte(
          byteData: thumbnailByteData, fileName: fileName);

      // return the thumbnail path
      return thumnailPath;
    }
    return null;
  }
}
