import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodo_flutter/provider/query_provider.dart';
import 'package:goodo_flutter/widgets/category_section.dart';
import 'package:goodo_flutter/widgets/drawer_tile_item.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final queryData = ref.watch(queryProvider);

    void selectQuery(QueryMode mode, Object value) {
      ref.read(queryProvider.notifier).setQuery(mode, value);
      Navigator.of(context).pop();
    }

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Goodo',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            DrawerTileItem(
              title: 'Active list',
              onTileTap: () {
                selectQuery(QueryMode.normal, NormalQueryValue.active);
              },
              selected:
                  queryData.query.mode == QueryMode.normal &&
                  queryData.query.value == NormalQueryValue.active,
              leading: Icon(Icons.list, size: 24),
            ),

            DrawerTileItem(
              title: 'Due soon',
              onTileTap: () {
                selectQuery(QueryMode.normal, NormalQueryValue.soon);
              },
              selected:
                  queryData.query.mode == QueryMode.normal &&
                  queryData.query.value == NormalQueryValue.soon,
              leading: Icon(Icons.hourglass_empty, size: 24),
            ),

            DrawerTileItem(
              title: 'Important',
              onTileTap: () {
                selectQuery(QueryMode.normal, NormalQueryValue.important);
              },
              selected:
                  queryData.query.mode == QueryMode.normal &&
                  queryData.query.value == NormalQueryValue.important,
              leading: Icon(Icons.star_border, size: 24),
            ),

            DrawerTileItem(
              title: 'Completed',
              onTileTap: () {
                selectQuery(QueryMode.normal, NormalQueryValue.completed);
              },
              selected:
                  queryData.query.mode == QueryMode.normal &&
                  queryData.query.value == NormalQueryValue.completed,
              leading: Icon(Icons.check_box_outlined, size: 24),
            ),

            const Divider(),

            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Text("Categories"),
            ),

            CategorySection(),

            const Divider(),

            DrawerTileItem(
              title: 'Settings',
              onTileTap: () {},
              selected: false,
              leading: Icon(Icons.settings_outlined, size: 24),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
