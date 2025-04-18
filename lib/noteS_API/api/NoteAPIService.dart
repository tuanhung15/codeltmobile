import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_02/noteS_API/model/Notes.dart';

class NoteApiService {
  static const String baseUrl = 'https://my-json-server.typicode.com/tuanhung15/noteS_API'; // URL của JSON Server
  // Lấy tất cả ghi chú
  Future<List<Note>> getAllNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/notes'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Note.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  // Lấy ghi chú theo ID
  Future<Note> getNoteById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/notes/$id'));
    if (response.statusCode == 200) {
      return Note.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load note');
    }
  }

  // Thêm ghi chú mới
  Future<Note> insertNote(Note note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toMap()..remove('id')),
    );
    if (response.statusCode == 201) {
      return Note.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create note');
    }
  }

  // Cập nhật ghi chú
  Future<void> updateNote(Note note) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/${note.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toMap()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update note');
    }
  }

  // Xóa ghi chú
  Future<void> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete note');
    }
  }

  // Lấy ghi chú theo mức độ ưu tiên
  Future<List<Note>> getNotesByPriority(int priority) async {
    final response = await http.get(Uri.parse('$baseUrl/notes?priority=$priority'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Note.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load notes by priority');
    }
  }

  // Tìm kiếm ghi chú
  Future<List<Note>> searchNotes(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/notes?q=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Note.fromMap(json)).toList();
    } else {
      throw Exception('Failed to search notes');
    }
  }
}