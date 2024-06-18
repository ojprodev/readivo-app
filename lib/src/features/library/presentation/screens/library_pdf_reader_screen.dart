import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:readivo_app/src/core/services/file_system_service.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';

class LibraryPdfReaderScreen extends StatelessWidget {
  final Book book;
  var isDarkMode = false;
  var isSepiaMode = true;
  LibraryPdfReaderScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    bool validPdf = _checkTheBook(book.path);
    return ConditionalBuilder(
      condition: validPdf,
      builder: (context) => ColorFiltered(
       colorFilter: _getColorFilter(),
        child: PdfViewer.file(
          '${book.path}',
          params: const PdfViewerParams(
            enableTextSelection: true,
            margin: 8,
          ),
        ),
      ),
      fallback: (context) => const Text('Invalid'),
    );
  }

  bool _checkTheBook(String? path) {
    if (path != null && path.isNotEmpty) {
      return FileSystemService.fileExist(path);
    }
    return false;
  }

 ColorFilter _getColorFilter() {
    if (isDarkMode) {
      return ColorFilter.mode(
        Colors.black.withOpacity(0.7),
        BlendMode.darken,
      );
    } else if (isSepiaMode) {
      return ColorFilter.matrix(<double>[
        0.94, 0.78, 0.26, 0, 0,
        0.36, 0.71, 0.20, 0, 0,
        0.27, 0.53, 0.13, 0, 0,
        0, 0, 0, 1, 0,
      ]);
    } else {
      return ColorFilter.mode(Colors.transparent, BlendMode.multiply);
    }
  }
}
