import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/reading_session.dart';
import 'package:readivo_app/src/features/library/domain/repositories/reading_session_repository.dart';

class ReadingSessionUseCase {
  final ReadingSessionRepository readingSessionRepository;

  ReadingSessionUseCase({required this.readingSessionRepository});

  Future<void> linkToBook(
    ReadingSession readingSession, {
    required Book book,
  }) async {
    ReadingSession session = await readingSessionRepository.add(readingSession);

    await readingSessionRepository.assignBook(session, book: book);
  }
}
