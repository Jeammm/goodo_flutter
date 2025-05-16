import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodo_flutter/provider/todo_provider.dart';
import 'package:goodo_flutter/screens/search.dart';
import 'package:goodo_flutter/screens/todo_detail.dart';
import 'package:goodo_flutter/widgets/drawer.dart';
import 'package:goodo_flutter/widgets/query_header.dart';
import 'package:goodo_flutter/widgets/todo_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> _todoFuture;

  @override
  void initState() {
    super.initState();
    _todoFuture = ref.read(todosProvider.notifier).loadTodos();
  }

  void _onClickSearch(context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => const SearchScreen()));

    ref.read(todosProvider.notifier).loadTodos();
  }

  void _onClickNewTodo(context) async {
    final newTodo = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => const TodoDetailScreen()));

    if (newTodo == null) {
      return;
    }

    ref.read(todosProvider.notifier).addTodo(newTodo);
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Goodo"),
        actions: [
          IconButton(
            onPressed: () {
              _onClickSearch(context);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            QueryHeader(),
            FutureBuilder(
              future: _todoFuture,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (todos.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Text(
                        'No todos yet.\nTap + to add your first one!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: todos.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return TodoItem(todo: todos[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          _onClickNewTodo(context);
        },
        tooltip: 'New',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
