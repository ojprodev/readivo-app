import 'package:isar/isar.dart';
import 'package:readivo_app/src/features/library/domain/entities/note.dart';

part 'reading_session.g.dart';

@collection
@Name('reading_sessions')
class ReadingSession {
  Id id = Isar.autoIncrement;
  late int? startPage;
  late int? endPage;
  late DateTime? startTime;
  late DateTime? endTime;
  late double? percentage;
  late DateTime? updatedAt;
  late DateTime createdAt;

  // links
  final notes = IsarLinks<Note>();

  ReadingSession({
    this.startPage,
    this.endPage,
    this.startTime,
    this.endTime,
    this.percentage,
    this.updatedAt,
    required this.createdAt,
  });
}
