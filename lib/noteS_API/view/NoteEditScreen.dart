import 'package:flutter/material.dart';
import 'package:app_02/noteS_API/model/Notes.dart';
import 'package:app_02/noteS_API/api/NoteAPIService.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NoteEditScreen extends StatelessWidget {
  final Note? note;

  const NoteEditScreen({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: NoteForm(note: note),
    );
  }
}

class NoteForm extends StatefulWidget {
  final Note? note;

  const NoteForm({super.key, this.note});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagController;
  int _priority = 1;
  Color _color = Colors.white;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _tagController = TextEditingController();
    _priority = widget.note?.priority ?? 1;
    _color = widget.note?.color != null
        ? Color(int.parse(widget.note!.color!.replaceFirst('#', '0xff')))
        : Colors.white;
    _tags = widget.note?.tags != null ? List.from(widget.note!.tags!) : [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final apiService = NoteApiService(); // Đã thay thế NoteDatabaseHelper
      final now = DateTime.now();
      final newNote = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        priority: _priority,
        createdAt: widget.note?.createdAt ?? now,
        modifiedAt: now,
        tags: _tags.isNotEmpty ? _tags : null,
        color: '#${_color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
      );

      try {
        if (widget.note == null) {
          await apiService.insertNote(newNote);
        } else {
          await apiService.updateNote(newNote);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _color,
            onColorChanged: (color) {
              setState(() => _color = color);
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Title cannot be empty' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? 'Content cannot be empty' : null,
              ),
              const SizedBox(height: 16),
              const Text('Priority:', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<int>(
                value: _priority,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Low')),
                  DropdownMenuItem(value: 2, child: Text('Medium')),
                  DropdownMenuItem(value: 3, child: Text('High')),
                ],
                onChanged: (value) => setState(() => _priority = value!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Color:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showColorPicker(context),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: _color,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Tags:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: _tags
                    .map((tag) => Chip(
                  label: Text(tag),
                  onDeleted: () => setState(() => _tags.remove(tag)),
                ))
                    .toList(),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a tag',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _tags.add(value);
                            _tagController.clear();
                          });
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_tagController.text.isNotEmpty) {
                        setState(() {
                          _tags.add(_tagController.text);
                          _tagController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveNote,
                child: Text(widget.note == null ? 'Save' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}