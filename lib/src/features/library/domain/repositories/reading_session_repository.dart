import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/reading_session.dart';

abstract class ReadingSessionRepository {
  Future<ReadingSession> add(ReadingSession readingSession);
  Future<void> assignBook(ReadingSession readingSession, {required Book book});
}
