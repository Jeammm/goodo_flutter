import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodo_flutter/models/tag.dart';
import 'package:goodo_flutter/service/tag_api.dart';

// final tagListProvider = FutureProvider.autoDispose((ref) {
//   return ApiHelper.getTagList();
// });

class TagsNotifier extends StateNotifier<List<Tag>> {
  TagsNotifier() : super(const []);

  Future<void> loadTags() async {
    final tagList = await TagApi.getTagList();
    state = tagList;
  }

  Future<void> deleteTag(Tag tag) async {
    final deleteIndex = state.indexOf(tag);
    state = state.where((t) => t.id != tag.id).toList();
    try {
      await TagApi.deleteTagById(tag.id);
    } catch (e) {
      final restoredList = List<Tag>.from(state);
      restoredList.insert(deleteIndex, tag);
      state = restoredList;
    }
  }

  Future<void> addTag(Tag tag) async {
    state = [tag, ...state];
    try {
      final newTag = await TagApi.createNewTag(tag);
      state = [newTag, ...state.sublist(1)];
    } catch (e) {
      state = state.sublist(1);
    }
  }

  Future<void> updateTag(Tag tag) async {
    final updateIndex = state.indexWhere((t) => t.id == tag.id);
    final preUpdate = state[updateIndex];
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == updateIndex) tag else state[i],
    ];
    try {
      await TagApi.updateTagById(tag);
    } catch (e) {
      // Revert the update if an error occurs
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == updateIndex) preUpdate else state[i],
      ];
    }
  }
}

final tagsProvider = StateNotifierProvider((ref) => TagsNotifier());
