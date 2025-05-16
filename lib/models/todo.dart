import 'package:goodo_flutter/models/tag.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;
  final bool isDone;
  final List<Tag> tag;
  final int priority;
  final bool useDueDate;
  final DateTime? dueDate;
  final String timeMode;
  final bool isRepeating;

  Todo({
    required this.description,
    required this.isFavorite,
    required this.isDone,
    required this.tag,
    required this.priority,
    required this.useDueDate,
    required this.dueDate,
    required this.timeMode,
    required this.isRepeating,
    required this.id,
    required this.title,
  });

  // Factory method to create a Todo from JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isFavorite: json['isFavorite'],
      isDone: json['isDone'],
      tag: (json['tag'] as List<dynamic>).map((e) => Tag.fromJson(e)).toList(),
      priority: json['priority'],
      useDueDate: json['useDueDate'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      timeMode: json['timeMode'],
      isRepeating: json['isRepeating'],
    );
  }

  // Convert a Todo to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isFavorite': isFavorite,
      'isDone': isDone,
      'tag': tag.map((t) => t.toJson()).toList(),
      'priority': priority,
      'useDueDate': useDueDate,
      'dueDate': dueDate?.toIso8601String(),
      'timeMode': timeMode,
      'isRepeating': isRepeating,
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
    bool? isDone,
    List<Tag>? tag,
    int? priority,
    bool? useDueDate,
    DateTime? dueDate,
    String? timeMode,
    bool? isRepeating,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      isDone: isDone ?? this.isDone,
      tag: tag ?? List<Tag>.from(this.tag),
      priority: priority ?? this.priority,
      useDueDate: useDueDate ?? this.useDueDate,
      dueDate: dueDate ?? this.dueDate,
      timeMode: timeMode ?? this.timeMode,
      isRepeating: isRepeating ?? this.isRepeating,
    );
  }
}
