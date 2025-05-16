import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodo_flutter/provider/query_provider.dart';

class QueryHeader extends ConsumerStatefulWidget {
  const QueryHeader({super.key});

  @override
  ConsumerState<QueryHeader> createState() => _QueryHeaderState();
}

class _QueryHeaderState extends ConsumerState<QueryHeader> {
  String get headerText {
    final query = ref.watch(queryProvider).query;

    if (query.mode == QueryMode.tag) {
      final name = query.value.toString().split('-')[1];
      return 'Category $name';
    }
    return query.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      width: double.infinity,
      child: Text(
        headerText,
        style: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
