import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodo_flutter/provider/query_provider.dart';
import 'package:goodo_flutter/provider/tag_provider.dart';
import 'package:goodo_flutter/widgets/drawer_tile_item.dart';

class CategorySection extends ConsumerStatefulWidget {
  const CategorySection({super.key});

  @override
  ConsumerState<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends ConsumerState<CategorySection> {
  late Future<void> _tagFuture;

  @override
  void initState() {
    super.initState();
    _tagFuture = ref.read(tagsProvider.notifier).loadTags();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(tagsProvider);
    final queryData = ref.watch(queryProvider);

    void selectQuery(QueryMode mode, Object value) {
      ref.read(queryProvider.notifier).setQuery(mode, value);
      Navigator.of(context).pop();
    }

    return FutureBuilder(
      future: _tagFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            categories.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text("Categoy could not be loaded");
        }

        return Column(
          children:
              categories
                  .map(
                    (cat) => DrawerTileItem(
                      title: cat.title,
                      onTileTap: () {
                        selectQuery(QueryMode.tag, '${cat.id}-${cat.title}');
                      },
                      selected:
                          queryData.query.mode == QueryMode.tag &&
                          queryData.query.value == cat.id,
                      leading: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.circle, size: 18, color: Colors.black),
                          Icon(
                            Icons.circle,
                            size: 13,
                            color: Color(
                              int.parse(cat.color.replaceFirst('#', '0xff')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}
