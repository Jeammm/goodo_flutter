import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:goodo_flutter/models/todo.dart';
import 'package:goodo_flutter/provider/todo_provider.dart';

@immutable
class TodoApi {
  static String get baseUrl {
    const bool isProduction = bool.fromEnvironment('dart.vm.product');
    return isProduction
        ? 'https://goodoo-backend-production.up.railway.app/api'
        : 'http://localhost:3000/api';
  }

  static final dio = Dio();

  static Future<List<Todo>> getTodoList({Query? query}) async {
    final url = _constructTodoListUrl();
    final response = await dio.get(url, queryParameters: query?.toJson());
    final todosData =
        (response.data as List<dynamic>)
            .map((todo) => Todo.fromJson(todo as Map<String, dynamic>))
            .toList();
    return todosData;
  }

  static Future<Todo> getTodoById(String id) async {
    final url = _constructTodoByIdUrl(id);
    final response = await dio.get(url);
    return Todo.fromJson(response.data);
  }

  static Future<void> deleteTodoById(String id) async {
    final url = _constructTodoByIdUrl(id);
    await dio.delete(url);
    return;
  }

  static Future<Todo> createNewTodo(Todo todo) async {
    final url = _constructTodoListUrl();
    final response = await dio.post(url, data: todo.toJson());
    return Todo.fromJson(response.data);
  }

  static Future<Todo> updateTodoById(Todo todo) async {
    final url = _constructTodoByIdUrl(todo.id);
    final response = await dio.patch(url, data: todo.toJson());
    return Todo.fromJson(response.data);
  }

  static String _constructTodoListUrl() => '$baseUrl/todo';
  static String _constructTodoByIdUrl(String id) => '$baseUrl/todo/$id';
}
