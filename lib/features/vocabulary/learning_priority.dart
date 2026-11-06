/// Editorial starting order followed by source bands, not measured difficulty.
class LearningPriority {
  const LearningPriority(this.tier, this.order, this.basis);
  final int tier, order;
  final String basis;
  static const labels = [
    'Start here',
    'Beginner',
    'Intermediate',
    'Advanced',
    'Unranked',
  ];
  String get label => labels[tier];

  factory LearningPriority.parse(Object? raw) {
    if (raw is! Map ||
        raw.length != 3 ||
        raw['tier'] is! int ||
        raw['order'] is! int ||
        !{
          'editorial-foundations-v1',
          'source-band-and-sequence',
          'not-ranked-in-source-list',
        }.contains(raw['basis'])) {
      throw const FormatException('Invalid learning priority.');
    }
    final tier = raw['tier'] as int, order = raw['order'] as int;
    if (tier < 0 || tier > 4 || order < 0 || order > 20000) {
      throw const FormatException('Learning priority is out of range.');
    }
    return LearningPriority(tier, order, raw['basis'] as String);
  }
  Map<String, Object> toJson() => {
    'tier': tier,
    'order': order,
    'basis': basis,
  };

  static int compare(
    LearningPriority? a,
    int? bandA,
    String idA,
    LearningPriority? b,
    int? bandB,
    String idB,
  ) {
    for (final result in [
      (a?.tier ?? 4).compareTo(b?.tier ?? 4),
      (bandA ?? 99).compareTo(bandB ?? 99),
      (a?.order ?? 20000).compareTo(b?.order ?? 20000),
    ]) {
      if (result != 0) return result;
    }
    return idA.compareTo(idB);
  }
}
