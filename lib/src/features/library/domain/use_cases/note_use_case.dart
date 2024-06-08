import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/note.dart';
import 'package:readivo_app/src/features/library/domain/repositories/note_repository.dart';

class NoteUseCase {
  final NoteRepository noteRepository;

  NoteUseCase({required this.noteRepository});

  Future<Note> add(Note note, {required Book book}) async {
    // add note
    Note bookNote = await noteRepository.add(note);

    // link it to it's book
    await noteRepository.assignBook(bookNote, book: book);

    return bookNote;
  }
}
