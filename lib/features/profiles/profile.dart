import 'package:characters/characters.dart';

enum LearnerLevel {
  beginner('Complete beginner'),
  basics('Some basics'),
  experienced('Experienced');

  const LearnerLevel(this.label);
  final String label;
}

enum LearningGoal {
  everyday('Everyday conversation'),
  travel('Travel'),
  reading('Reading');

  const LearningGoal(this.label);
  final String label;
}

const dailyMinuteOptions = [5, 10, 15, 20];

String? validateProfileName(String? value) {
  final name = value ?? '';
  if (name.trim().isEmpty) return 'Enter a name for your profile.';
  if (RegExp(r'[\x00-\x1F\x7F-\x9F\u200B\u202A-\u202E\u2066-\u2069\uFEFF]')
      .hasMatch(name)) {
    return 'Use a name without hidden or control characters.';
  }
  final units = name.codeUnits;
  for (var i = 0; i < units.length; i++) {
    final unit = units[i];
    if (unit >= 0xD800 && unit <= 0xDBFF) {
      if (++i >= units.length || units[i] < 0xDC00 || units[i] > 0xDFFF) {
        return 'This name contains an invalid character.';
      }
    } else if (unit >= 0xDC00 && unit <= 0xDFFF) {
      return 'This name contains an invalid character.';
    }
  }
  if (name.length > 160 || name.trim().characters.length > 40) {
    return 'Use a name of 40 characters or fewer.';
  }
  return null;
}

class ProfileDraft {
  const ProfileDraft({
    required this.name,
    this.level = LearnerLevel.beginner,
    this.goal = LearningGoal.everyday,
    this.dailyMinutes = 5,
    this.showPinyin = true,
  });

  final String name;
  final LearnerLevel level;
  final LearningGoal goal;
  final int dailyMinutes;
  final bool showPinyin;

  String get validatedName {
    final error = validateProfileName(name);
    if (error != null) throw FormatException(error);
    if (!dailyMinuteOptions.contains(dailyMinutes)) {
      throw const FormatException(
        'Choose a daily goal from the available options.',
      );
    }
    return name.trim();
  }
}

class LearnerProfile {
  const LearnerProfile({
    required this.id,
    required this.name,
    required this.level,
    required this.goal,
    required this.dailyMinutes,
    required this.showPinyin,
    required this.createdAt,
  });

  final int id;
  final String name;
  final LearnerLevel level;
  final LearningGoal goal;
  final int dailyMinutes;
  final bool showPinyin;
  final DateTime createdAt;
}

class ProfileSnapshot {
  ProfileSnapshot({required List<LearnerProfile> profiles, this.selectedId})
    : profiles = List.unmodifiable(profiles);

  final List<LearnerProfile> profiles;
  final int? selectedId;

  LearnerProfile? get selected {
    for (final profile in profiles) {
      if (profile.id == selectedId) return profile;
    }
    return null;
  }
}

abstract interface class ProfileRepository {
  Future<ProfileSnapshot> load();
  Future<ProfileSnapshot> create(ProfileDraft draft);
  Future<ProfileSnapshot> select(int profileId);
}
