import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodo_flutter/provider/todo_provider.dart';

enum QueryMode { normal, tag }

enum NormalQueryValue {
  active('Active List'),
  soon('Due soon'),
  important('Important'),
  completed('Completed');

  final String value;
  const NormalQueryValue(this.value);

  @override
  String toString() => value;
}

class QueryData {
  final QueryMode mode;
  final Object value;

  QueryData({required this.mode, required this.value});
}

// Define a simple Query state class
class QueryState {
  final QueryData query;

  QueryState({QueryData? query})
    : query =
          query ??
          QueryData(mode: QueryMode.normal, value: NormalQueryValue.active);

  QueryState copyWith({QueryData? query}) {
    return QueryState(query: query ?? this.query);
  }
}

class QueryNotifier extends StateNotifier<QueryState> {
  QueryNotifier() : super(QueryState());

  Query get formattedQuery {
    if (state.query.mode == QueryMode.normal) {
      return Query(mode: state.query.value.toString());
    }

    return Query(category: state.query.value.toString().split('-')[0]);
  }

  void setQuery(WidgetRef ref, QueryMode mode, Object value) {
    state = state.copyWith(query: QueryData(mode: mode, value: value));

    final todosNotifier = ref.read(todosProvider.notifier);
    todosNotifier.loadTodos(
      query: formattedQuery,
    ); // This now updates the UI properly
  }

  void clearQuery() {
    state = state.copyWith(
      query: QueryData(mode: QueryMode.normal, value: NormalQueryValue.active),
    );
  }
}

// Riverpod provider for QueryNotifier
final queryProvider = StateNotifierProvider<QueryNotifier, QueryState>(
  (ref) => QueryNotifier(),
);
