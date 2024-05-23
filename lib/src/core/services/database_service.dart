import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';

class DatabaseService {
  static Future<Isar> initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [BookSchema],
      directory: dir.path,
    );
  }
}
