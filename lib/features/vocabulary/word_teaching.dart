import 'package:flutter/material.dart';

/// Optional dictionary enrichment; independent of immutable quiz snapshots.
class TeachingSense {
  TeachingSense(Map<String, dynamic> data)
    : id = data['id'] as String,
      meaning = data['meaning'] as String,
      partOfSpeech = data['partOfSpeech'] as String,
      labels = List<String>.from(data['labels'] as List),
      notes = List<String>.from(data['notes'] as List),
      related = (data['related'] as List)
          .map((r) => TeachingReference(r as Map<String, dynamic>))
          .toList();
  final String id, meaning, partOfSpeech;
  final List<String> labels, notes;
  final List<TeachingReference> related;
}

class TeachingReference {
  TeachingReference(Map<String, dynamic> data)
    : kind = data['kind'] as String,
      word = data['word'] as String,
      aiAssisted = data['aiAssisted'] as bool;
  final String kind, word;
  final bool aiAssisted;
}

class WordTeaching extends StatelessWidget {
  const WordTeaching({required this.senses, super.key});
  final List<TeachingSense> senses;

  String _label(String value) =>
      const {
        'adj': 'adjective',
        'adv': 'adverb',
        'conj': 'conjunction',
        'pron': 'pronoun',
        'intj': 'interjection',
        'prep': 'preposition',
        'postp': 'postposition',
        'det': 'determiner',
        'num': 'number',
        'classifier': 'measure word',
        'Often before': 'Often preceded by',
        'Often after': 'Often followed by',
      }[value] ??
      value;

  Widget _sense(BuildContext context, TeachingSense sense) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sense.partOfSpeech.isNotEmpty || sense.labels.isNotEmpty)
          Text(
            [
              _label(sense.partOfSpeech),
              ...sense.labels,
            ].where((s) => s.isNotEmpty).join(' · '),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        SelectableText(sense.meaning),
        for (final note in sense.notes) ...[
          const SizedBox(height: 8),
          SelectableText(note),
        ],
        for (final kind in sense.related.map((r) => r.kind).toSet())
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${_label(kind)}: ${sense.related.where((r) => r.kind == kind).map((r) => r.word).toSet().take(4).join('、')}',
            ),
          ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'Meaning and usage',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      for (final sense in senses.take(3)) _sense(context, sense),
      if (senses.length > 3)
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text('More meanings (${senses.length - 3})'),
          children: [
            for (final sense in senses.skip(3)) _sense(context, sense),
          ],
        ),
    ],
  );
}
