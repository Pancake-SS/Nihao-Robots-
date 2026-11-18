import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassicChapter {
  const ClassicChapter({
    required this.id,
    required this.title,
    required this.sourceUrl,
    required this.revision,
    required this.paragraphs,
  });

  final String id, title, sourceUrl;
  final int revision;
  final List<String> paragraphs;

  factory ClassicChapter.fromJson(Map<String, dynamic> json) {
    final paragraphs = (json['paragraphs'] as List).cast<String>();
    if (paragraphs.isEmpty || paragraphs.any((text) => text.trim().isEmpty)) {
      throw const FormatException('A classical chapter has no readable text.');
    }
    return ClassicChapter(
      id: json['id'] as String,
      title: json['title'] as String,
      sourceUrl: json['sourceUrl'] as String,
      revision: json['revision'] as int,
      paragraphs: paragraphs,
    );
  }
}

class ClassicCollection {
  const ClassicCollection({
    required this.id,
    required this.title,
    required this.description,
    required this.credit,
    required this.sourceUrl,
    required this.chapters,
  });

  final String id, title, description, credit, sourceUrl;
  final List<ClassicChapter> chapters;

  factory ClassicCollection.fromJson(Map<String, dynamic> json) {
    final chapters = (json['chapters'] as List)
        .map((value) => ClassicChapter.fromJson(value as Map<String, dynamic>))
        .toList(growable: false);
    if (chapters.isEmpty) {
      throw const FormatException('A classical collection has no chapters.');
    }
    return ClassicCollection(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      credit: json['credit'] as String,
      sourceUrl: json['sourceUrl'] as String,
      chapters: chapters,
    );
  }
}

List<ClassicCollection> parseClassics(String source) {
  final json = jsonDecode(source) as Map<String, dynamic>;
  if (json['schemaVersion'] != 1) {
    throw const FormatException('Unsupported classical story pack.');
  }
  final collections = (json['collections'] as List)
      .map((value) => ClassicCollection.fromJson(value as Map<String, dynamic>))
      .toList(growable: false);
  if (collections.isEmpty) {
    throw const FormatException('The classical story pack is empty.');
  }
  final ids = <String>{};
  final collectionIds = <String>{};
  for (final collection in collections) {
    if (!collectionIds.add(collection.id) ||
        collection.credit.trim().isEmpty ||
        Uri.tryParse(collection.sourceUrl)?.scheme != 'https') {
      throw const FormatException(
        'Invalid classical collection credit or source.',
      );
    }
    for (final chapter in collection.chapters) {
      if (!ids.add(chapter.id) ||
          Uri.tryParse(chapter.sourceUrl)?.scheme != 'https') {
        throw const FormatException(
          'Invalid classical chapter identity or source.',
        );
      }
    }
  }
  return collections;
}

final classicalStoriesProvider = FutureProvider<List<ClassicCollection>>((
  ref,
) async {
  final source = await rootBundle.loadString('assets/content/classics_v1.json');
  return parseClassics(source);
});
