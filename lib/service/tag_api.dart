import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:goodo_flutter/models/tag.dart';

@immutable
class TagApi {
  static String get baseUrl {
    const bool isProduction = bool.fromEnvironment('dart.vm.product');
    return isProduction
        ? 'https://goodoo-backend-production.up.railway.app/api'
        : 'http://localhost:3000/api';
  }

  static final dio = Dio();

  static Future<List<Tag>> getTagList() async {
    final url = _constructTagListUrl();
    final response = await dio.get(url);
    final tagsData =
        (response.data as List<dynamic>)
            .map((tag) => Tag.fromJson(tag as Map<String, dynamic>))
            .toList();
    return tagsData;
  }

  static Future<Tag> getTagById(String id) async {
    final url = _constructTagByIdUrl(id);
    final response = await dio.get(url);
    return Tag.fromJson(response.data);
  }

  static Future<void> deleteTagById(String id) async {
    final url = _constructTagByIdUrl(id);
    await dio.delete(url);
    return;
  }

  static Future<Tag> createNewTag(Tag tag) async {
    final url = _constructTagListUrl();
    final response = await dio.post(url, data: tag.toJson());
    return Tag.fromJson(response.data);
  }

  static Future<Tag> updateTagById(Tag tag) async {
    final url = _constructTagByIdUrl(tag.id);
    final response = await dio.patch(url, data: tag.toJson());
    return Tag.fromJson(response.data);
  }

  static String _constructTagListUrl() => '$baseUrl/tag';
  static String _constructTagByIdUrl(String id) => '$baseUrl/tag/$id';
}
