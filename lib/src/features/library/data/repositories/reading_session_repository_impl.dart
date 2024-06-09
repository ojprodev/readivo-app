import 'package:isar/isar.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/reading_session.dart';
import 'package:readivo_app/src/features/library/domain/repositories/reading_session_repository.dart';

class ReadingSessionRepositoryImpl extends ReadingSessionRepository {
  final Isar isar;

  ReadingSessionRepositoryImpl({required this.isar});

  @override
  Future<void> assignBook(ReadingSession readingSession,
      {required Book book}) async {
    book.readingSessions.add(readingSession);

    await isar.writeTxn(() async {
      await book.readingSessions.save();
      await readingSession.notes.save();
    });
  }

  @override
  Future<ReadingSession> add(ReadingSession readingSession) async {
    await isar.writeTxn(() async {
      await isar.readingSessions.put(readingSession);
    });

    return readingSession;
  }
}
