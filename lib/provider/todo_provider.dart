import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodo_flutter/models/todo.dart';
import 'package:goodo_flutter/service/todo_api.dart';

// final todoListProvider = FutureProvider.autoDispose((ref) {
//   return ApiHelper.getTodoList();
// });

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super(const []);

  Future<void> loadTodos() async {
    final todoList = await TodoApi.getTodoList();
    state = todoList;
  }

  Future<void> deleteTodo(Todo todo) async {
    final deleteIndex = state.indexOf(todo);
    state = state.where((t) => t.id != todo.id).toList();
    try {
      await TodoApi.deleteTodoById(todo.id);
    } catch (e) {
      final restoredList = List<Todo>.from(state);
      restoredList.insert(deleteIndex, todo);
      state = restoredList;
    }
  }

  Future<void> addTodo(Todo todo) async {
    state = [todo, ...state];
    try {
      final newTodo = await TodoApi.createNewTodo(todo);
      state = [newTodo, ...state.sublist(1)];
    } catch (e) {
      state = state.sublist(1);
    }
  }

  Future<void> updateTodo(Todo todo) async {
    final updateIndex = state.indexWhere((t) => t.id == todo.id);
    final preUpdate = state[updateIndex];
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == updateIndex) todo else state[i],
    ];
    try {
      await TodoApi.updateTodoById(todo);
    } catch (e) {
      print(e);
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == updateIndex) preUpdate else state[i],
      ];
    }
  }
}

final todosProvider = StateNotifierProvider((ref) => TodosNotifier());
