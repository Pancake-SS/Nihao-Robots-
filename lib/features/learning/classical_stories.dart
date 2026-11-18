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
    this.englishParagraphs = const [],
    this.englishCredit = '',
    this.englishSourceUrl = '',
    this.englishLicense = '',
  });

  final String id, title, sourceUrl;
  final int revision;
  final List<String> paragraphs;
  final List<String> englishParagraphs;
  final String englishCredit, englishSourceUrl, englishLicense;

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

List<ClassicCollection> parseClassics(String source, {String? englishSource}) {
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
  if (englishSource == null) return collections;
  final translated = jsonDecode(englishSource) as Map<String, dynamic>;
  if (translated['schemaVersion'] != 1 || translated['translations'] is! List) {
    throw const FormatException('Unsupported English story pack.');
  }
  final byId = <String, Map<String, dynamic>>{};
  for (final raw in translated['translations'] as List) {
    final item = raw as Map<String, dynamic>;
    final id = item['id'] as String;
    final paragraphs = item['paragraphs'];
    if (!ids.contains(id) ||
        byId.containsKey(id) ||
        paragraphs is! List ||
        paragraphs.isEmpty ||
        paragraphs.any((value) => value is! String || value.trim().isEmpty) ||
        (item['credit'] as String?)?.isEmpty != false ||
        Uri.tryParse(item['sourceUrl'] as String? ?? '')?.hasScheme != true ||
        (item['license'] as String?)?.isEmpty != false) {
      throw const FormatException('Incomplete English story translation.');
    }
    byId[id] = item;
  }
  if (byId.length != ids.length) {
    throw const FormatException('Not every story has an English translation.');
  }
  return [
    for (final collection in collections)
      ClassicCollection(
        id: collection.id,
        title: collection.title,
        description: collection.description,
        credit: collection.credit,
        sourceUrl: collection.sourceUrl,
        chapters: [
          for (final chapter in collection.chapters)
            ClassicChapter(
              id: chapter.id,
              title: chapter.title,
              sourceUrl: chapter.sourceUrl,
              revision: chapter.revision,
              paragraphs: chapter.paragraphs,
              englishParagraphs: (byId[chapter.id]!['paragraphs'] as List)
                  .cast<String>(),
              englishCredit: byId[chapter.id]!['credit'] as String,
              englishSourceUrl: byId[chapter.id]!['sourceUrl'] as String,
              englishLicense: byId[chapter.id]!['license'] as String,
            ),
        ],
      ),
  ];
}

final classicalStoriesProvider = FutureProvider<List<ClassicCollection>>((
  ref,
) async {
  final source = await rootBundle.loadString('assets/content/classics_v1.json');
  final english = await rootBundle.loadString('assets/content/classics_english_v1.json');
  return parseClassics(source, englishSource: english);
});
