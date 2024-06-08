import 'package:isar/isar.dart';
import 'package:readivo_app/src/features/library/domain/entities/book.dart';
import 'package:readivo_app/src/features/library/domain/entities/note.dart';
import 'package:readivo_app/src/features/library/domain/repositories/note_repository.dart';

class NoteRepositoryImpl extends NoteRepository {
  final Isar isar;

  NoteRepositoryImpl({required this.isar});

  @override
  Future<Note> add(Note note) async {
    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });

    return note;
  }

  @override
  Future<void> assignBook(Note note, {required Book book}) async {
    book.notes.add(note);

    await isar.writeTxn(() async {
      await book.notes.save();
    });
  }
}
