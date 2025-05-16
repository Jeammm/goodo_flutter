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
  bool _useDueDate = false;
  bool _isRepeating = false;
  int _priority = 3;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todo?.title ?? "";
    _descriptionController.text = widget.todo?.description ?? "";
    _isFavorite = widget.todo?.isFavorite ?? false;

    _useDueDate = widget.todo?.useDueDate ?? false;
    _isRepeating = widget.todo?.isRepeating ?? false;
    _priority = widget.todo?.priority ?? 3;
  }

  void _onPressSave() {
    // Save logic here
    final updatedTodo = Todo(
      id: widget.todo?.id ?? "",
      title: _titleController.text,
      description: _descriptionController.text,
      isDone: widget.todo?.isDone ?? false,
      isFavorite: _isFavorite,
      useDueDate: _useDueDate,
      isRepeating: _isRepeating,
      tag: [],
      priority: _priority,
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
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            SizedBox(height: 16),

            Row(
              children: [
                const Text('Priority:'),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _priority,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        style: Theme.of(context).textTheme.bodyLarge,
                        onChanged: (value) {
                          setState(() {
                            _priority = value!;
                          });
                        },
                        items: [
                          DropdownMenuItem<int>(value: 0, child: Text("High")),
                          DropdownMenuItem<int>(
                            value: 1,
                            child: Text("High to Medium"),
                          ),
                          DropdownMenuItem<int>(
                            value: 2,
                            child: Text("Medium"),
                          ),
                          DropdownMenuItem<int>(
                            value: 3,
                            child: Text("Medium to Low"),
                          ),
                          DropdownMenuItem<int>(value: 4, child: Text("Low")),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            SwitchListTile(
              secondary: const Icon(Icons.notifications),
              title: const Text('Use Due Date'),
              value: _useDueDate,
              onChanged: (val) {
                setState(() {
                  _useDueDate = val;
                });
              },
            ),

            if (_useDueDate)
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Due Date Picker
                    Row(
                      children: [
                        const Text('Due Date:'),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  widget.todo?.dueDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                // You may want to store dueDate in a variable
                                // For now, just update widget.todo?.dueDate if needed
                              });
                            }
                          },
                          child: Text(
                            widget.todo?.dueDate != null
                                ? "${widget.todo!.dueDate!.toLocal()}".split(
                                  ' ',
                                )[0]
                                : "Select Date",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Button group for ALL_DAY / TIME
                    Row(
                      children: [
                        const Text('Time Mode:'),
                        const SizedBox(width: 16),
                        ToggleButtons(
                          isSelected: [
                            (widget.todo?.timeMode ?? 'ALL_DAY') == 'ALL_DAY',
                            (widget.todo?.timeMode ?? 'ALL_DAY') == 'TIME',
                          ],
                          onPressed: (index) {
                            setState(() {
                              // You may want to store timeMode in a variable
                              // For now, just update widget.todo?.timeMode if needed
                            });
                          },
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('ALL_DAY'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('TIME'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Repeat Dropdown
                    Row(
                      children: [
                        const Text('Repeat:'),
                        const SizedBox(width: 16),
                        DropdownButton<bool>(
                          value: _isRepeating,
                          onChanged: (val) {
                            setState(() {
                              _isRepeating = val ?? false;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: false,
                              child: Text('Don\'t repeat'),
                            ),
                            DropdownMenuItem(
                              value: true,
                              child: Text('Repeat'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
