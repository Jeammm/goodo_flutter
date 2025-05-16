import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void setQuery(QueryMode mode, Object value) {
    state = state.copyWith(query: QueryData(mode: mode, value: value));
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
