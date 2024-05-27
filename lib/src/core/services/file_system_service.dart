import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:readivo_app/src/core/enums/enums.dart';
import 'package:readivo_app/src/core/utils/utils.dart';
import 'package:readivo_app/src/features/library/data/local/models/local_book.dart';

class BookDataType {
  final int pagesCount;
  final ByteData? thumbnail;

  BookDataType({required this.pagesCount, required this.thumbnail});
}

class FileSystemService {
  static const String thumbnailsDirectory = 'thumbnails/';

  // define excluded folders
  static final RegExp excludedPattern = RegExp(
      r'(^/storage/.*/Android(/|$))|(^/storage/.*/.android_secure(/|$))');
  static final List<String> bookExtensions = ['pdf'];

  // Collect book information
  Future<BookDataType?> collectBookData(String path) async {
    try {
      final document = await PdfDocument.openFile(path);
      final pages = document.pages;
      late ByteData? thumbnailByteData;

      final firstPage = pages.first;
      final firstPageImage = await firstPage.render(
        fullHeight: firstPage.height * 0.4,
        fullWidth: firstPage.width * 0.4,
      );
      final Image? thumbnail = await firstPageImage?.createImage();
      thumbnailByteData =
          await thumbnail?.toByteData(format: ImageByteFormat.png);

      return BookDataType(
        pagesCount: pages.length,
        thumbnail: thumbnailByteData,
      );
    } catch (error) {
      //TODO: handle exception properly
      print('collecting books info issue: $error');
    }
    return null;
  }

  /// Save a file locally as ByteData
  static Future<String> saveFileLocallyAsByte({
    required ByteData byteData,
    required String fileName,
  }) async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final appDocumentsPath = appDocumentsDirectory.path;
    final filePath = '$appDocumentsPath/$fileName';

    // Check if the file already exists locally
    if (await File(filePath).exists()) {
      // return path
      return filePath;
    } else {
      // Ensure that the directory containing the file exists
      var directory = Directory(filePath).parent;
      if (!directory.existsSync()) {
        // otherwise create it
        directory.createSync(recursive: true);
      }
      // Get the data buffer
      final buffer = byteData.buffer;
      // write into the provided path
      await File(filePath).writeAsBytes(buffer.asUint8List());
      // return file path
      return filePath;
    }
  }

  static Future<List<FileSystemEntity>> searchDirectory(
      Directory directory) async {
    List<FileSystemEntity> files = [];
    try {
      final List<FileSystemEntity> entities = await directory
          .list()
          // Filter out the excluded directories
          .where((element) => !excludedPattern.hasMatch(element.path))
          .toList();

      for (var entity in entities) {
        if (entity is File) {
          if (bookExtensions.isNotEmpty) {
            if (bookExtensions
                .contains(entity.path.split('.').last.toLowerCase())) {
              files.add(entity);
            }
          } else {
            files.add(entity);
          }
        } else {
          List<FileSystemEntity> subDirFiles =
              await searchDirectory(entity as Directory);
          files.addAll(subDirFiles);
        }
      }
    } catch (error) {
      // TODO: handle exception properly
      print('error searching in directory');
    }
    return files;
  }

  Future<List<FileSystemEntity>> collectFiles() async {
    final List<String> paths =
        await ExternalPath.getExternalStorageDirectories();
    List<FileSystemEntity> files = [];

    // perform any conditions here
    final List<Directory> directories =
        paths.map((path) => Directory(path)).toList();

    // loop trough the directories and collect all files
    for (Directory directory in directories) {
      List<FileSystemEntity> dirFiles =
          await FileSystemService.searchDirectory(directory);
      files.addAll(dirFiles);
    }

    return files;
  }

  Future<LocalBook?> generateBookData(FileSystemEntity file) async {
    final bookData = await collectBookData(file.path);

    if (bookData != null && bookData.thumbnail != null) {
      String predictedName = Utils.fileNamePrediction(
        file.path,
        removeDomains: true,
        removeUnderscores: true,
        removeDashes: true,
      );
      FileStat fileStat = file.statSync();
      String thumbnailName = predictedName.replaceAll(' ', '-');
      String fileName =
          '${FileSystemService.thumbnailsDirectory}$thumbnailName.png';

      // generate a thumbnail and save it locally
      String thumbnailPath = await saveFileLocallyAsByte(
        byteData: bookData.thumbnail!,
        fileName: fileName,
      );

      return LocalBook(
        title: predictedName,
        fileSize: fileStat.size,
        totalPages: bookData.pagesCount,
        coverURI: 'file://$thumbnailPath',
        bookType: BookType.eBook,
        lastTimeOpened: fileStat.accessed,
        path: file.path,
        source: BookSourceEnums.local,
        createdAt: DateTime.now(),
      );
    } else {
      return null;
    }
  }
}
