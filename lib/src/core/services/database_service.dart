import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/note.dart';
import 'package:readivo_app/src/features/library/domain/entities/reading_session.dart';
import 'package:readivo_app/src/features/library/domain/entities/review.dart';
import 'package:readivo_app/src/features/library/domain/entities/shelf.dart';
import 'package:readivo_app/src/features/library/domain/entities/tag.dart';

class DatabaseService {
  static Future<Isar> initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [
        BookSchema,
        ShelfSchema,
        TagSchema,
        ReviewSchema,
        ReadingSessionSchema,
        NoteSchema,
      ],
      directory: dir.path,
    );
  }
}
