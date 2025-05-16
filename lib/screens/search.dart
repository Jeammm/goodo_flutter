import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodo_flutter/provider/todo_provider.dart';
import 'package:goodo_flutter/widgets/todo_item.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      _search();
    });
  }

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
    });

    ref.read(todosProvider.notifier).clearTodos();
    await ref
        .read(todosProvider.notifier)
        .loadTodos(search: _searchController.text);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todosProvider);

    Widget activeWidget = Center(
      child: Text(
        "Search To do",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
        textAlign: TextAlign.center,
      ),
    );

    if (_isLoading && _searchController.text.isNotEmpty) {
      activeWidget = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Searching...",
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    } else if (_searchController.text.isNotEmpty && todos.isEmpty) {
      activeWidget = Center(
        child: Text(
          "No to do found.",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else if (_searchController.text.isNotEmpty && todos.isNotEmpty) {
      activeWidget = SingleChildScrollView(
        child: ListView.builder(
          itemCount: todos.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return TodoItem(todo: todos[index]);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search todos...",
            border: InputBorder.none,
          ),
        ),
      ),
      body: activeWidget,
    );
  }
}
