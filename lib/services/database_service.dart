import 'dart:io';

import 'package:notes_app/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  DBService._();
  static final DBService db = DBService._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    return await openDatabase(
      join(dir.path, "notes.db"),
      onCreate: (Database database, int version) async {
        await database.execute('''
        CREATE TABLE notes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          noteTitle TEXT,
          note TEXT,
          dateTime TEXT
        )
        ''');
      },
      version: 1,
    );
  }

  Future<Note> newNote(String noteTitle, String note) async {
    final Database? db = await database;
    int id = await db!.rawInsert('''
      INSERT into notes (
        noteTitle, note, dateTime
      ) VALUES (?,?,?)
    ''', [noteTitle, note, DateTime.now().toIso8601String()]);
    return await getNote(id);
  }

  Future<List<Note>> getNotes() async {
    final Database? db = await database;
    List<Map<String, Object?>>? data = await db!.rawQuery('''
      SELECT * FROM notes 
    ''');
    return data.map((e) => Note.fromJSON(e)).toList();
  }

  Future<Note> getNote(int id) async {
    final Database? db = await database;
    List<Map<String, Object?>> data = await db!.rawQuery('''
      SELECT * from notes
      WHERE id = ?
    ''', [id]);
    return data.map((e) => Note.fromJSON(e)).first;
  }

  Future<void> deleteNote(int id) async {
    final Database? db = await database;
    await db?.rawDelete('''
      DELETE FROM notes
      WHERE id = ?
    ''', [id]);
  }

  Future<void> editNote(Note note) async {
    final Database? db = await database;
    await db!.rawUpdate('''
      UPDATE notes
      SET noteTitle = ?, note = ?, dateTime = ?
      WHERE id = ?
    ''',
        [note.noteTitle, note.note, DateTime.now().toIso8601String(), note.id]);
  }
}
