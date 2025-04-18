// note_database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:app_02/noteS/model/Notes.dart'; // Import lớp Note từ file khác

class NoteDatabaseHelper {
  static final NoteDatabaseHelper instance = NoteDatabaseHelper._init();
  static Database? _database;

  NoteDatabaseHelper._init();

  // Getter để lấy database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  // Khởi tạo database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Tạo bảng notes
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const textNullable = 'TEXT';

    await db.execute('''
    CREATE TABLE notes (
      id $idType,
      title $textType,
      content $textType,
      priority $intType,
      createdAt $textType,
      modifiedAt $textType,
      tags $textNullable,
      color $textNullable
    )
    ''');
  }

  // Thêm ghi chú mới
  Future<int> insertNote(Note note) async {
    final db = await database;

    final noteMap = note.toMap();
    if (note.tags != null) {
      noteMap['tags'] = note.tags!.join(',');
    }

    return await db.insert('notes', noteMap);
  }

  // Lấy tất cả ghi chú
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final result = await db.query('notes');

    return result.map((map) {
      if (map['tags'] != null) {
        map['tags'] = (map['tags'] as String).split(',');
      }
      return Note.fromMap(map);
    }).toList();
  }

  // Lấy ghi chú theo ID
  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final map = result.first;
      if (map['tags'] != null) {
        map['tags'] = (map['tags'] as String).split(',');
      }
      return Note.fromMap(map);
    }
    return null;
  }

  // Cập nhật ghi chú
  Future<int> updateNote(Note note) async {
    final db = await database;

    final noteMap = note.toMap();
    if (note.tags != null) {
      noteMap['tags'] = note.tags!.join(',');
    }

    return await db.update(
      'notes',
      noteMap,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Xóa ghi chú
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Lấy ghi chú theo mức độ ưu tiên
  Future<List<Note>> getNotesByPriority(int priority) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'priority = ?',
      whereArgs: [priority],
    );

    return result.map((map) {
      if (map['tags'] != null) {
        map['tags'] = (map['tags'] as String).split(',');
      }
      return Note.fromMap(map);
    }).toList();
  }

  // Tìm kiếm ghi chú theo từ khóa
  Future<List<Note>> searchNotes(String query) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return result.map((map) {
      if (map['tags'] != null) {
        map['tags'] = (map['tags'] as String).split(',');
      }
      return Note.fromMap(map);
    }).toList();
  }

  // Đóng database
  Future close() async {
    final db = await database;
    db.close();
  }
}

// Ví dụ sử dụng
void main() async {
  final dbHelper = NoteDatabaseHelper.instance;

  // Tạo ghi chú mới
  final note = Note(
    title: "Test Note",
    content: "This is a test note",
    priority: 2,
    createdAt: DateTime.now(),
    modifiedAt: DateTime.now(),
    tags: ["test", "example"],
    color: "#FF0000",
  );

  // Thêm ghi chú
  final id = await dbHelper.insertNote(note);
  print('Inserted note with id: $id');

  // Lấy tất cả ghi chú
  final allNotes = await dbHelper.getAllNotes();
  print('All notes: $allNotes');

  // Tìm kiếm
  final searchResults = await dbHelper.searchNotes("test");
  print('Search results: $searchResults');

  // Đóng database
  await dbHelper.close();
}