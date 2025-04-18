// Định nghĩa lớp Note
class Note {
  final int? id;
  final String title;
  final String content;
  final int priority;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final List<String>? tags;
  final String? color;

  // Constructor chính
  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.createdAt,
    required this.modifiedAt,
    this.tags,
    this.color,
  }) {
    // Kiểm tra giá trị hợp lệ cho priority
    assert(priority >= 1 && priority <= 3, 'Priority must be between 1 and 3');
  }

  // Named constructor để tạo từ Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      priority: map['priority'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      modifiedAt: DateTime.parse(map['modifiedAt'] as String),
      tags: map['tags'] != null ? List<String>.from(map['tags']) : null,
      color: map['color'] as String?,
    );
  }

  // Chuyển đổi thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'tags': tags,
      'color': color,
    };
  }

  // Tạo bản sao với các thuộc tính được cập nhật
  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? priority,
    DateTime? createdAt,
    DateTime? modifiedAt,
    List<String>? tags,
    String? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      tags: tags ?? this.tags,
      color: color ?? this.color,
    );
  }

  // Biểu diễn chuỗi của đối tượng
  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, '
        'priority: $priority, createdAt: $createdAt, '
        'modifiedAt: $modifiedAt, tags: $tags, color: $color)';
  }
}

// Ví dụ sử dụng:
void main() {
  // Tạo một ghi chú mới
  final note = Note(
    title: "Họp nhóm",
    content: "Chuẩn bị tài liệu cho cuộc họp",
    priority: 2,
    createdAt: DateTime.now(),
    modifiedAt: DateTime.now(),
    tags: ["công việc", "quan trọng"],
    color: "#FF0000",
  );

  // Chuyển thành Map
  final noteMap = note.toMap();
  print('Map: $noteMap');

  // Tạo từ Map
  final noteFromMap = Note.fromMap(noteMap);
  print('From Map: $noteFromMap');

  // Tạo bản sao với thay đổi
  final updatedNote = note.copyWith(
    content: "Chuẩn bị tài liệu và slide cho cuộc họp",
    modifiedAt: DateTime.now(),
  );
  print('Updated: $updatedNote');
}