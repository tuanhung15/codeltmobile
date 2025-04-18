import 'package:flutter/material.dart';
import 'package:app_02/noteS/model/Notes.dart';
import 'package:app_02/noteS/db/NoteDatabaseHelper.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final NoteDatabaseHelper dbHelper = NoteDatabaseHelper.instance;
  List<Note> notes = [];
  bool isGridView = false;
  int sortOption = 0;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    List<Note> fetchedNotes = await dbHelper.getAllNotes();
    if (sortOption == 0) {
      fetchedNotes.sort((a, b) => b.priority.compareTo(a.priority));
    } else {
      fetchedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    if (searchQuery.isNotEmpty) {
      fetchedNotes = fetchedNotes
          .where((note) =>
      note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    setState(() {
      notes = fetchedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final query = await showSearch<String>(
                context: context,
                delegate: NoteSearchDelegate(notes),
              );
              if (query != null) {
                setState(() {
                  searchQuery = query;
                });
                _loadNotes();
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Refresh':
                  _loadNotes();
                  break;
                case 'Sort by Priority':
                  setState(() {
                    sortOption = 0;
                  });
                  _loadNotes();
                  break;
                case 'Sort by Date':
                  setState(() {
                    sortOption = 1;
                  });
                  _loadNotes();
                  break;
                case 'Filter Low':
                  _filterByPriority(1);
                  break;
                case 'Filter Medium':
                  _filterByPriority(2);
                  break;
                case 'Filter High':
                  _filterByPriority(3);
                  break;
                case 'Toggle View':
                  setState(() {
                    isGridView = !isGridView;
                  });
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Refresh', child: Text('Refresh')),
              const PopupMenuItem(value: 'Sort by Priority', child: Text('Sort by Priority')),
              const PopupMenuItem(value: 'Sort by Date', child: Text('Sort by Date')),
              const PopupMenuItem(value: 'Filter Low', child: Text('Filter Low Priority')),
              const PopupMenuItem(value: 'Filter Medium', child: Text('Filter Medium Priority')),
              const PopupMenuItem(value: 'Filter High', child: Text('Filter High Priority')),
              const PopupMenuItem(value: 'Toggle View', child: Text('Toggle Grid/List')),
            ],
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes available'))
          : isGridView
          ? GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return _buildNoteCard(note);
        },
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return _buildNoteCard(note);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditScreen(note: null), // Thêm mới
            ),
          ).then((_) => _loadNotes());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailScreen(note: note),
          ),
        );
      },
      child: NoteItem(
        note: note,
        onEdit: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditScreen(note: note), // Sửa
            ),
          ).then((_) => _loadNotes());
        },
        onDelete: () {
          _loadNotes();
        },
      ),
    );
  }

  Future<void> _filterByPriority(int priority) async {
    final filteredNotes = await dbHelper.getNotesByPriority(priority);
    setState(() {
      notes = filteredNotes;
    });
  }
}

class NoteItem extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteItem({super.key, required this.note, required this.onEdit, required this.onDelete});

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

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc muốn xóa ghi chú "${note.title}" không?'),
          actions: [
            TextButton(
              child: const Text('Hủy'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                final dbHelper = NoteDatabaseHelper.instance;
                await dbHelper.deleteNote(note.id!);
                Navigator.of(context).pop();
                onDelete();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: note.color != null ? Color(int.parse(note.color!.replaceFirst('#', '0xff'))) : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _getPriorityColor(note.priority),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              'Last modified: ${note.modifiedAt.toString().substring(0, 16)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            if (note.tags != null && note.tags!.isNotEmpty)
              Wrap(
                spacing: 4,
                children: note.tags!
                    .map((tag) => Chip(
                  label: Text(tag, style: const TextStyle(fontSize: 10)),
                  padding: EdgeInsets.zero,
                ))
                    .toList(),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: onEdit,
                  tooltip: 'Sửa',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(context),
                  tooltip: 'Xóa',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NoteSearchDelegate extends SearchDelegate<String> {
  final List<Note> notes;

  NoteSearchDelegate(this.notes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = notes
        .where((note) =>
    note.title.toLowerCase().contains(query.toLowerCase()) ||
        note.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final note = results[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.content, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () => close(context, query),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
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
      body: Padding(
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
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(note.content, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Text(
                'Created: ${note.createdAt.toString().substring(0, 16)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Last modified: ${note.modifiedAt.toString().substring(0, 16)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              if (note.tags != null && note.tags!.isNotEmpty) ...[
                const Text('Tags:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: note.tags!
                      .map((tag) => Chip(label: Text(tag), backgroundColor: Colors.grey[200]))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
              if (note.color != null) ...[
                const Text('Color:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(int.parse(note.color!.replaceFirst('#', '0xff'))),
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
  int _priority = 1; // Mặc định là thấp
  Color _color = Colors.white; // Mặc định là trắng
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
      final dbHelper = NoteDatabaseHelper.instance;
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

      if (widget.note == null) {
        await dbHelper.insertNote(newNote);
      } else {
        await dbHelper.updateNote(newNote);
      }
      Navigator.pop(context);
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
              // Tiêu đề
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: (value) =>
                value!.isEmpty ? 'Title cannot be empty' : null,
              ),
              const SizedBox(height: 16),

              // Nội dung
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
                maxLines: 5,
                validator: (value) =>
                value!.isEmpty ? 'Content cannot be empty' : null,
              ),
              const SizedBox(height: 16),

              // Mức độ ưu tiên
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

              // Chọn màu
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

              // Nhãn (Tags)
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

              // Nút lưu
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