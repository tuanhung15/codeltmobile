import 'package:flutter/material.dart';
import 'package:app_02/noteS_API/model/Notes.dart';
import 'package:app_02/noteS_API/api/NoteAPIService.dart';
import 'package:app_02/noteS_API/view/NoteEditScreen.dart'; // Import mới
import 'package:app_02/noteS_API/view/NoteDetailScreen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final NoteApiService apiService = NoteApiService(); // Đã thay thế NoteDatabaseHelper
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
    try {
      List<Note> fetchedNotes = await apiService.getAllNotes();
      if (sortOption == 0) {
        fetchedNotes.sort((a, b) => b.priority.compareTo(a.priority));
      } else {
        fetchedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }

      if (searchQuery.isNotEmpty) {
        fetchedNotes = await apiService.searchNotes(searchQuery);
      }

      setState(() {
        notes = fetchedNotes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
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
              builder: (context) => NoteEditScreen(note: null),
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
              builder: (context) => NoteEditScreen(note: note),
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
    try {
      final filteredNotes = await apiService.getNotesByPriority(priority);
      setState(() {
        notes = filteredNotes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
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

  Color _getTextColor(Color? backgroundColor) {
    if (backgroundColor == null) return Colors.black;
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
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
                final apiService = NoteApiService(); // Đã thay thế NoteDatabaseHelper
                try {
                  await apiService.deleteNote(note.id!);
                  Navigator.of(context).pop();
                  onDelete();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = note.color != null
        ? Color(int.parse(note.color!.replaceFirst('#', '0xff')))
        : null;
    final textColor = _getTextColor(backgroundColor);

    return Card(
      elevation: 2,
      color: backgroundColor,
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
                    style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Last modified: ${note.modifiedAt.toString().substring(0, 16)}',
              style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.7)),
            ),
            const SizedBox(height: 4),
            if (note.tags != null && note.tags!.isNotEmpty)
              Wrap(
                spacing: 4,
                children: note.tags!
                    .map((tag) => Chip(
                  label: Text(tag, style: TextStyle(fontSize: 10, color: textColor)),
                  padding: EdgeInsets.zero,
                  backgroundColor: textColor.withOpacity(0.1),
                ))
                    .toList(),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, size: 20, color: textColor),
                  onPressed: onEdit,
                  tooltip: 'Sửa',
                ),
                IconButton(
                  icon: Icon(Icons.delete, size: 20, color: textColor),
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