import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/note.dart';

abstract class NoteRepository {
  Future<Note> add(Note note);

  Future<void> assignBook(Note note, {required Book book});
}
