// note.dart
class Note {
  final int? id;
  final String title;
  final String content;
  final int priority;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final List<String>? tags;
  final String? color;

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
    assert(priority >= 1 && priority <= 3, 'Priority must be between 1 and 3');
  }

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

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, '
        'priority: $priority, createdAt: $createdAt, '
        'modifiedAt: $modifiedAt, tags: $tags, color: $color)';
  }
}