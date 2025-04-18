import 'package:flutter/material.dart';
import 'package:app_02/noteS_API/model/Notes.dart';
import 'package:app_02/noteS_API/view/NoteEditScreen.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getTextColor(Color? backgroundColor) {
    if (backgroundColor == null) return Colors.black;
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = note.color != null
        ? Color(int.parse(note.color!.replaceFirst('#', '0xff')))
        : null;
    final textColor = _getTextColor(backgroundColor);

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: textColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteEditScreen(note: note),
                ),
              ).then((_) => Navigator.pop(context));
            },
            tooltip: 'Chỉnh sửa',
          ),
        ],
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(note.priority),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      note.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                note.content,
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 16),
              Text(
                'Created: ${note.createdAt.toString().substring(0, 16)}',
                style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.7)),
              ),
              const SizedBox(height: 8),
              Text(
                'Last modified: ${note.modifiedAt.toString().substring(0, 16)}',
                style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.7)),
              ),
              const SizedBox(height: 16),
              if (note.tags != null && note.tags!.isNotEmpty) ...[
                Text(
                  'Tags:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: note.tags!
                      .map((tag) => Chip(
                    label: Text(tag, style: TextStyle(color: textColor)),
                    backgroundColor: textColor.withOpacity(0.1),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
              if (note.color != null) ...[
                Text(
                  'Color:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}