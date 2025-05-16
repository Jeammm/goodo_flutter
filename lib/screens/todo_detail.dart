import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodo_flutter/models/todo.dart';
import 'package:goodo_flutter/provider/todo_provider.dart';

class TodoDetailScreen extends ConsumerStatefulWidget {
  const TodoDetailScreen({super.key, this.todo});
  final Todo? todo;

  @override
  ConsumerState<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends ConsumerState<TodoDetailScreen> {
  final TextEditingController _titleController = TextEditingController(
    text: '',
  );
  final TextEditingController _descriptionController = TextEditingController(
    text: '',
  );

  // No, TextEditingController is for text input, not boolean values.
  // For a boolean like isFavorite, use a bool variable instead:
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todo?.title ?? "";
    _descriptionController.text = widget.todo?.description ?? "";
    _isFavorite = widget.todo?.isFavorite ?? false;
  }

  void _onPressSave() {
    // Save logic here
    final updatedTodo = Todo(
      id: widget.todo?.id ?? "",
      title: _titleController.text,
      description: _descriptionController.text,
      isDone: widget.todo?.isDone ?? false,
      isFavorite: _isFavorite,
      isRepeating: false,
      tag: [],
      priority: 3,
      useDueDate: true,
      dueDate: DateTime.now(),
      timeMode: 'ALL_DAY',
    );
    Navigator.of(context).pop(updatedTodo);
  }

  void _onPressFavorite() {
    if (widget.todo != null) {
      ref
          .read(todosProvider.notifier)
          .updateTodo(
            widget.todo!.copyWith(isFavorite: !widget.todo!.isFavorite),
          );

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            !widget.todo!.isFavorite
                ? 'Marked as favorite'
                : 'Unmarked as favorite',
          ),
        ),
      );
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'New Todo' : 'Edit Todo'),
        actions: [
          IconButton(
            onPressed: _onPressFavorite,
            icon:
                _isFavorite
                    ? Icon(Icons.star, color: Colors.amber[500])
                    : Icon(Icons.star_border),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _onPressSave();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 6,
            ),
          ],
        ),
      ),
    );
  }
}
