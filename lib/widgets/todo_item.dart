import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodo_flutter/models/todo.dart';
import 'package:goodo_flutter/provider/todo_provider.dart';
import 'package:goodo_flutter/screens/todo_detail.dart';

class TodoItem extends ConsumerWidget {
  const TodoItem({super.key, required this.todo});

  final Todo todo;

  String get serializedDescription {
    return RegExp(r'<[^>]*>').hasMatch(todo.description)
        ? todo.description.replaceAll(RegExp(r'<[^>]*>'), '')
        : todo.description;
  }

  void _onTapTodo(context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => TodoDetailScreen(todo: todo)));
  }

  @override
  Widget build(BuildContext context, ref) {
    void onToggleDone() async {
      await Future.delayed(Duration(milliseconds: 200));
      ref
          .read(todosProvider.notifier)
          .updateTodo(todo.copyWith(isDone: !todo.isDone));

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(!todo.isDone ? 'Marked as done' : 'Marked as not done'),
        ),
      );
    }

    return Dismissible(
      key: ValueKey(todo.id),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: Text('Confirm'),
                  content: Text('Are you sure you want to delete this item?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text('Delete'),
                    ),
                  ],
                ),
          );
        } else {
          onToggleDone();
          return false;
        }
      },
      background: Container(
        color: todo.isDone ? Colors.orange : Colors.green,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          todo.isDone ? Icons.undo : Icons.check,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ListTile(
          onTap: () {
            _onTapTodo(context);
          },
          key: ValueKey(todo.id),
          leading: SizedBox(
            width: 60,
            child: Row(
              spacing: 10,
              children: [
                todo.isDone
                    ? Icon(Icons.check_box_outlined)
                    : Icon(Icons.crop_square_outlined),
                todo.isFavorite
                    ? Icon(Icons.star, color: Colors.amber[500])
                    : Icon(Icons.star_border),
              ],
            ),
          ),
          title: Text(todo.title),
          subtitle: Text(
            serializedDescription,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
