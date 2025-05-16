import 'package:flutter/material.dart';

class DrawerTileItem extends StatelessWidget {
  const DrawerTileItem({
    super.key,
    required this.title,
    required this.onTileTap,
    this.selected = false,
    this.leading,
  });

  final String title;
  final bool selected;
  final Widget? leading;
  final void Function() onTileTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedColor: Colors.red,
      selectedTileColor: Theme.of(
        context,
      ).colorScheme.primary.withAlpha((255 * 0.1).toInt()),
      leading: leading,
      title: Text(title),
      onTap: onTileTap,
    );
  }
}
