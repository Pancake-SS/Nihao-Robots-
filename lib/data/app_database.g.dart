// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyMinutesMeta = const VerificationMeta(
    'dailyMinutes',
  );
  @override
  late final GeneratedColumn<int> dailyMinutes = GeneratedColumn<int>(
    'daily_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _showPinyinMeta = const VerificationMeta(
    'showPinyin',
  );
  @override
  late final GeneratedColumn<bool> showPinyin = GeneratedColumn<bool>(
    'show_pinyin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_pinyin" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    level,
    goal,
    dailyMinutes,
    showPinyin,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('daily_minutes')) {
      context.handle(
        _dailyMinutesMeta,
        dailyMinutes.isAcceptableOrUnknown(
          data['daily_minutes']!,
          _dailyMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyMinutesMeta);
    }
    if (data.containsKey('show_pinyin')) {
      context.handle(
        _showPinyinMeta,
        showPinyin.isAcceptableOrUnknown(data['show_pinyin']!, _showPinyinMeta),
      );
    } else if (isInserting) {
      context.missing(_showPinyinMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      )!,
      dailyMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_minutes'],
      )!,
      showPinyin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_pinyin'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final int id;
  final String name;
  final String level;
  final String goal;
  final int dailyMinutes;
  final bool showPinyin;
  final DateTime createdAt;
  const ProfileRow({
    required this.id,
    required this.name,
    required this.level,
    required this.goal,
    required this.dailyMinutes,
    required this.showPinyin,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['level'] = Variable<String>(level);
    map['goal'] = Variable<String>(goal);
    map['daily_minutes'] = Variable<int>(dailyMinutes);
    map['show_pinyin'] = Variable<bool>(showPinyin);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      level: Value(level),
      goal: Value(goal),
      dailyMinutes: Value(dailyMinutes),
      showPinyin: Value(showPinyin),
      createdAt: Value(createdAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      level: serializer.fromJson<String>(json['level']),
      goal: serializer.fromJson<String>(json['goal']),
      dailyMinutes: serializer.fromJson<int>(json['dailyMinutes']),
      showPinyin: serializer.fromJson<bool>(json['showPinyin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'level': serializer.toJson<String>(level),
      'goal': serializer.toJson<String>(goal),
      'dailyMinutes': serializer.toJson<int>(dailyMinutes),
      'showPinyin': serializer.toJson<bool>(showPinyin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProfileRow copyWith({
    int? id,
    String? name,
    String? level,
    String? goal,
    int? dailyMinutes,
    bool? showPinyin,
    DateTime? createdAt,
  }) => ProfileRow(
    id: id ?? this.id,
    name: name ?? this.name,
    level: level ?? this.level,
    goal: goal ?? this.goal,
    dailyMinutes: dailyMinutes ?? this.dailyMinutes,
    showPinyin: showPinyin ?? this.showPinyin,
    createdAt: createdAt ?? this.createdAt,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      level: data.level.present ? data.level.value : this.level,
      goal: data.goal.present ? data.goal.value : this.goal,
      dailyMinutes: data.dailyMinutes.present
          ? data.dailyMinutes.value
          : this.dailyMinutes,
      showPinyin: data.showPinyin.present
          ? data.showPinyin.value
          : this.showPinyin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('goal: $goal, ')
          ..write('dailyMinutes: $dailyMinutes, ')
          ..write('showPinyin: $showPinyin, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, level, goal, dailyMinutes, showPinyin, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.level == this.level &&
          other.goal == this.goal &&
          other.dailyMinutes == this.dailyMinutes &&
          other.showPinyin == this.showPinyin &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> level;
  final Value<String> goal;
  final Value<int> dailyMinutes;
  final Value<bool> showPinyin;
  final Value<DateTime> createdAt;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.level = const Value.absent(),
    this.goal = const Value.absent(),
    this.dailyMinutes = const Value.absent(),
    this.showPinyin = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String level,
    required String goal,
    required int dailyMinutes,
    required bool showPinyin,
    required DateTime createdAt,
  }) : name = Value(name),
       level = Value(level),
       goal = Value(goal),
       dailyMinutes = Value(dailyMinutes),
       showPinyin = Value(showPinyin),
       createdAt = Value(createdAt);
  static Insertable<ProfileRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? level,
    Expression<String>? goal,
    Expression<int>? dailyMinutes,
    Expression<bool>? showPinyin,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (level != null) 'level': level,
      if (goal != null) 'goal': goal,
      if (dailyMinutes != null) 'daily_minutes': dailyMinutes,
      if (showPinyin != null) 'show_pinyin': showPinyin,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? level,
    Value<String>? goal,
    Value<int>? dailyMinutes,
    Value<bool>? showPinyin,
    Value<DateTime>? createdAt,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      goal: goal ?? this.goal,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      showPinyin: showPinyin ?? this.showPinyin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (dailyMinutes.present) {
      map['daily_minutes'] = Variable<int>(dailyMinutes.value);
    }
    if (showPinyin.present) {
      map['show_pinyin'] = Variable<bool>(showPinyin.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('goal: $goal, ')
          ..write('dailyMinutes: $dailyMinutes, ')
          ..write('showPinyin: $showPinyin, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppPreferencesTable extends AppPreferences
    with TableInfo<$AppPreferencesTable, AppPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedProfileIdMeta = const VerificationMeta(
    'selectedProfileId',
  );
  @override
  late final GeneratedColumn<int> selectedProfileId = GeneratedColumn<int>(
    'selected_profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, selectedProfileId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('selected_profile_id')) {
      context.handle(
        _selectedProfileIdMeta,
        selectedProfileId.isAcceptableOrUnknown(
          data['selected_profile_id']!,
          _selectedProfileIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedProfileIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      selectedProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_profile_id'],
      )!,
    );
  }

  @override
  $AppPreferencesTable createAlias(String alias) {
    return $AppPreferencesTable(attachedDatabase, alias);
  }
}

class AppPreference extends DataClass implements Insertable<AppPreference> {
  final int id;
  final int selectedProfileId;
  const AppPreference({required this.id, required this.selectedProfileId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['selected_profile_id'] = Variable<int>(selectedProfileId);
    return map;
  }

  AppPreferencesCompanion toCompanion(bool nullToAbsent) {
    return AppPreferencesCompanion(
      id: Value(id),
      selectedProfileId: Value(selectedProfileId),
    );
  }

  factory AppPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppPreference(
      id: serializer.fromJson<int>(json['id']),
      selectedProfileId: serializer.fromJson<int>(json['selectedProfileId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'selectedProfileId': serializer.toJson<int>(selectedProfileId),
    };
  }

  AppPreference copyWith({int? id, int? selectedProfileId}) => AppPreference(
    id: id ?? this.id,
    selectedProfileId: selectedProfileId ?? this.selectedProfileId,
  );
  AppPreference copyWithCompanion(AppPreferencesCompanion data) {
    return AppPreference(
      id: data.id.present ? data.id.value : this.id,
      selectedProfileId: data.selectedProfileId.present
          ? data.selectedProfileId.value
          : this.selectedProfileId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppPreference(')
          ..write('id: $id, ')
          ..write('selectedProfileId: $selectedProfileId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, selectedProfileId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppPreference &&
          other.id == this.id &&
          other.selectedProfileId == this.selectedProfileId);
}

class AppPreferencesCompanion extends UpdateCompanion<AppPreference> {
  final Value<int> id;
  final Value<int> selectedProfileId;
  const AppPreferencesCompanion({
    this.id = const Value.absent(),
    this.selectedProfileId = const Value.absent(),
  });
  AppPreferencesCompanion.insert({
    this.id = const Value.absent(),
    required int selectedProfileId,
  }) : selectedProfileId = Value(selectedProfileId);
  static Insertable<AppPreference> custom({
    Expression<int>? id,
    Expression<int>? selectedProfileId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (selectedProfileId != null) 'selected_profile_id': selectedProfileId,
    });
  }

  AppPreferencesCompanion copyWith({
    Value<int>? id,
    Value<int>? selectedProfileId,
  }) {
    return AppPreferencesCompanion(
      id: id ?? this.id,
      selectedProfileId: selectedProfileId ?? this.selectedProfileId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (selectedProfileId.present) {
      map['selected_profile_id'] = Variable<int>(selectedProfileId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('selectedProfileId: $selectedProfileId')
          ..write(')'))
        .toString();
  }
}

class $FoundationProgressTable extends FoundationProgress
    with TableInfo<$FoundationProgressTable, FoundationProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoundationProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [profileId, step, completed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foundation_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoundationProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    }
    if (data.containsKey('step')) {
      context.handle(
        _stepMeta,
        step.isAcceptableOrUnknown(data['step']!, _stepMeta),
      );
    } else if (isInserting) {
      context.missing(_stepMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId};
  @override
  FoundationProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoundationProgressData(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      step: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
    );
  }

  @override
  $FoundationProgressTable createAlias(String alias) {
    return $FoundationProgressTable(attachedDatabase, alias);
  }
}

class FoundationProgressData extends DataClass
    implements Insertable<FoundationProgressData> {
  final int profileId;
  final int step;
  final bool completed;
  const FoundationProgressData({
    required this.profileId,
    required this.step,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['step'] = Variable<int>(step);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  FoundationProgressCompanion toCompanion(bool nullToAbsent) {
    return FoundationProgressCompanion(
      profileId: Value(profileId),
      step: Value(step),
      completed: Value(completed),
    );
  }

  factory FoundationProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoundationProgressData(
      profileId: serializer.fromJson<int>(json['profileId']),
      step: serializer.fromJson<int>(json['step']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'step': serializer.toJson<int>(step),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  FoundationProgressData copyWith({
    int? profileId,
    int? step,
    bool? completed,
  }) => FoundationProgressData(
    profileId: profileId ?? this.profileId,
    step: step ?? this.step,
    completed: completed ?? this.completed,
  );
  FoundationProgressData copyWithCompanion(FoundationProgressCompanion data) {
    return FoundationProgressData(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      step: data.step.present ? data.step.value : this.step,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoundationProgressData(')
          ..write('profileId: $profileId, ')
          ..write('step: $step, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, step, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoundationProgressData &&
          other.profileId == this.profileId &&
          other.step == this.step &&
          other.completed == this.completed);
}

class FoundationProgressCompanion
    extends UpdateCompanion<FoundationProgressData> {
  final Value<int> profileId;
  final Value<int> step;
  final Value<bool> completed;
  const FoundationProgressCompanion({
    this.profileId = const Value.absent(),
    this.step = const Value.absent(),
    this.completed = const Value.absent(),
  });
  FoundationProgressCompanion.insert({
    this.profileId = const Value.absent(),
    required int step,
    required bool completed,
  }) : step = Value(step),
       completed = Value(completed);
  static Insertable<FoundationProgressData> custom({
    Expression<int>? profileId,
    Expression<int>? step,
    Expression<bool>? completed,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (step != null) 'step': step,
      if (completed != null) 'completed': completed,
    });
  }

  FoundationProgressCompanion copyWith({
    Value<int>? profileId,
    Value<int>? step,
    Value<bool>? completed,
  }) {
    return FoundationProgressCompanion(
      profileId: profileId ?? this.profileId,
      step: step ?? this.step,
      completed: completed ?? this.completed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoundationProgressCompanion(')
          ..write('profileId: $profileId, ')
          ..write('step: $step, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }
}

class $VocabularyProgressTable extends VocabularyProgress
    with TableInfo<$VocabularyProgressTable, VocabularyProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
    'stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMsMeta = const VerificationMeta(
    'dueAtMs',
  );
  @override
  late final GeneratedColumn<int> dueAtMs = GeneratedColumn<int>(
    'due_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successfulReviewsMeta = const VerificationMeta(
    'successfulReviews',
  );
  @override
  late final GeneratedColumn<int> successfulReviews = GeneratedColumn<int>(
    'successful_reviews',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    wordId,
    stage,
    dueAtMs,
    version,
    successfulReviews,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularyProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('stage')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(data['stage']!, _stageMeta),
      );
    } else if (isInserting) {
      context.missing(_stageMeta);
    }
    if (data.containsKey('due_at_ms')) {
      context.handle(
        _dueAtMsMeta,
        dueAtMs.isAcceptableOrUnknown(data['due_at_ms']!, _dueAtMsMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMsMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('successful_reviews')) {
      context.handle(
        _successfulReviewsMeta,
        successfulReviews.isAcceptableOrUnknown(
          data['successful_reviews']!,
          _successfulReviewsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_successfulReviewsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, wordId};
  @override
  VocabularyProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyProgressData(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      stage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage'],
      )!,
      dueAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_at_ms'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      successfulReviews: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}successful_reviews'],
      )!,
    );
  }

  @override
  $VocabularyProgressTable createAlias(String alias) {
    return $VocabularyProgressTable(attachedDatabase, alias);
  }
}

class VocabularyProgressData extends DataClass
    implements Insertable<VocabularyProgressData> {
  final int profileId;
  final String wordId;
  final String stage;
  final int dueAtMs;
  final int version;
  final int successfulReviews;
  const VocabularyProgressData({
    required this.profileId,
    required this.wordId,
    required this.stage,
    required this.dueAtMs,
    required this.version,
    required this.successfulReviews,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['word_id'] = Variable<String>(wordId);
    map['stage'] = Variable<String>(stage);
    map['due_at_ms'] = Variable<int>(dueAtMs);
    map['version'] = Variable<int>(version);
    map['successful_reviews'] = Variable<int>(successfulReviews);
    return map;
  }

  VocabularyProgressCompanion toCompanion(bool nullToAbsent) {
    return VocabularyProgressCompanion(
      profileId: Value(profileId),
      wordId: Value(wordId),
      stage: Value(stage),
      dueAtMs: Value(dueAtMs),
      version: Value(version),
      successfulReviews: Value(successfulReviews),
    );
  }

  factory VocabularyProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyProgressData(
      profileId: serializer.fromJson<int>(json['profileId']),
      wordId: serializer.fromJson<String>(json['wordId']),
      stage: serializer.fromJson<String>(json['stage']),
      dueAtMs: serializer.fromJson<int>(json['dueAtMs']),
      version: serializer.fromJson<int>(json['version']),
      successfulReviews: serializer.fromJson<int>(json['successfulReviews']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'wordId': serializer.toJson<String>(wordId),
      'stage': serializer.toJson<String>(stage),
      'dueAtMs': serializer.toJson<int>(dueAtMs),
      'version': serializer.toJson<int>(version),
      'successfulReviews': serializer.toJson<int>(successfulReviews),
    };
  }

  VocabularyProgressData copyWith({
    int? profileId,
    String? wordId,
    String? stage,
    int? dueAtMs,
    int? version,
    int? successfulReviews,
  }) => VocabularyProgressData(
    profileId: profileId ?? this.profileId,
    wordId: wordId ?? this.wordId,
    stage: stage ?? this.stage,
    dueAtMs: dueAtMs ?? this.dueAtMs,
    version: version ?? this.version,
    successfulReviews: successfulReviews ?? this.successfulReviews,
  );
  VocabularyProgressData copyWithCompanion(VocabularyProgressCompanion data) {
    return VocabularyProgressData(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      stage: data.stage.present ? data.stage.value : this.stage,
      dueAtMs: data.dueAtMs.present ? data.dueAtMs.value : this.dueAtMs,
      version: data.version.present ? data.version.value : this.version,
      successfulReviews: data.successfulReviews.present
          ? data.successfulReviews.value
          : this.successfulReviews,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyProgressData(')
          ..write('profileId: $profileId, ')
          ..write('wordId: $wordId, ')
          ..write('stage: $stage, ')
          ..write('dueAtMs: $dueAtMs, ')
          ..write('version: $version, ')
          ..write('successfulReviews: $successfulReviews')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    wordId,
    stage,
    dueAtMs,
    version,
    successfulReviews,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyProgressData &&
          other.profileId == this.profileId &&
          other.wordId == this.wordId &&
          other.stage == this.stage &&
          other.dueAtMs == this.dueAtMs &&
          other.version == this.version &&
          other.successfulReviews == this.successfulReviews);
}

class VocabularyProgressCompanion
    extends UpdateCompanion<VocabularyProgressData> {
  final Value<int> profileId;
  final Value<String> wordId;
  final Value<String> stage;
  final Value<int> dueAtMs;
  final Value<int> version;
  final Value<int> successfulReviews;
  final Value<int> rowid;
  const VocabularyProgressCompanion({
    this.profileId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.stage = const Value.absent(),
    this.dueAtMs = const Value.absent(),
    this.version = const Value.absent(),
    this.successfulReviews = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VocabularyProgressCompanion.insert({
    required int profileId,
    required String wordId,
    required String stage,
    required int dueAtMs,
    required int version,
    required int successfulReviews,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       wordId = Value(wordId),
       stage = Value(stage),
       dueAtMs = Value(dueAtMs),
       version = Value(version),
       successfulReviews = Value(successfulReviews);
  static Insertable<VocabularyProgressData> custom({
    Expression<int>? profileId,
    Expression<String>? wordId,
    Expression<String>? stage,
    Expression<int>? dueAtMs,
    Expression<int>? version,
    Expression<int>? successfulReviews,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (wordId != null) 'word_id': wordId,
      if (stage != null) 'stage': stage,
      if (dueAtMs != null) 'due_at_ms': dueAtMs,
      if (version != null) 'version': version,
      if (successfulReviews != null) 'successful_reviews': successfulReviews,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VocabularyProgressCompanion copyWith({
    Value<int>? profileId,
    Value<String>? wordId,
    Value<String>? stage,
    Value<int>? dueAtMs,
    Value<int>? version,
    Value<int>? successfulReviews,
    Value<int>? rowid,
  }) {
    return VocabularyProgressCompanion(
      profileId: profileId ?? this.profileId,
      wordId: wordId ?? this.wordId,
      stage: stage ?? this.stage,
      dueAtMs: dueAtMs ?? this.dueAtMs,
      version: version ?? this.version,
      successfulReviews: successfulReviews ?? this.successfulReviews,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (stage.present) {
      map['stage'] = Variable<String>(stage.value);
    }
    if (dueAtMs.present) {
      map['due_at_ms'] = Variable<int>(dueAtMs.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (successfulReviews.present) {
      map['successful_reviews'] = Variable<int>(successfulReviews.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyProgressCompanion(')
          ..write('profileId: $profileId, ')
          ..write('wordId: $wordId, ')
          ..write('stage: $stage, ')
          ..write('dueAtMs: $dueAtMs, ')
          ..write('version: $version, ')
          ..write('successfulReviews: $successfulReviews, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VocabularyAttemptsTable extends VocabularyAttempts
    with TableInfo<$VocabularyAttemptsTable, VocabularyAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentRevisionMeta = const VerificationMeta(
    'contentRevision',
  );
  @override
  late final GeneratedColumn<int> contentRevision = GeneratedColumn<int>(
    'content_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionBeforeMeta = const VerificationMeta(
    'versionBefore',
  );
  @override
  late final GeneratedColumn<int> versionBefore = GeneratedColumn<int>(
    'version_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isReviewMeta = const VerificationMeta(
    'isReview',
  );
  @override
  late final GeneratedColumn<bool> isReview = GeneratedColumn<bool>(
    'is_review',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_review" IN (0, 1))',
    ),
  );
  static const VerificationMeta _answersJsonMeta = const VerificationMeta(
    'answersJson',
  );
  @override
  late final GeneratedColumn<String> answersJson = GeneratedColumn<String>(
    'answers_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionsJsonMeta = const VerificationMeta(
    'questionsJson',
  );
  @override
  late final GeneratedColumn<String> questionsJson = GeneratedColumn<String>(
    'questions_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passedMeta = const VerificationMeta('passed');
  @override
  late final GeneratedColumn<bool> passed = GeneratedColumn<bool>(
    'passed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("passed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _answeredAtMsMeta = const VerificationMeta(
    'answeredAtMs',
  );
  @override
  late final GeneratedColumn<int> answeredAtMs = GeneratedColumn<int>(
    'answered_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDueAtMsMeta = const VerificationMeta(
    'nextDueAtMs',
  );
  @override
  late final GeneratedColumn<int> nextDueAtMs = GeneratedColumn<int>(
    'next_due_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextStageMeta = const VerificationMeta(
    'nextStage',
  );
  @override
  late final GeneratedColumn<String> nextStage = GeneratedColumn<String>(
    'next_stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    eventId,
    profileId,
    wordId,
    packId,
    contentRevision,
    versionBefore,
    isReview,
    answersJson,
    questionsJson,
    passed,
    answeredAtMs,
    nextDueAtMs,
    nextStage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularyAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('content_revision')) {
      context.handle(
        _contentRevisionMeta,
        contentRevision.isAcceptableOrUnknown(
          data['content_revision']!,
          _contentRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentRevisionMeta);
    }
    if (data.containsKey('version_before')) {
      context.handle(
        _versionBeforeMeta,
        versionBefore.isAcceptableOrUnknown(
          data['version_before']!,
          _versionBeforeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_versionBeforeMeta);
    }
    if (data.containsKey('is_review')) {
      context.handle(
        _isReviewMeta,
        isReview.isAcceptableOrUnknown(data['is_review']!, _isReviewMeta),
      );
    } else if (isInserting) {
      context.missing(_isReviewMeta);
    }
    if (data.containsKey('answers_json')) {
      context.handle(
        _answersJsonMeta,
        answersJson.isAcceptableOrUnknown(
          data['answers_json']!,
          _answersJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_answersJsonMeta);
    }
    if (data.containsKey('questions_json')) {
      context.handle(
        _questionsJsonMeta,
        questionsJson.isAcceptableOrUnknown(
          data['questions_json']!,
          _questionsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionsJsonMeta);
    }
    if (data.containsKey('passed')) {
      context.handle(
        _passedMeta,
        passed.isAcceptableOrUnknown(data['passed']!, _passedMeta),
      );
    } else if (isInserting) {
      context.missing(_passedMeta);
    }
    if (data.containsKey('answered_at_ms')) {
      context.handle(
        _answeredAtMsMeta,
        answeredAtMs.isAcceptableOrUnknown(
          data['answered_at_ms']!,
          _answeredAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_answeredAtMsMeta);
    }
    if (data.containsKey('next_due_at_ms')) {
      context.handle(
        _nextDueAtMsMeta,
        nextDueAtMs.isAcceptableOrUnknown(
          data['next_due_at_ms']!,
          _nextDueAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextDueAtMsMeta);
    }
    if (data.containsKey('next_stage')) {
      context.handle(
        _nextStageMeta,
        nextStage.isAcceptableOrUnknown(data['next_stage']!, _nextStageMeta),
      );
    } else if (isInserting) {
      context.missing(_nextStageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  VocabularyAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyAttempt(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      contentRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_revision'],
      )!,
      versionBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version_before'],
      )!,
      isReview: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_review'],
      )!,
      answersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answers_json'],
      )!,
      questionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}questions_json'],
      )!,
      passed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}passed'],
      )!,
      answeredAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}answered_at_ms'],
      )!,
      nextDueAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_due_at_ms'],
      )!,
      nextStage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_stage'],
      )!,
    );
  }

  @override
  $VocabularyAttemptsTable createAlias(String alias) {
    return $VocabularyAttemptsTable(attachedDatabase, alias);
  }
}

class VocabularyAttempt extends DataClass
    implements Insertable<VocabularyAttempt> {
  final String eventId;
  final int profileId;
  final String wordId;
  final String packId;
  final int contentRevision;
  final int versionBefore;
  final bool isReview;
  final String answersJson;
  final String questionsJson;
  final bool passed;
  final int answeredAtMs;
  final int nextDueAtMs;
  final String nextStage;
  const VocabularyAttempt({
    required this.eventId,
    required this.profileId,
    required this.wordId,
    required this.packId,
    required this.contentRevision,
    required this.versionBefore,
    required this.isReview,
    required this.answersJson,
    required this.questionsJson,
    required this.passed,
    required this.answeredAtMs,
    required this.nextDueAtMs,
    required this.nextStage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['profile_id'] = Variable<int>(profileId);
    map['word_id'] = Variable<String>(wordId);
    map['pack_id'] = Variable<String>(packId);
    map['content_revision'] = Variable<int>(contentRevision);
    map['version_before'] = Variable<int>(versionBefore);
    map['is_review'] = Variable<bool>(isReview);
    map['answers_json'] = Variable<String>(answersJson);
    map['questions_json'] = Variable<String>(questionsJson);
    map['passed'] = Variable<bool>(passed);
    map['answered_at_ms'] = Variable<int>(answeredAtMs);
    map['next_due_at_ms'] = Variable<int>(nextDueAtMs);
    map['next_stage'] = Variable<String>(nextStage);
    return map;
  }

  VocabularyAttemptsCompanion toCompanion(bool nullToAbsent) {
    return VocabularyAttemptsCompanion(
      eventId: Value(eventId),
      profileId: Value(profileId),
      wordId: Value(wordId),
      packId: Value(packId),
      contentRevision: Value(contentRevision),
      versionBefore: Value(versionBefore),
      isReview: Value(isReview),
      answersJson: Value(answersJson),
      questionsJson: Value(questionsJson),
      passed: Value(passed),
      answeredAtMs: Value(answeredAtMs),
      nextDueAtMs: Value(nextDueAtMs),
      nextStage: Value(nextStage),
    );
  }

  factory VocabularyAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyAttempt(
      eventId: serializer.fromJson<String>(json['eventId']),
      profileId: serializer.fromJson<int>(json['profileId']),
      wordId: serializer.fromJson<String>(json['wordId']),
      packId: serializer.fromJson<String>(json['packId']),
      contentRevision: serializer.fromJson<int>(json['contentRevision']),
      versionBefore: serializer.fromJson<int>(json['versionBefore']),
      isReview: serializer.fromJson<bool>(json['isReview']),
      answersJson: serializer.fromJson<String>(json['answersJson']),
      questionsJson: serializer.fromJson<String>(json['questionsJson']),
      passed: serializer.fromJson<bool>(json['passed']),
      answeredAtMs: serializer.fromJson<int>(json['answeredAtMs']),
      nextDueAtMs: serializer.fromJson<int>(json['nextDueAtMs']),
      nextStage: serializer.fromJson<String>(json['nextStage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'profileId': serializer.toJson<int>(profileId),
      'wordId': serializer.toJson<String>(wordId),
      'packId': serializer.toJson<String>(packId),
      'contentRevision': serializer.toJson<int>(contentRevision),
      'versionBefore': serializer.toJson<int>(versionBefore),
      'isReview': serializer.toJson<bool>(isReview),
      'answersJson': serializer.toJson<String>(answersJson),
      'questionsJson': serializer.toJson<String>(questionsJson),
      'passed': serializer.toJson<bool>(passed),
      'answeredAtMs': serializer.toJson<int>(answeredAtMs),
      'nextDueAtMs': serializer.toJson<int>(nextDueAtMs),
      'nextStage': serializer.toJson<String>(nextStage),
    };
  }

  VocabularyAttempt copyWith({
    String? eventId,
    int? profileId,
    String? wordId,
    String? packId,
    int? contentRevision,
    int? versionBefore,
    bool? isReview,
    String? answersJson,
    String? questionsJson,
    bool? passed,
    int? answeredAtMs,
    int? nextDueAtMs,
    String? nextStage,
  }) => VocabularyAttempt(
    eventId: eventId ?? this.eventId,
    profileId: profileId ?? this.profileId,
    wordId: wordId ?? this.wordId,
    packId: packId ?? this.packId,
    contentRevision: contentRevision ?? this.contentRevision,
    versionBefore: versionBefore ?? this.versionBefore,
    isReview: isReview ?? this.isReview,
    answersJson: answersJson ?? this.answersJson,
    questionsJson: questionsJson ?? this.questionsJson,
    passed: passed ?? this.passed,
    answeredAtMs: answeredAtMs ?? this.answeredAtMs,
    nextDueAtMs: nextDueAtMs ?? this.nextDueAtMs,
    nextStage: nextStage ?? this.nextStage,
  );
  VocabularyAttempt copyWithCompanion(VocabularyAttemptsCompanion data) {
    return VocabularyAttempt(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      packId: data.packId.present ? data.packId.value : this.packId,
      contentRevision: data.contentRevision.present
          ? data.contentRevision.value
          : this.contentRevision,
      versionBefore: data.versionBefore.present
          ? data.versionBefore.value
          : this.versionBefore,
      isReview: data.isReview.present ? data.isReview.value : this.isReview,
      answersJson: data.answersJson.present
          ? data.answersJson.value
          : this.answersJson,
      questionsJson: data.questionsJson.present
          ? data.questionsJson.value
          : this.questionsJson,
      passed: data.passed.present ? data.passed.value : this.passed,
      answeredAtMs: data.answeredAtMs.present
          ? data.answeredAtMs.value
          : this.answeredAtMs,
      nextDueAtMs: data.nextDueAtMs.present
          ? data.nextDueAtMs.value
          : this.nextDueAtMs,
      nextStage: data.nextStage.present ? data.nextStage.value : this.nextStage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyAttempt(')
          ..write('eventId: $eventId, ')
          ..write('profileId: $profileId, ')
          ..write('wordId: $wordId, ')
          ..write('packId: $packId, ')
          ..write('contentRevision: $contentRevision, ')
          ..write('versionBefore: $versionBefore, ')
          ..write('isReview: $isReview, ')
          ..write('answersJson: $answersJson, ')
          ..write('questionsJson: $questionsJson, ')
          ..write('passed: $passed, ')
          ..write('answeredAtMs: $answeredAtMs, ')
          ..write('nextDueAtMs: $nextDueAtMs, ')
          ..write('nextStage: $nextStage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    eventId,
    profileId,
    wordId,
    packId,
    contentRevision,
    versionBefore,
    isReview,
    answersJson,
    questionsJson,
    passed,
    answeredAtMs,
    nextDueAtMs,
    nextStage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyAttempt &&
          other.eventId == this.eventId &&
          other.profileId == this.profileId &&
          other.wordId == this.wordId &&
          other.packId == this.packId &&
          other.contentRevision == this.contentRevision &&
          other.versionBefore == this.versionBefore &&
          other.isReview == this.isReview &&
          other.answersJson == this.answersJson &&
          other.questionsJson == this.questionsJson &&
          other.passed == this.passed &&
          other.answeredAtMs == this.answeredAtMs &&
          other.nextDueAtMs == this.nextDueAtMs &&
          other.nextStage == this.nextStage);
}

class VocabularyAttemptsCompanion extends UpdateCompanion<VocabularyAttempt> {
  final Value<String> eventId;
  final Value<int> profileId;
  final Value<String> wordId;
  final Value<String> packId;
  final Value<int> contentRevision;
  final Value<int> versionBefore;
  final Value<bool> isReview;
  final Value<String> answersJson;
  final Value<String> questionsJson;
  final Value<bool> passed;
  final Value<int> answeredAtMs;
  final Value<int> nextDueAtMs;
  final Value<String> nextStage;
  final Value<int> rowid;
  const VocabularyAttemptsCompanion({
    this.eventId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.packId = const Value.absent(),
    this.contentRevision = const Value.absent(),
    this.versionBefore = const Value.absent(),
    this.isReview = const Value.absent(),
    this.answersJson = const Value.absent(),
    this.questionsJson = const Value.absent(),
    this.passed = const Value.absent(),
    this.answeredAtMs = const Value.absent(),
    this.nextDueAtMs = const Value.absent(),
    this.nextStage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VocabularyAttemptsCompanion.insert({
    required String eventId,
    required int profileId,
    required String wordId,
    required String packId,
    required int contentRevision,
    required int versionBefore,
    required bool isReview,
    required String answersJson,
    required String questionsJson,
    required bool passed,
    required int answeredAtMs,
    required int nextDueAtMs,
    required String nextStage,
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       profileId = Value(profileId),
       wordId = Value(wordId),
       packId = Value(packId),
       contentRevision = Value(contentRevision),
       versionBefore = Value(versionBefore),
       isReview = Value(isReview),
       answersJson = Value(answersJson),
       questionsJson = Value(questionsJson),
       passed = Value(passed),
       answeredAtMs = Value(answeredAtMs),
       nextDueAtMs = Value(nextDueAtMs),
       nextStage = Value(nextStage);
  static Insertable<VocabularyAttempt> custom({
    Expression<String>? eventId,
    Expression<int>? profileId,
    Expression<String>? wordId,
    Expression<String>? packId,
    Expression<int>? contentRevision,
    Expression<int>? versionBefore,
    Expression<bool>? isReview,
    Expression<String>? answersJson,
    Expression<String>? questionsJson,
    Expression<bool>? passed,
    Expression<int>? answeredAtMs,
    Expression<int>? nextDueAtMs,
    Expression<String>? nextStage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (profileId != null) 'profile_id': profileId,
      if (wordId != null) 'word_id': wordId,
      if (packId != null) 'pack_id': packId,
      if (contentRevision != null) 'content_revision': contentRevision,
      if (versionBefore != null) 'version_before': versionBefore,
      if (isReview != null) 'is_review': isReview,
      if (answersJson != null) 'answers_json': answersJson,
      if (questionsJson != null) 'questions_json': questionsJson,
      if (passed != null) 'passed': passed,
      if (answeredAtMs != null) 'answered_at_ms': answeredAtMs,
      if (nextDueAtMs != null) 'next_due_at_ms': nextDueAtMs,
      if (nextStage != null) 'next_stage': nextStage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VocabularyAttemptsCompanion copyWith({
    Value<String>? eventId,
    Value<int>? profileId,
    Value<String>? wordId,
    Value<String>? packId,
    Value<int>? contentRevision,
    Value<int>? versionBefore,
    Value<bool>? isReview,
    Value<String>? answersJson,
    Value<String>? questionsJson,
    Value<bool>? passed,
    Value<int>? answeredAtMs,
    Value<int>? nextDueAtMs,
    Value<String>? nextStage,
    Value<int>? rowid,
  }) {
    return VocabularyAttemptsCompanion(
      eventId: eventId ?? this.eventId,
      profileId: profileId ?? this.profileId,
      wordId: wordId ?? this.wordId,
      packId: packId ?? this.packId,
      contentRevision: contentRevision ?? this.contentRevision,
      versionBefore: versionBefore ?? this.versionBefore,
      isReview: isReview ?? this.isReview,
      answersJson: answersJson ?? this.answersJson,
      questionsJson: questionsJson ?? this.questionsJson,
      passed: passed ?? this.passed,
      answeredAtMs: answeredAtMs ?? this.answeredAtMs,
      nextDueAtMs: nextDueAtMs ?? this.nextDueAtMs,
      nextStage: nextStage ?? this.nextStage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (contentRevision.present) {
      map['content_revision'] = Variable<int>(contentRevision.value);
    }
    if (versionBefore.present) {
      map['version_before'] = Variable<int>(versionBefore.value);
    }
    if (isReview.present) {
      map['is_review'] = Variable<bool>(isReview.value);
    }
    if (answersJson.present) {
      map['answers_json'] = Variable<String>(answersJson.value);
    }
    if (questionsJson.present) {
      map['questions_json'] = Variable<String>(questionsJson.value);
    }
    if (passed.present) {
      map['passed'] = Variable<bool>(passed.value);
    }
    if (answeredAtMs.present) {
      map['answered_at_ms'] = Variable<int>(answeredAtMs.value);
    }
    if (nextDueAtMs.present) {
      map['next_due_at_ms'] = Variable<int>(nextDueAtMs.value);
    }
    if (nextStage.present) {
      map['next_stage'] = Variable<String>(nextStage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyAttemptsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('profileId: $profileId, ')
          ..write('wordId: $wordId, ')
          ..write('packId: $packId, ')
          ..write('contentRevision: $contentRevision, ')
          ..write('versionBefore: $versionBefore, ')
          ..write('isReview: $isReview, ')
          ..write('answersJson: $answersJson, ')
          ..write('questionsJson: $questionsJson, ')
          ..write('passed: $passed, ')
          ..write('answeredAtMs: $answeredAtMs, ')
          ..write('nextDueAtMs: $nextDueAtMs, ')
          ..write('nextStage: $nextStage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PracticeResponsesTable extends PracticeResponses
    with TableInfo<$PracticeResponsesTable, PracticeResponse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PracticeResponsesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _answeredAtMsMeta = const VerificationMeta(
    'answeredAtMs',
  );
  @override
  late final GeneratedColumn<int> answeredAtMs = GeneratedColumn<int>(
    'answered_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    wordId,
    questionId,
    correct,
    answeredAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'practice_responses';
  @override
  VerificationContext validateIntegrity(
    Insertable<PracticeResponse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('answered_at_ms')) {
      context.handle(
        _answeredAtMsMeta,
        answeredAtMs.isAcceptableOrUnknown(
          data['answered_at_ms']!,
          _answeredAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_answeredAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PracticeResponse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PracticeResponse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correct'],
      )!,
      answeredAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}answered_at_ms'],
      )!,
    );
  }

  @override
  $PracticeResponsesTable createAlias(String alias) {
    return $PracticeResponsesTable(attachedDatabase, alias);
  }
}

class PracticeResponse extends DataClass
    implements Insertable<PracticeResponse> {
  final String id;
  final int profileId;
  final String wordId;
  final String questionId;
  final bool correct;
  final int answeredAtMs;
  const PracticeResponse({
    required this.id,
    required this.profileId,
    required this.wordId,
    required this.questionId,
    required this.correct,
    required this.answeredAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['word_id'] = Variable<String>(wordId);
    map['question_id'] = Variable<String>(questionId);
    map['correct'] = Variable<bool>(correct);
    map['answered_at_ms'] = Variable<int>(answeredAtMs);
    return map;
  }

  PracticeResponsesCompanion toCompanion(bool nullToAbsent) {
    return PracticeResponsesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      wordId: Value(wordId),
      questionId: Value(questionId),
      correct: Value(correct),
      answeredAtMs: Value(answeredAtMs),
    );
  }

  factory PracticeResponse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PracticeResponse(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      wordId: serializer.fromJson<String>(json['wordId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      correct: serializer.fromJson<bool>(json['correct']),
      answeredAtMs: serializer.fromJson<int>(json['answeredAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<int>(profileId),
      'wordId': serializer.toJson<String>(wordId),
      'questionId': serializer.toJson<String>(questionId),
      'correct': serializer.toJson<bool>(correct),
      'answeredAtMs': serializer.toJson<int>(answeredAtMs),
    };
  }

  PracticeResponse copyWith({
    String? id,
    int? profileId,
    String? wordId,
    String? questionId,
    bool? correct,
    int? answeredAtMs,
  }) => PracticeResponse(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    wordId: wordId ?? this.wordId,
    questionId: questionId ?? this.questionId,
    correct: correct ?? this.correct,
    answeredAtMs: answeredAtMs ?? this.answeredAtMs,
  );
  PracticeResponse copyWithCompanion(PracticeResponsesCompanion data) {
    return PracticeResponse(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      correct: data.correct.present ? data.correct.value : this.correct,
      answeredAtMs: data.answeredAtMs.present
          ? data.answeredAtMs.value
          : this.answeredAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PracticeResponse(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('wordId: $wordId, ')
          ..write('questionId: $questionId, ')
          ..write('correct: $correct, ')
          ..write('answeredAtMs: $answeredAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, wordId, questionId, correct, answeredAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PracticeResponse &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.wordId == this.wordId &&
          other.questionId == this.questionId &&
          other.correct == this.correct &&
          other.answeredAtMs == this.answeredAtMs);
}

class PracticeResponsesCompanion extends UpdateCompanion<PracticeResponse> {
  final Value<String> id;
  final Value<int> profileId;
  final Value<String> wordId;
  final Value<String> questionId;
  final Value<bool> correct;
  final Value<int> answeredAtMs;
  final Value<int> rowid;
  const PracticeResponsesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.correct = const Value.absent(),
    this.answeredAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PracticeResponsesCompanion.insert({
    required String id,
    required int profileId,
    required String wordId,
    required String questionId,
    required bool correct,
    required int answeredAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       wordId = Value(wordId),
       questionId = Value(questionId),
       correct = Value(correct),
       answeredAtMs = Value(answeredAtMs);
  static Insertable<PracticeResponse> custom({
    Expression<String>? id,
    Expression<int>? profileId,
    Expression<String>? wordId,
    Expression<String>? questionId,
    Expression<bool>? correct,
    Expression<int>? answeredAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (wordId != null) 'word_id': wordId,
      if (questionId != null) 'question_id': questionId,
      if (correct != null) 'correct': correct,
      if (answeredAtMs != null) 'answered_at_ms': answeredAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PracticeResponsesCompanion copyWith({
    Value<String>? id,
    Value<int>? profileId,
    Value<String>? wordId,
    Value<String>? questionId,
    Value<bool>? correct,
    Value<int>? answeredAtMs,
    Value<int>? rowid,
  }) {
    return PracticeResponsesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      wordId: wordId ?? this.wordId,
      questionId: questionId ?? this.questionId,
      correct: correct ?? this.correct,
      answeredAtMs: answeredAtMs ?? this.answeredAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (answeredAtMs.present) {
      map['answered_at_ms'] = Variable<int>(answeredAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PracticeResponsesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('wordId: $wordId, ')
          ..write('questionId: $questionId, ')
          ..write('correct: $correct, ')
          ..write('answeredAtMs: $answeredAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MasteredWordsTable extends MasteredWords
    with TableInfo<$MasteredWordsTable, MasteredWord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasteredWordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _masteredAtMsMeta = const VerificationMeta(
    'masteredAtMs',
  );
  @override
  late final GeneratedColumn<int> masteredAtMs = GeneratedColumn<int>(
    'mastered_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [profileId, wordId, masteredAtMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mastered_words';
  @override
  VerificationContext validateIntegrity(
    Insertable<MasteredWord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('mastered_at_ms')) {
      context.handle(
        _masteredAtMsMeta,
        masteredAtMs.isAcceptableOrUnknown(
          data['mastered_at_ms']!,
          _masteredAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_masteredAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, wordId};
  @override
  MasteredWord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MasteredWord(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      masteredAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mastered_at_ms'],
      )!,
    );
  }

  @override
  $MasteredWordsTable createAlias(String alias) {
    return $MasteredWordsTable(attachedDatabase, alias);
  }
}

class MasteredWord extends DataClass implements Insertable<MasteredWord> {
  final int profileId;
  final String wordId;
  final int masteredAtMs;
  const MasteredWord({
    required this.profileId,
    required this.wordId,
    required this.masteredAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['word_id'] = Variable<String>(wordId);
    map['mastered_at_ms'] = Variable<int>(masteredAtMs);
    return map;
  }

  MasteredWordsCompanion toCompanion(bool nullToAbsent) {
    return MasteredWordsCompanion(
      profileId: Value(profileId),
      wordId: Value(wordId),
      masteredAtMs: Value(masteredAtMs),
    );
  }

  factory MasteredWord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MasteredWord(
      profileId: serializer.fromJson<int>(json['profileId']),
      wordId: serializer.fromJson<String>(json['wordId']),
      masteredAtMs: serializer.fromJson<int>(json['masteredAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'wordId': serializer.toJson<String>(wordId),
      'masteredAtMs': serializer.toJson<int>(masteredAtMs),
    };
  }

  MasteredWord copyWith({int? profileId, String? wordId, int? masteredAtMs}) =>
      MasteredWord(
        profileId: profileId ?? this.profileId,
        wordId: wordId ?? this.wordId,
        masteredAtMs: masteredAtMs ?? this.masteredAtMs,
      );
  MasteredWord copyWithCompanion(MasteredWordsCompanion data) {
    return MasteredWord(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      masteredAtMs: data.masteredAtMs.present
          ? data.masteredAtMs.value
          : this.masteredAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MasteredWord(')
          ..write('profileId: $profileId, ')
          ..write('wordId: $wordId, ')
          ..write('masteredAtMs: $masteredAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, wordId, masteredAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MasteredWord &&
          other.profileId == this.profileId &&
          other.wordId == this.wordId &&
          other.masteredAtMs == this.masteredAtMs);
}

class MasteredWordsCompanion extends UpdateCompanion<MasteredWord> {
  final Value<int> profileId;
  final Value<String> wordId;
  final Value<int> masteredAtMs;
  final Value<int> rowid;
  const MasteredWordsCompanion({
    this.profileId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.masteredAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MasteredWordsCompanion.insert({
    required int profileId,
    required String wordId,
    required int masteredAtMs,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       wordId = Value(wordId),
       masteredAtMs = Value(masteredAtMs);
  static Insertable<MasteredWord> custom({
    Expression<int>? profileId,
    Expression<String>? wordId,
    Expression<int>? masteredAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (wordId != null) 'word_id': wordId,
      if (masteredAtMs != null) 'mastered_at_ms': masteredAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MasteredWordsCompanion copyWith({
    Value<int>? profileId,
    Value<String>? wordId,
    Value<int>? masteredAtMs,
    Value<int>? rowid,
  }) {
    return MasteredWordsCompanion(
      profileId: profileId ?? this.profileId,
      wordId: wordId ?? this.wordId,
      masteredAtMs: masteredAtMs ?? this.masteredAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (masteredAtMs.present) {
      map['mastered_at_ms'] = Variable<int>(masteredAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasteredWordsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('wordId: $wordId, ')
          ..write('masteredAtMs: $masteredAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MasterWritingsTable extends MasterWritings
    with TableInfo<$MasterWritingsTable, MasterWriting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasterWritingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentenceMeta = const VerificationMeta(
    'sentence',
  );
  @override
  late final GeneratedColumn<String> sentence = GeneratedColumn<String>(
    'sentence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _writtenAtMsMeta = const VerificationMeta(
    'writtenAtMs',
  );
  @override
  late final GeneratedColumn<int> writtenAtMs = GeneratedColumn<int>(
    'written_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    wordId,
    prompt,
    sentence,
    writtenAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'master_writings';
  @override
  VerificationContext validateIntegrity(
    Insertable<MasterWriting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    if (data.containsKey('sentence')) {
      context.handle(
        _sentenceMeta,
        sentence.isAcceptableOrUnknown(data['sentence']!, _sentenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceMeta);
    }
    if (data.containsKey('written_at_ms')) {
      context.handle(
        _writtenAtMsMeta,
        writtenAtMs.isAcceptableOrUnknown(
          data['written_at_ms']!,
          _writtenAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_writtenAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MasterWriting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MasterWriting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      prompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt'],
      )!,
      sentence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sentence'],
      )!,
      writtenAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}written_at_ms'],
      )!,
    );
  }

  @override
  $MasterWritingsTable createAlias(String alias) {
    return $MasterWritingsTable(attachedDatabase, alias);
  }
}

class MasterWriting extends DataClass implements Insertable<MasterWriting> {
  final String id;
  final int profileId;
  final String wordId;
  final String prompt;
  final String sentence;
  final int writtenAtMs;
  const MasterWriting({
    required this.id,
    required this.profileId,
    required this.wordId,
    required this.prompt,
    required this.sentence,
    required this.writtenAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<int>(profileId);
    map['word_id'] = Variable<String>(wordId);
    map['prompt'] = Variable<String>(prompt);
    map['sentence'] = Variable<String>(sentence);
    map['written_at_ms'] = Variable<int>(writtenAtMs);
    return map;
  }

  MasterWritingsCompanion toCompanion(bool nullToAbsent) {
    return MasterWritingsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      wordId: Value(wordId),
      prompt: Value(prompt),
      sentence: Value(sentence),
      writtenAtMs: Value(writtenAtMs),
    );
  }

  factory MasterWriting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MasterWriting(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<int>(json['profileId']),
      wordId: serializer.fromJson<String>(json['wordId']),
      prompt: serializer.fromJson<String>(json['prompt']),
      sentence: serializer.fromJson<String>(json['sentence']),
      writtenAtMs: serializer.fromJson<int>(json['writtenAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<int>(profileId),
      'wordId': serializer.toJson<String>(wordId),
      'prompt': serializer.toJson<String>(prompt),
      'sentence': serializer.toJson<String>(sentence),
      'writtenAtMs': serializer.toJson<int>(writtenAtMs),
    };
  }

  MasterWriting copyWith({
    String? id,
    int? profileId,
    String? wordId,
    String? prompt,
    String? sentence,
    int? writtenAtMs,
  }) => MasterWriting(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    wordId: wordId ?? this.wordId,
    prompt: prompt ?? this.prompt,
    sentence: sentence ?? this.sentence,
    writtenAtMs: writtenAtMs ?? this.writtenAtMs,
  );
  MasterWriting copyWithCompanion(MasterWritingsCompanion data) {
    return MasterWriting(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      sentence: data.sentence.present ? data.sentence.value : this.sentence,
      writtenAtMs: data.writtenAtMs.present
          ? data.writtenAtMs.value
          : this.writtenAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MasterWriting(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('wordId: $wordId, ')
          ..write('prompt: $prompt, ')
          ..write('sentence: $sentence, ')
          ..write('writtenAtMs: $writtenAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, wordId, prompt, sentence, writtenAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MasterWriting &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.wordId == this.wordId &&
          other.prompt == this.prompt &&
          other.sentence == this.sentence &&
          other.writtenAtMs == this.writtenAtMs);
}

class MasterWritingsCompanion extends UpdateCompanion<MasterWriting> {
  final Value<String> id;
  final Value<int> profileId;
  final Value<String> wordId;
  final Value<String> prompt;
  final Value<String> sentence;
  final Value<int> writtenAtMs;
  final Value<int> rowid;
  const MasterWritingsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.prompt = const Value.absent(),
    this.sentence = const Value.absent(),
    this.writtenAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MasterWritingsCompanion.insert({
    required String id,
    required int profileId,
    required String wordId,
    required String prompt,
    required String sentence,
    required int writtenAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       wordId = Value(wordId),
       prompt = Value(prompt),
       sentence = Value(sentence),
       writtenAtMs = Value(writtenAtMs);
  static Insertable<MasterWriting> custom({
    Expression<String>? id,
    Expression<int>? profileId,
    Expression<String>? wordId,
    Expression<String>? prompt,
    Expression<String>? sentence,
    Expression<int>? writtenAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (wordId != null) 'word_id': wordId,
      if (prompt != null) 'prompt': prompt,
      if (sentence != null) 'sentence': sentence,
      if (writtenAtMs != null) 'written_at_ms': writtenAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MasterWritingsCompanion copyWith({
    Value<String>? id,
    Value<int>? profileId,
    Value<String>? wordId,
    Value<String>? prompt,
    Value<String>? sentence,
    Value<int>? writtenAtMs,
    Value<int>? rowid,
  }) {
    return MasterWritingsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      wordId: wordId ?? this.wordId,
      prompt: prompt ?? this.prompt,
      sentence: sentence ?? this.sentence,
      writtenAtMs: writtenAtMs ?? this.writtenAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (sentence.present) {
      map['sentence'] = Variable<String>(sentence.value);
    }
    if (writtenAtMs.present) {
      map['written_at_ms'] = Variable<int>(writtenAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasterWritingsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('wordId: $wordId, ')
          ..write('prompt: $prompt, ')
          ..write('sentence: $sentence, ')
          ..write('writtenAtMs: $writtenAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GrammarLessonsTable extends GrammarLessons
    with TableInfo<$GrammarLessonsTable, GrammarLessonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarLessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allsetIdMeta = const VerificationMeta(
    'allsetId',
  );
  @override
  late final GeneratedColumn<String> allsetId = GeneratedColumn<String>(
    'allset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allsetTitleMeta = const VerificationMeta(
    'allsetTitle',
  );
  @override
  late final GeneratedColumn<String> allsetTitle = GeneratedColumn<String>(
    'allset_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allsetNoteMeta = const VerificationMeta(
    'allsetNote',
  );
  @override
  late final GeneratedColumn<String> allsetNote = GeneratedColumn<String>(
    'allset_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    position,
    level,
    title,
    category,
    pattern,
    explanation,
    allsetId,
    allsetTitle,
    allsetNote,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarLessonRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('allset_id')) {
      context.handle(
        _allsetIdMeta,
        allsetId.isAcceptableOrUnknown(data['allset_id']!, _allsetIdMeta),
      );
    }
    if (data.containsKey('allset_title')) {
      context.handle(
        _allsetTitleMeta,
        allsetTitle.isAcceptableOrUnknown(
          data['allset_title']!,
          _allsetTitleMeta,
        ),
      );
    }
    if (data.containsKey('allset_note')) {
      context.handle(
        _allsetNoteMeta,
        allsetNote.isAcceptableOrUnknown(data['allset_note']!, _allsetNoteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarLessonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarLessonRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      )!,
      allsetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allset_id'],
      ),
      allsetTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allset_title'],
      ),
      allsetNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allset_note'],
      ),
    );
  }

  @override
  $GrammarLessonsTable createAlias(String alias) {
    return $GrammarLessonsTable(attachedDatabase, alias);
  }
}

class GrammarLessonRow extends DataClass
    implements Insertable<GrammarLessonRow> {
  final String id;
  final int position;
  final int level;
  final String title;
  final String category;
  final String pattern;
  final String explanation;
  final String? allsetId;
  final String? allsetTitle;
  final String? allsetNote;
  const GrammarLessonRow({
    required this.id,
    required this.position,
    required this.level,
    required this.title,
    required this.category,
    required this.pattern,
    required this.explanation,
    this.allsetId,
    this.allsetTitle,
    this.allsetNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['position'] = Variable<int>(position);
    map['level'] = Variable<int>(level);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['pattern'] = Variable<String>(pattern);
    map['explanation'] = Variable<String>(explanation);
    if (!nullToAbsent || allsetId != null) {
      map['allset_id'] = Variable<String>(allsetId);
    }
    if (!nullToAbsent || allsetTitle != null) {
      map['allset_title'] = Variable<String>(allsetTitle);
    }
    if (!nullToAbsent || allsetNote != null) {
      map['allset_note'] = Variable<String>(allsetNote);
    }
    return map;
  }

  GrammarLessonsCompanion toCompanion(bool nullToAbsent) {
    return GrammarLessonsCompanion(
      id: Value(id),
      position: Value(position),
      level: Value(level),
      title: Value(title),
      category: Value(category),
      pattern: Value(pattern),
      explanation: Value(explanation),
      allsetId: allsetId == null && nullToAbsent
          ? const Value.absent()
          : Value(allsetId),
      allsetTitle: allsetTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(allsetTitle),
      allsetNote: allsetNote == null && nullToAbsent
          ? const Value.absent()
          : Value(allsetNote),
    );
  }

  factory GrammarLessonRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarLessonRow(
      id: serializer.fromJson<String>(json['id']),
      position: serializer.fromJson<int>(json['position']),
      level: serializer.fromJson<int>(json['level']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      pattern: serializer.fromJson<String>(json['pattern']),
      explanation: serializer.fromJson<String>(json['explanation']),
      allsetId: serializer.fromJson<String?>(json['allsetId']),
      allsetTitle: serializer.fromJson<String?>(json['allsetTitle']),
      allsetNote: serializer.fromJson<String?>(json['allsetNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'position': serializer.toJson<int>(position),
      'level': serializer.toJson<int>(level),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'pattern': serializer.toJson<String>(pattern),
      'explanation': serializer.toJson<String>(explanation),
      'allsetId': serializer.toJson<String?>(allsetId),
      'allsetTitle': serializer.toJson<String?>(allsetTitle),
      'allsetNote': serializer.toJson<String?>(allsetNote),
    };
  }

  GrammarLessonRow copyWith({
    String? id,
    int? position,
    int? level,
    String? title,
    String? category,
    String? pattern,
    String? explanation,
    Value<String?> allsetId = const Value.absent(),
    Value<String?> allsetTitle = const Value.absent(),
    Value<String?> allsetNote = const Value.absent(),
  }) => GrammarLessonRow(
    id: id ?? this.id,
    position: position ?? this.position,
    level: level ?? this.level,
    title: title ?? this.title,
    category: category ?? this.category,
    pattern: pattern ?? this.pattern,
    explanation: explanation ?? this.explanation,
    allsetId: allsetId.present ? allsetId.value : this.allsetId,
    allsetTitle: allsetTitle.present ? allsetTitle.value : this.allsetTitle,
    allsetNote: allsetNote.present ? allsetNote.value : this.allsetNote,
  );
  GrammarLessonRow copyWithCompanion(GrammarLessonsCompanion data) {
    return GrammarLessonRow(
      id: data.id.present ? data.id.value : this.id,
      position: data.position.present ? data.position.value : this.position,
      level: data.level.present ? data.level.value : this.level,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      allsetId: data.allsetId.present ? data.allsetId.value : this.allsetId,
      allsetTitle: data.allsetTitle.present
          ? data.allsetTitle.value
          : this.allsetTitle,
      allsetNote: data.allsetNote.present
          ? data.allsetNote.value
          : this.allsetNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLessonRow(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('level: $level, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('pattern: $pattern, ')
          ..write('explanation: $explanation, ')
          ..write('allsetId: $allsetId, ')
          ..write('allsetTitle: $allsetTitle, ')
          ..write('allsetNote: $allsetNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    position,
    level,
    title,
    category,
    pattern,
    explanation,
    allsetId,
    allsetTitle,
    allsetNote,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarLessonRow &&
          other.id == this.id &&
          other.position == this.position &&
          other.level == this.level &&
          other.title == this.title &&
          other.category == this.category &&
          other.pattern == this.pattern &&
          other.explanation == this.explanation &&
          other.allsetId == this.allsetId &&
          other.allsetTitle == this.allsetTitle &&
          other.allsetNote == this.allsetNote);
}

class GrammarLessonsCompanion extends UpdateCompanion<GrammarLessonRow> {
  final Value<String> id;
  final Value<int> position;
  final Value<int> level;
  final Value<String> title;
  final Value<String> category;
  final Value<String> pattern;
  final Value<String> explanation;
  final Value<String?> allsetId;
  final Value<String?> allsetTitle;
  final Value<String?> allsetNote;
  final Value<int> rowid;
  const GrammarLessonsCompanion({
    this.id = const Value.absent(),
    this.position = const Value.absent(),
    this.level = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.pattern = const Value.absent(),
    this.explanation = const Value.absent(),
    this.allsetId = const Value.absent(),
    this.allsetTitle = const Value.absent(),
    this.allsetNote = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrammarLessonsCompanion.insert({
    required String id,
    required int position,
    required int level,
    required String title,
    required String category,
    required String pattern,
    required String explanation,
    this.allsetId = const Value.absent(),
    this.allsetTitle = const Value.absent(),
    this.allsetNote = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       position = Value(position),
       level = Value(level),
       title = Value(title),
       category = Value(category),
       pattern = Value(pattern),
       explanation = Value(explanation);
  static Insertable<GrammarLessonRow> custom({
    Expression<String>? id,
    Expression<int>? position,
    Expression<int>? level,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? pattern,
    Expression<String>? explanation,
    Expression<String>? allsetId,
    Expression<String>? allsetTitle,
    Expression<String>? allsetNote,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (position != null) 'position': position,
      if (level != null) 'level': level,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (pattern != null) 'pattern': pattern,
      if (explanation != null) 'explanation': explanation,
      if (allsetId != null) 'allset_id': allsetId,
      if (allsetTitle != null) 'allset_title': allsetTitle,
      if (allsetNote != null) 'allset_note': allsetNote,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrammarLessonsCompanion copyWith({
    Value<String>? id,
    Value<int>? position,
    Value<int>? level,
    Value<String>? title,
    Value<String>? category,
    Value<String>? pattern,
    Value<String>? explanation,
    Value<String?>? allsetId,
    Value<String?>? allsetTitle,
    Value<String?>? allsetNote,
    Value<int>? rowid,
  }) {
    return GrammarLessonsCompanion(
      id: id ?? this.id,
      position: position ?? this.position,
      level: level ?? this.level,
      title: title ?? this.title,
      category: category ?? this.category,
      pattern: pattern ?? this.pattern,
      explanation: explanation ?? this.explanation,
      allsetId: allsetId ?? this.allsetId,
      allsetTitle: allsetTitle ?? this.allsetTitle,
      allsetNote: allsetNote ?? this.allsetNote,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (allsetId.present) {
      map['allset_id'] = Variable<String>(allsetId.value);
    }
    if (allsetTitle.present) {
      map['allset_title'] = Variable<String>(allsetTitle.value);
    }
    if (allsetNote.present) {
      map['allset_note'] = Variable<String>(allsetNote.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLessonsCompanion(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('level: $level, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('pattern: $pattern, ')
          ..write('explanation: $explanation, ')
          ..write('allsetId: $allsetId, ')
          ..write('allsetTitle: $allsetTitle, ')
          ..write('allsetNote: $allsetNote, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GrammarExamplesTable extends GrammarExamples
    with TableInfo<$GrammarExamplesTable, GrammarExample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarExamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES grammar_lessons (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chineseMeta = const VerificationMeta(
    'chinese',
  );
  @override
  late final GeneratedColumn<String> chinese = GeneratedColumn<String>(
    'chinese',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinyinMeta = const VerificationMeta('pinyin');
  @override
  late final GeneratedColumn<String> pinyin = GeneratedColumn<String>(
    'pinyin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _englishMeta = const VerificationMeta(
    'english',
  );
  @override
  late final GeneratedColumn<String> english = GeneratedColumn<String>(
    'english',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    lessonId,
    position,
    chinese,
    pinyin,
    english,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_examples';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarExample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('chinese')) {
      context.handle(
        _chineseMeta,
        chinese.isAcceptableOrUnknown(data['chinese']!, _chineseMeta),
      );
    } else if (isInserting) {
      context.missing(_chineseMeta);
    }
    if (data.containsKey('pinyin')) {
      context.handle(
        _pinyinMeta,
        pinyin.isAcceptableOrUnknown(data['pinyin']!, _pinyinMeta),
      );
    } else if (isInserting) {
      context.missing(_pinyinMeta);
    }
    if (data.containsKey('english')) {
      context.handle(
        _englishMeta,
        english.isAcceptableOrUnknown(data['english']!, _englishMeta),
      );
    } else if (isInserting) {
      context.missing(_englishMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonId, position};
  @override
  GrammarExample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarExample(
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      chinese: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chinese'],
      )!,
      pinyin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pinyin'],
      )!,
      english: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}english'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $GrammarExamplesTable createAlias(String alias) {
    return $GrammarExamplesTable(attachedDatabase, alias);
  }
}

class GrammarExample extends DataClass implements Insertable<GrammarExample> {
  final String lessonId;
  final int position;
  final String chinese;
  final String pinyin;
  final String english;
  final String source;
  const GrammarExample({
    required this.lessonId,
    required this.position,
    required this.chinese,
    required this.pinyin,
    required this.english,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    map['position'] = Variable<int>(position);
    map['chinese'] = Variable<String>(chinese);
    map['pinyin'] = Variable<String>(pinyin);
    map['english'] = Variable<String>(english);
    map['source'] = Variable<String>(source);
    return map;
  }

  GrammarExamplesCompanion toCompanion(bool nullToAbsent) {
    return GrammarExamplesCompanion(
      lessonId: Value(lessonId),
      position: Value(position),
      chinese: Value(chinese),
      pinyin: Value(pinyin),
      english: Value(english),
      source: Value(source),
    );
  }

  factory GrammarExample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarExample(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      position: serializer.fromJson<int>(json['position']),
      chinese: serializer.fromJson<String>(json['chinese']),
      pinyin: serializer.fromJson<String>(json['pinyin']),
      english: serializer.fromJson<String>(json['english']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'position': serializer.toJson<int>(position),
      'chinese': serializer.toJson<String>(chinese),
      'pinyin': serializer.toJson<String>(pinyin),
      'english': serializer.toJson<String>(english),
      'source': serializer.toJson<String>(source),
    };
  }

  GrammarExample copyWith({
    String? lessonId,
    int? position,
    String? chinese,
    String? pinyin,
    String? english,
    String? source,
  }) => GrammarExample(
    lessonId: lessonId ?? this.lessonId,
    position: position ?? this.position,
    chinese: chinese ?? this.chinese,
    pinyin: pinyin ?? this.pinyin,
    english: english ?? this.english,
    source: source ?? this.source,
  );
  GrammarExample copyWithCompanion(GrammarExamplesCompanion data) {
    return GrammarExample(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      position: data.position.present ? data.position.value : this.position,
      chinese: data.chinese.present ? data.chinese.value : this.chinese,
      pinyin: data.pinyin.present ? data.pinyin.value : this.pinyin,
      english: data.english.present ? data.english.value : this.english,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarExample(')
          ..write('lessonId: $lessonId, ')
          ..write('position: $position, ')
          ..write('chinese: $chinese, ')
          ..write('pinyin: $pinyin, ')
          ..write('english: $english, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(lessonId, position, chinese, pinyin, english, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarExample &&
          other.lessonId == this.lessonId &&
          other.position == this.position &&
          other.chinese == this.chinese &&
          other.pinyin == this.pinyin &&
          other.english == this.english &&
          other.source == this.source);
}

class GrammarExamplesCompanion extends UpdateCompanion<GrammarExample> {
  final Value<String> lessonId;
  final Value<int> position;
  final Value<String> chinese;
  final Value<String> pinyin;
  final Value<String> english;
  final Value<String> source;
  final Value<int> rowid;
  const GrammarExamplesCompanion({
    this.lessonId = const Value.absent(),
    this.position = const Value.absent(),
    this.chinese = const Value.absent(),
    this.pinyin = const Value.absent(),
    this.english = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrammarExamplesCompanion.insert({
    required String lessonId,
    required int position,
    required String chinese,
    required String pinyin,
    required String english,
    required String source,
    this.rowid = const Value.absent(),
  }) : lessonId = Value(lessonId),
       position = Value(position),
       chinese = Value(chinese),
       pinyin = Value(pinyin),
       english = Value(english),
       source = Value(source);
  static Insertable<GrammarExample> custom({
    Expression<String>? lessonId,
    Expression<int>? position,
    Expression<String>? chinese,
    Expression<String>? pinyin,
    Expression<String>? english,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (position != null) 'position': position,
      if (chinese != null) 'chinese': chinese,
      if (pinyin != null) 'pinyin': pinyin,
      if (english != null) 'english': english,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrammarExamplesCompanion copyWith({
    Value<String>? lessonId,
    Value<int>? position,
    Value<String>? chinese,
    Value<String>? pinyin,
    Value<String>? english,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return GrammarExamplesCompanion(
      lessonId: lessonId ?? this.lessonId,
      position: position ?? this.position,
      chinese: chinese ?? this.chinese,
      pinyin: pinyin ?? this.pinyin,
      english: english ?? this.english,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (chinese.present) {
      map['chinese'] = Variable<String>(chinese.value);
    }
    if (pinyin.present) {
      map['pinyin'] = Variable<String>(pinyin.value);
    }
    if (english.present) {
      map['english'] = Variable<String>(english.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarExamplesCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('position: $position, ')
          ..write('chinese: $chinese, ')
          ..write('pinyin: $pinyin, ')
          ..write('english: $english, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GrammarProgressTable extends GrammarProgress
    with TableInfo<$GrammarProgressTable, GrammarProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES grammar_lessons (id)',
    ),
  );
  static const VerificationMeta _completedAtMsMeta = const VerificationMeta(
    'completedAtMs',
  );
  @override
  late final GeneratedColumn<int> completedAtMs = GeneratedColumn<int>(
    'completed_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [profileId, lessonId, completedAtMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('completed_at_ms')) {
      context.handle(
        _completedAtMsMeta,
        completedAtMs.isAcceptableOrUnknown(
          data['completed_at_ms']!,
          _completedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, lessonId};
  @override
  GrammarProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarProgressData(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      completedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at_ms'],
      )!,
    );
  }

  @override
  $GrammarProgressTable createAlias(String alias) {
    return $GrammarProgressTable(attachedDatabase, alias);
  }
}

class GrammarProgressData extends DataClass
    implements Insertable<GrammarProgressData> {
  final int profileId;
  final String lessonId;
  final int completedAtMs;
  const GrammarProgressData({
    required this.profileId,
    required this.lessonId,
    required this.completedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['completed_at_ms'] = Variable<int>(completedAtMs);
    return map;
  }

  GrammarProgressCompanion toCompanion(bool nullToAbsent) {
    return GrammarProgressCompanion(
      profileId: Value(profileId),
      lessonId: Value(lessonId),
      completedAtMs: Value(completedAtMs),
    );
  }

  factory GrammarProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarProgressData(
      profileId: serializer.fromJson<int>(json['profileId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      completedAtMs: serializer.fromJson<int>(json['completedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'lessonId': serializer.toJson<String>(lessonId),
      'completedAtMs': serializer.toJson<int>(completedAtMs),
    };
  }

  GrammarProgressData copyWith({
    int? profileId,
    String? lessonId,
    int? completedAtMs,
  }) => GrammarProgressData(
    profileId: profileId ?? this.profileId,
    lessonId: lessonId ?? this.lessonId,
    completedAtMs: completedAtMs ?? this.completedAtMs,
  );
  GrammarProgressData copyWithCompanion(GrammarProgressCompanion data) {
    return GrammarProgressData(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      completedAtMs: data.completedAtMs.present
          ? data.completedAtMs.value
          : this.completedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarProgressData(')
          ..write('profileId: $profileId, ')
          ..write('lessonId: $lessonId, ')
          ..write('completedAtMs: $completedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, lessonId, completedAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarProgressData &&
          other.profileId == this.profileId &&
          other.lessonId == this.lessonId &&
          other.completedAtMs == this.completedAtMs);
}

class GrammarProgressCompanion extends UpdateCompanion<GrammarProgressData> {
  final Value<int> profileId;
  final Value<String> lessonId;
  final Value<int> completedAtMs;
  final Value<int> rowid;
  const GrammarProgressCompanion({
    this.profileId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.completedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrammarProgressCompanion.insert({
    required int profileId,
    required String lessonId,
    required int completedAtMs,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       lessonId = Value(lessonId),
       completedAtMs = Value(completedAtMs);
  static Insertable<GrammarProgressData> custom({
    Expression<int>? profileId,
    Expression<String>? lessonId,
    Expression<int>? completedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (completedAtMs != null) 'completed_at_ms': completedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrammarProgressCompanion copyWith({
    Value<int>? profileId,
    Value<String>? lessonId,
    Value<int>? completedAtMs,
    Value<int>? rowid,
  }) {
    return GrammarProgressCompanion(
      profileId: profileId ?? this.profileId,
      lessonId: lessonId ?? this.lessonId,
      completedAtMs: completedAtMs ?? this.completedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (completedAtMs.present) {
      map['completed_at_ms'] = Variable<int>(completedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarProgressCompanion(')
          ..write('profileId: $profileId, ')
          ..write('lessonId: $lessonId, ')
          ..write('completedAtMs: $completedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GrammarInstallsTable extends GrammarInstalls
    with TableInfo<$GrammarInstallsTable, GrammarInstall> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarInstallsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _digestMeta = const VerificationMeta('digest');
  @override
  late final GeneratedColumn<String> digest = GeneratedColumn<String>(
    'digest',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, revision, digest];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_installs';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarInstall> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('digest')) {
      context.handle(
        _digestMeta,
        digest.isAcceptableOrUnknown(data['digest']!, _digestMeta),
      );
    } else if (isInserting) {
      context.missing(_digestMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarInstall map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarInstall(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      digest: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}digest'],
      )!,
    );
  }

  @override
  $GrammarInstallsTable createAlias(String alias) {
    return $GrammarInstallsTable(attachedDatabase, alias);
  }
}

class GrammarInstall extends DataClass implements Insertable<GrammarInstall> {
  final int id;
  final int revision;
  final String digest;
  const GrammarInstall({
    required this.id,
    required this.revision,
    required this.digest,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['revision'] = Variable<int>(revision);
    map['digest'] = Variable<String>(digest);
    return map;
  }

  GrammarInstallsCompanion toCompanion(bool nullToAbsent) {
    return GrammarInstallsCompanion(
      id: Value(id),
      revision: Value(revision),
      digest: Value(digest),
    );
  }

  factory GrammarInstall.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarInstall(
      id: serializer.fromJson<int>(json['id']),
      revision: serializer.fromJson<int>(json['revision']),
      digest: serializer.fromJson<String>(json['digest']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'revision': serializer.toJson<int>(revision),
      'digest': serializer.toJson<String>(digest),
    };
  }

  GrammarInstall copyWith({int? id, int? revision, String? digest}) =>
      GrammarInstall(
        id: id ?? this.id,
        revision: revision ?? this.revision,
        digest: digest ?? this.digest,
      );
  GrammarInstall copyWithCompanion(GrammarInstallsCompanion data) {
    return GrammarInstall(
      id: data.id.present ? data.id.value : this.id,
      revision: data.revision.present ? data.revision.value : this.revision,
      digest: data.digest.present ? data.digest.value : this.digest,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarInstall(')
          ..write('id: $id, ')
          ..write('revision: $revision, ')
          ..write('digest: $digest')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, revision, digest);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarInstall &&
          other.id == this.id &&
          other.revision == this.revision &&
          other.digest == this.digest);
}

class GrammarInstallsCompanion extends UpdateCompanion<GrammarInstall> {
  final Value<int> id;
  final Value<int> revision;
  final Value<String> digest;
  const GrammarInstallsCompanion({
    this.id = const Value.absent(),
    this.revision = const Value.absent(),
    this.digest = const Value.absent(),
  });
  GrammarInstallsCompanion.insert({
    this.id = const Value.absent(),
    required int revision,
    required String digest,
  }) : revision = Value(revision),
       digest = Value(digest);
  static Insertable<GrammarInstall> custom({
    Expression<int>? id,
    Expression<int>? revision,
    Expression<String>? digest,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revision != null) 'revision': revision,
      if (digest != null) 'digest': digest,
    });
  }

  GrammarInstallsCompanion copyWith({
    Value<int>? id,
    Value<int>? revision,
    Value<String>? digest,
  }) {
    return GrammarInstallsCompanion(
      id: id ?? this.id,
      revision: revision ?? this.revision,
      digest: digest ?? this.digest,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (digest.present) {
      map['digest'] = Variable<String>(digest.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarInstallsCompanion(')
          ..write('id: $id, ')
          ..write('revision: $revision, ')
          ..write('digest: $digest')
          ..write(')'))
        .toString();
  }
}

class $ContentPacksTable extends ContentPacks
    with TableInfo<$ContentPacksTable, ContentPack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentPacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentSchemaMeta = const VerificationMeta(
    'contentSchema',
  );
  @override
  late final GeneratedColumn<int> contentSchema = GeneratedColumn<int>(
    'content_schema',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canonicalJsonMeta = const VerificationMeta(
    'canonicalJson',
  );
  @override
  late final GeneratedColumn<String> canonicalJson = GeneratedColumn<String>(
    'canonical_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    revision,
    contentSchema,
    canonicalJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_packs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentPack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('content_schema')) {
      context.handle(
        _contentSchemaMeta,
        contentSchema.isAcceptableOrUnknown(
          data['content_schema']!,
          _contentSchemaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentSchemaMeta);
    }
    if (data.containsKey('canonical_json')) {
      context.handle(
        _canonicalJsonMeta,
        canonicalJson.isAcceptableOrUnknown(
          data['canonical_json']!,
          _canonicalJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentPack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentPack(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      contentSchema: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_schema'],
      )!,
      canonicalJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_json'],
      )!,
    );
  }

  @override
  $ContentPacksTable createAlias(String alias) {
    return $ContentPacksTable(attachedDatabase, alias);
  }
}

class ContentPack extends DataClass implements Insertable<ContentPack> {
  final String id;
  final int revision;
  final int contentSchema;
  final String canonicalJson;
  const ContentPack({
    required this.id,
    required this.revision,
    required this.contentSchema,
    required this.canonicalJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision'] = Variable<int>(revision);
    map['content_schema'] = Variable<int>(contentSchema);
    map['canonical_json'] = Variable<String>(canonicalJson);
    return map;
  }

  ContentPacksCompanion toCompanion(bool nullToAbsent) {
    return ContentPacksCompanion(
      id: Value(id),
      revision: Value(revision),
      contentSchema: Value(contentSchema),
      canonicalJson: Value(canonicalJson),
    );
  }

  factory ContentPack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentPack(
      id: serializer.fromJson<String>(json['id']),
      revision: serializer.fromJson<int>(json['revision']),
      contentSchema: serializer.fromJson<int>(json['contentSchema']),
      canonicalJson: serializer.fromJson<String>(json['canonicalJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revision': serializer.toJson<int>(revision),
      'contentSchema': serializer.toJson<int>(contentSchema),
      'canonicalJson': serializer.toJson<String>(canonicalJson),
    };
  }

  ContentPack copyWith({
    String? id,
    int? revision,
    int? contentSchema,
    String? canonicalJson,
  }) => ContentPack(
    id: id ?? this.id,
    revision: revision ?? this.revision,
    contentSchema: contentSchema ?? this.contentSchema,
    canonicalJson: canonicalJson ?? this.canonicalJson,
  );
  ContentPack copyWithCompanion(ContentPacksCompanion data) {
    return ContentPack(
      id: data.id.present ? data.id.value : this.id,
      revision: data.revision.present ? data.revision.value : this.revision,
      contentSchema: data.contentSchema.present
          ? data.contentSchema.value
          : this.contentSchema,
      canonicalJson: data.canonicalJson.present
          ? data.canonicalJson.value
          : this.canonicalJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentPack(')
          ..write('id: $id, ')
          ..write('revision: $revision, ')
          ..write('contentSchema: $contentSchema, ')
          ..write('canonicalJson: $canonicalJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, revision, contentSchema, canonicalJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentPack &&
          other.id == this.id &&
          other.revision == this.revision &&
          other.contentSchema == this.contentSchema &&
          other.canonicalJson == this.canonicalJson);
}

class ContentPacksCompanion extends UpdateCompanion<ContentPack> {
  final Value<String> id;
  final Value<int> revision;
  final Value<int> contentSchema;
  final Value<String> canonicalJson;
  final Value<int> rowid;
  const ContentPacksCompanion({
    this.id = const Value.absent(),
    this.revision = const Value.absent(),
    this.contentSchema = const Value.absent(),
    this.canonicalJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentPacksCompanion.insert({
    required String id,
    required int revision,
    required int contentSchema,
    required String canonicalJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revision = Value(revision),
       contentSchema = Value(contentSchema),
       canonicalJson = Value(canonicalJson);
  static Insertable<ContentPack> custom({
    Expression<String>? id,
    Expression<int>? revision,
    Expression<int>? contentSchema,
    Expression<String>? canonicalJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revision != null) 'revision': revision,
      if (contentSchema != null) 'content_schema': contentSchema,
      if (canonicalJson != null) 'canonical_json': canonicalJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentPacksCompanion copyWith({
    Value<String>? id,
    Value<int>? revision,
    Value<int>? contentSchema,
    Value<String>? canonicalJson,
    Value<int>? rowid,
  }) {
    return ContentPacksCompanion(
      id: id ?? this.id,
      revision: revision ?? this.revision,
      contentSchema: contentSchema ?? this.contentSchema,
      canonicalJson: canonicalJson ?? this.canonicalJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (contentSchema.present) {
      map['content_schema'] = Variable<int>(contentSchema.value);
    }
    if (canonicalJson.present) {
      map['canonical_json'] = Variable<String>(canonicalJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentPacksCompanion(')
          ..write('id: $id, ')
          ..write('revision: $revision, ')
          ..write('contentSchema: $contentSchema, ')
          ..write('canonicalJson: $canonicalJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentWordsTable extends ContentWords
    with TableInfo<$ContentWordsTable, ContentWord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentWordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_packs (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hanziMeta = const VerificationMeta('hanzi');
  @override
  late final GeneratedColumn<String> hanzi = GeneratedColumn<String>(
    'hanzi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinyinMeta = const VerificationMeta('pinyin');
  @override
  late final GeneratedColumn<String> pinyin = GeneratedColumn<String>(
    'pinyin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    position,
    hanzi,
    pinyin,
    metadataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_words';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentWord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('hanzi')) {
      context.handle(
        _hanziMeta,
        hanzi.isAcceptableOrUnknown(data['hanzi']!, _hanziMeta),
      );
    } else if (isInserting) {
      context.missing(_hanziMeta);
    }
    if (data.containsKey('pinyin')) {
      context.handle(
        _pinyinMeta,
        pinyin.isAcceptableOrUnknown(data['pinyin']!, _pinyinMeta),
      );
    } else if (isInserting) {
      context.missing(_pinyinMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_metadataJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentWord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentWord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      hanzi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hanzi'],
      )!,
      pinyin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pinyin'],
      )!,
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
    );
  }

  @override
  $ContentWordsTable createAlias(String alias) {
    return $ContentWordsTable(attachedDatabase, alias);
  }
}

class ContentWord extends DataClass implements Insertable<ContentWord> {
  final String id;
  final String packId;
  final int position;
  final String hanzi;
  final String pinyin;
  final String metadataJson;
  const ContentWord({
    required this.id,
    required this.packId,
    required this.position,
    required this.hanzi,
    required this.pinyin,
    required this.metadataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['position'] = Variable<int>(position);
    map['hanzi'] = Variable<String>(hanzi);
    map['pinyin'] = Variable<String>(pinyin);
    map['metadata_json'] = Variable<String>(metadataJson);
    return map;
  }

  ContentWordsCompanion toCompanion(bool nullToAbsent) {
    return ContentWordsCompanion(
      id: Value(id),
      packId: Value(packId),
      position: Value(position),
      hanzi: Value(hanzi),
      pinyin: Value(pinyin),
      metadataJson: Value(metadataJson),
    );
  }

  factory ContentWord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentWord(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      position: serializer.fromJson<int>(json['position']),
      hanzi: serializer.fromJson<String>(json['hanzi']),
      pinyin: serializer.fromJson<String>(json['pinyin']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'position': serializer.toJson<int>(position),
      'hanzi': serializer.toJson<String>(hanzi),
      'pinyin': serializer.toJson<String>(pinyin),
      'metadataJson': serializer.toJson<String>(metadataJson),
    };
  }

  ContentWord copyWith({
    String? id,
    String? packId,
    int? position,
    String? hanzi,
    String? pinyin,
    String? metadataJson,
  }) => ContentWord(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    position: position ?? this.position,
    hanzi: hanzi ?? this.hanzi,
    pinyin: pinyin ?? this.pinyin,
    metadataJson: metadataJson ?? this.metadataJson,
  );
  ContentWord copyWithCompanion(ContentWordsCompanion data) {
    return ContentWord(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      position: data.position.present ? data.position.value : this.position,
      hanzi: data.hanzi.present ? data.hanzi.value : this.hanzi,
      pinyin: data.pinyin.present ? data.pinyin.value : this.pinyin,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentWord(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('position: $position, ')
          ..write('hanzi: $hanzi, ')
          ..write('pinyin: $pinyin, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, packId, position, hanzi, pinyin, metadataJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentWord &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.position == this.position &&
          other.hanzi == this.hanzi &&
          other.pinyin == this.pinyin &&
          other.metadataJson == this.metadataJson);
}

class ContentWordsCompanion extends UpdateCompanion<ContentWord> {
  final Value<String> id;
  final Value<String> packId;
  final Value<int> position;
  final Value<String> hanzi;
  final Value<String> pinyin;
  final Value<String> metadataJson;
  final Value<int> rowid;
  const ContentWordsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.position = const Value.absent(),
    this.hanzi = const Value.absent(),
    this.pinyin = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentWordsCompanion.insert({
    required String id,
    required String packId,
    required int position,
    required String hanzi,
    required String pinyin,
    required String metadataJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       position = Value(position),
       hanzi = Value(hanzi),
       pinyin = Value(pinyin),
       metadataJson = Value(metadataJson);
  static Insertable<ContentWord> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<int>? position,
    Expression<String>? hanzi,
    Expression<String>? pinyin,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (position != null) 'position': position,
      if (hanzi != null) 'hanzi': hanzi,
      if (pinyin != null) 'pinyin': pinyin,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentWordsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<int>? position,
    Value<String>? hanzi,
    Value<String>? pinyin,
    Value<String>? metadataJson,
    Value<int>? rowid,
  }) {
    return ContentWordsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      position: position ?? this.position,
      hanzi: hanzi ?? this.hanzi,
      pinyin: pinyin ?? this.pinyin,
      metadataJson: metadataJson ?? this.metadataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (hanzi.present) {
      map['hanzi'] = Variable<String>(hanzi.value);
    }
    if (pinyin.present) {
      map['pinyin'] = Variable<String>(pinyin.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentWordsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('position: $position, ')
          ..write('hanzi: $hanzi, ')
          ..write('pinyin: $pinyin, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentExamplesTable extends ContentExamples
    with TableInfo<$ContentExamplesTable, ContentExample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentExamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_words (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [wordId, position, payloadJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_examples';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentExample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId, position};
  @override
  ContentExample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentExample(
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $ContentExamplesTable createAlias(String alias) {
    return $ContentExamplesTable(attachedDatabase, alias);
  }
}

class ContentExample extends DataClass implements Insertable<ContentExample> {
  final String wordId;
  final int position;
  final String payloadJson;
  const ContentExample({
    required this.wordId,
    required this.position,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['position'] = Variable<int>(position);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  ContentExamplesCompanion toCompanion(bool nullToAbsent) {
    return ContentExamplesCompanion(
      wordId: Value(wordId),
      position: Value(position),
      payloadJson: Value(payloadJson),
    );
  }

  factory ContentExample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentExample(
      wordId: serializer.fromJson<String>(json['wordId']),
      position: serializer.fromJson<int>(json['position']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'position': serializer.toJson<int>(position),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  ContentExample copyWith({
    String? wordId,
    int? position,
    String? payloadJson,
  }) => ContentExample(
    wordId: wordId ?? this.wordId,
    position: position ?? this.position,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  ContentExample copyWithCompanion(ContentExamplesCompanion data) {
    return ContentExample(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      position: data.position.present ? data.position.value : this.position,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentExample(')
          ..write('wordId: $wordId, ')
          ..write('position: $position, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(wordId, position, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentExample &&
          other.wordId == this.wordId &&
          other.position == this.position &&
          other.payloadJson == this.payloadJson);
}

class ContentExamplesCompanion extends UpdateCompanion<ContentExample> {
  final Value<String> wordId;
  final Value<int> position;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const ContentExamplesCompanion({
    this.wordId = const Value.absent(),
    this.position = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentExamplesCompanion.insert({
    required String wordId,
    required int position,
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : wordId = Value(wordId),
       position = Value(position),
       payloadJson = Value(payloadJson);
  static Insertable<ContentExample> custom({
    Expression<String>? wordId,
    Expression<int>? position,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (position != null) 'position': position,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentExamplesCompanion copyWith({
    Value<String>? wordId,
    Value<int>? position,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return ContentExamplesCompanion(
      wordId: wordId ?? this.wordId,
      position: position ?? this.position,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentExamplesCompanion(')
          ..write('wordId: $wordId, ')
          ..write('position: $position, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentExercisesTable extends ContentExercises
    with TableInfo<$ContentExercisesTable, ContentExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES content_words (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    wordId,
    questionId,
    position,
    kind,
    payloadJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId, questionId};
  @override
  ContentExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentExercise(
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $ContentExercisesTable createAlias(String alias) {
    return $ContentExercisesTable(attachedDatabase, alias);
  }
}

class ContentExercise extends DataClass implements Insertable<ContentExercise> {
  final String wordId;
  final String questionId;
  final int position;
  final String kind;
  final String payloadJson;
  const ContentExercise({
    required this.wordId,
    required this.questionId,
    required this.position,
    required this.kind,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['question_id'] = Variable<String>(questionId);
    map['position'] = Variable<int>(position);
    map['kind'] = Variable<String>(kind);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  ContentExercisesCompanion toCompanion(bool nullToAbsent) {
    return ContentExercisesCompanion(
      wordId: Value(wordId),
      questionId: Value(questionId),
      position: Value(position),
      kind: Value(kind),
      payloadJson: Value(payloadJson),
    );
  }

  factory ContentExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentExercise(
      wordId: serializer.fromJson<String>(json['wordId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      position: serializer.fromJson<int>(json['position']),
      kind: serializer.fromJson<String>(json['kind']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'questionId': serializer.toJson<String>(questionId),
      'position': serializer.toJson<int>(position),
      'kind': serializer.toJson<String>(kind),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  ContentExercise copyWith({
    String? wordId,
    String? questionId,
    int? position,
    String? kind,
    String? payloadJson,
  }) => ContentExercise(
    wordId: wordId ?? this.wordId,
    questionId: questionId ?? this.questionId,
    position: position ?? this.position,
    kind: kind ?? this.kind,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  ContentExercise copyWithCompanion(ContentExercisesCompanion data) {
    return ContentExercise(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      position: data.position.present ? data.position.value : this.position,
      kind: data.kind.present ? data.kind.value : this.kind,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentExercise(')
          ..write('wordId: $wordId, ')
          ..write('questionId: $questionId, ')
          ..write('position: $position, ')
          ..write('kind: $kind, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(wordId, questionId, position, kind, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentExercise &&
          other.wordId == this.wordId &&
          other.questionId == this.questionId &&
          other.position == this.position &&
          other.kind == this.kind &&
          other.payloadJson == this.payloadJson);
}

class ContentExercisesCompanion extends UpdateCompanion<ContentExercise> {
  final Value<String> wordId;
  final Value<String> questionId;
  final Value<int> position;
  final Value<String> kind;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const ContentExercisesCompanion({
    this.wordId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.position = const Value.absent(),
    this.kind = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentExercisesCompanion.insert({
    required String wordId,
    required String questionId,
    required int position,
    required String kind,
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : wordId = Value(wordId),
       questionId = Value(questionId),
       position = Value(position),
       kind = Value(kind),
       payloadJson = Value(payloadJson);
  static Insertable<ContentExercise> custom({
    Expression<String>? wordId,
    Expression<String>? questionId,
    Expression<int>? position,
    Expression<String>? kind,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (questionId != null) 'question_id': questionId,
      if (position != null) 'position': position,
      if (kind != null) 'kind': kind,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentExercisesCompanion copyWith({
    Value<String>? wordId,
    Value<String>? questionId,
    Value<int>? position,
    Value<String>? kind,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return ContentExercisesCompanion(
      wordId: wordId ?? this.wordId,
      questionId: questionId ?? this.questionId,
      position: position ?? this.position,
      kind: kind ?? this.kind,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentExercisesCompanion(')
          ..write('wordId: $wordId, ')
          ..write('questionId: $questionId, ')
          ..write('position: $position, ')
          ..write('kind: $kind, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CurriculumWordsTable extends CurriculumWords
    with TableInfo<$CurriculumWordsTable, CurriculumWord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurriculumWordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentSchemaMeta = const VerificationMeta(
    'contentSchema',
  );
  @override
  late final GeneratedColumn<int> contentSchema = GeneratedColumn<int>(
    'content_schema',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hanziMeta = const VerificationMeta('hanzi');
  @override
  late final GeneratedColumn<String> hanzi = GeneratedColumn<String>(
    'hanzi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinyinMeta = const VerificationMeta('pinyin');
  @override
  late final GeneratedColumn<String> pinyin = GeneratedColumn<String>(
    'pinyin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchTextMeta = const VerificationMeta(
    'searchText',
  );
  @override
  late final GeneratedColumn<String> searchText = GeneratedColumn<String>(
    'search_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultPositionMeta = const VerificationMeta(
    'defaultPosition',
  );
  @override
  late final GeneratedColumn<int> defaultPosition = GeneratedColumn<int>(
    'default_position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packId,
    revision,
    contentSchema,
    hanzi,
    pinyin,
    meaning,
    searchText,
    defaultPosition,
    metadataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'curriculum_words';
  @override
  VerificationContext validateIntegrity(
    Insertable<CurriculumWord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('content_schema')) {
      context.handle(
        _contentSchemaMeta,
        contentSchema.isAcceptableOrUnknown(
          data['content_schema']!,
          _contentSchemaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentSchemaMeta);
    }
    if (data.containsKey('hanzi')) {
      context.handle(
        _hanziMeta,
        hanzi.isAcceptableOrUnknown(data['hanzi']!, _hanziMeta),
      );
    } else if (isInserting) {
      context.missing(_hanziMeta);
    }
    if (data.containsKey('pinyin')) {
      context.handle(
        _pinyinMeta,
        pinyin.isAcceptableOrUnknown(data['pinyin']!, _pinyinMeta),
      );
    } else if (isInserting) {
      context.missing(_pinyinMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(
        _meaningMeta,
        meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    if (data.containsKey('search_text')) {
      context.handle(
        _searchTextMeta,
        searchText.isAcceptableOrUnknown(data['search_text']!, _searchTextMeta),
      );
    } else if (isInserting) {
      context.missing(_searchTextMeta);
    }
    if (data.containsKey('default_position')) {
      context.handle(
        _defaultPositionMeta,
        defaultPosition.isAcceptableOrUnknown(
          data['default_position']!,
          _defaultPositionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultPositionMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_metadataJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurriculumWord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurriculumWord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      contentSchema: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_schema'],
      )!,
      hanzi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hanzi'],
      )!,
      pinyin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pinyin'],
      )!,
      meaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning'],
      )!,
      searchText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_text'],
      )!,
      defaultPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_position'],
      )!,
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
    );
  }

  @override
  $CurriculumWordsTable createAlias(String alias) {
    return $CurriculumWordsTable(attachedDatabase, alias);
  }
}

class CurriculumWord extends DataClass implements Insertable<CurriculumWord> {
  final String id;
  final String packId;
  final int revision;
  final int contentSchema;
  final String hanzi;
  final String pinyin;
  final String meaning;
  final String searchText;
  final int defaultPosition;
  final String metadataJson;
  const CurriculumWord({
    required this.id,
    required this.packId,
    required this.revision,
    required this.contentSchema,
    required this.hanzi,
    required this.pinyin,
    required this.meaning,
    required this.searchText,
    required this.defaultPosition,
    required this.metadataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pack_id'] = Variable<String>(packId);
    map['revision'] = Variable<int>(revision);
    map['content_schema'] = Variable<int>(contentSchema);
    map['hanzi'] = Variable<String>(hanzi);
    map['pinyin'] = Variable<String>(pinyin);
    map['meaning'] = Variable<String>(meaning);
    map['search_text'] = Variable<String>(searchText);
    map['default_position'] = Variable<int>(defaultPosition);
    map['metadata_json'] = Variable<String>(metadataJson);
    return map;
  }

  CurriculumWordsCompanion toCompanion(bool nullToAbsent) {
    return CurriculumWordsCompanion(
      id: Value(id),
      packId: Value(packId),
      revision: Value(revision),
      contentSchema: Value(contentSchema),
      hanzi: Value(hanzi),
      pinyin: Value(pinyin),
      meaning: Value(meaning),
      searchText: Value(searchText),
      defaultPosition: Value(defaultPosition),
      metadataJson: Value(metadataJson),
    );
  }

  factory CurriculumWord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurriculumWord(
      id: serializer.fromJson<String>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      revision: serializer.fromJson<int>(json['revision']),
      contentSchema: serializer.fromJson<int>(json['contentSchema']),
      hanzi: serializer.fromJson<String>(json['hanzi']),
      pinyin: serializer.fromJson<String>(json['pinyin']),
      meaning: serializer.fromJson<String>(json['meaning']),
      searchText: serializer.fromJson<String>(json['searchText']),
      defaultPosition: serializer.fromJson<int>(json['defaultPosition']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packId': serializer.toJson<String>(packId),
      'revision': serializer.toJson<int>(revision),
      'contentSchema': serializer.toJson<int>(contentSchema),
      'hanzi': serializer.toJson<String>(hanzi),
      'pinyin': serializer.toJson<String>(pinyin),
      'meaning': serializer.toJson<String>(meaning),
      'searchText': serializer.toJson<String>(searchText),
      'defaultPosition': serializer.toJson<int>(defaultPosition),
      'metadataJson': serializer.toJson<String>(metadataJson),
    };
  }

  CurriculumWord copyWith({
    String? id,
    String? packId,
    int? revision,
    int? contentSchema,
    String? hanzi,
    String? pinyin,
    String? meaning,
    String? searchText,
    int? defaultPosition,
    String? metadataJson,
  }) => CurriculumWord(
    id: id ?? this.id,
    packId: packId ?? this.packId,
    revision: revision ?? this.revision,
    contentSchema: contentSchema ?? this.contentSchema,
    hanzi: hanzi ?? this.hanzi,
    pinyin: pinyin ?? this.pinyin,
    meaning: meaning ?? this.meaning,
    searchText: searchText ?? this.searchText,
    defaultPosition: defaultPosition ?? this.defaultPosition,
    metadataJson: metadataJson ?? this.metadataJson,
  );
  CurriculumWord copyWithCompanion(CurriculumWordsCompanion data) {
    return CurriculumWord(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      revision: data.revision.present ? data.revision.value : this.revision,
      contentSchema: data.contentSchema.present
          ? data.contentSchema.value
          : this.contentSchema,
      hanzi: data.hanzi.present ? data.hanzi.value : this.hanzi,
      pinyin: data.pinyin.present ? data.pinyin.value : this.pinyin,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
      searchText: data.searchText.present
          ? data.searchText.value
          : this.searchText,
      defaultPosition: data.defaultPosition.present
          ? data.defaultPosition.value
          : this.defaultPosition,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumWord(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('revision: $revision, ')
          ..write('contentSchema: $contentSchema, ')
          ..write('hanzi: $hanzi, ')
          ..write('pinyin: $pinyin, ')
          ..write('meaning: $meaning, ')
          ..write('searchText: $searchText, ')
          ..write('defaultPosition: $defaultPosition, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packId,
    revision,
    contentSchema,
    hanzi,
    pinyin,
    meaning,
    searchText,
    defaultPosition,
    metadataJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurriculumWord &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.revision == this.revision &&
          other.contentSchema == this.contentSchema &&
          other.hanzi == this.hanzi &&
          other.pinyin == this.pinyin &&
          other.meaning == this.meaning &&
          other.searchText == this.searchText &&
          other.defaultPosition == this.defaultPosition &&
          other.metadataJson == this.metadataJson);
}

class CurriculumWordsCompanion extends UpdateCompanion<CurriculumWord> {
  final Value<String> id;
  final Value<String> packId;
  final Value<int> revision;
  final Value<int> contentSchema;
  final Value<String> hanzi;
  final Value<String> pinyin;
  final Value<String> meaning;
  final Value<String> searchText;
  final Value<int> defaultPosition;
  final Value<String> metadataJson;
  final Value<int> rowid;
  const CurriculumWordsCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.revision = const Value.absent(),
    this.contentSchema = const Value.absent(),
    this.hanzi = const Value.absent(),
    this.pinyin = const Value.absent(),
    this.meaning = const Value.absent(),
    this.searchText = const Value.absent(),
    this.defaultPosition = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurriculumWordsCompanion.insert({
    required String id,
    required String packId,
    required int revision,
    required int contentSchema,
    required String hanzi,
    required String pinyin,
    required String meaning,
    required String searchText,
    required int defaultPosition,
    required String metadataJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       packId = Value(packId),
       revision = Value(revision),
       contentSchema = Value(contentSchema),
       hanzi = Value(hanzi),
       pinyin = Value(pinyin),
       meaning = Value(meaning),
       searchText = Value(searchText),
       defaultPosition = Value(defaultPosition),
       metadataJson = Value(metadataJson);
  static Insertable<CurriculumWord> custom({
    Expression<String>? id,
    Expression<String>? packId,
    Expression<int>? revision,
    Expression<int>? contentSchema,
    Expression<String>? hanzi,
    Expression<String>? pinyin,
    Expression<String>? meaning,
    Expression<String>? searchText,
    Expression<int>? defaultPosition,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (revision != null) 'revision': revision,
      if (contentSchema != null) 'content_schema': contentSchema,
      if (hanzi != null) 'hanzi': hanzi,
      if (pinyin != null) 'pinyin': pinyin,
      if (meaning != null) 'meaning': meaning,
      if (searchText != null) 'search_text': searchText,
      if (defaultPosition != null) 'default_position': defaultPosition,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurriculumWordsCompanion copyWith({
    Value<String>? id,
    Value<String>? packId,
    Value<int>? revision,
    Value<int>? contentSchema,
    Value<String>? hanzi,
    Value<String>? pinyin,
    Value<String>? meaning,
    Value<String>? searchText,
    Value<int>? defaultPosition,
    Value<String>? metadataJson,
    Value<int>? rowid,
  }) {
    return CurriculumWordsCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      revision: revision ?? this.revision,
      contentSchema: contentSchema ?? this.contentSchema,
      hanzi: hanzi ?? this.hanzi,
      pinyin: pinyin ?? this.pinyin,
      meaning: meaning ?? this.meaning,
      searchText: searchText ?? this.searchText,
      defaultPosition: defaultPosition ?? this.defaultPosition,
      metadataJson: metadataJson ?? this.metadataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (contentSchema.present) {
      map['content_schema'] = Variable<int>(contentSchema.value);
    }
    if (hanzi.present) {
      map['hanzi'] = Variable<String>(hanzi.value);
    }
    if (pinyin.present) {
      map['pinyin'] = Variable<String>(pinyin.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (searchText.present) {
      map['search_text'] = Variable<String>(searchText.value);
    }
    if (defaultPosition.present) {
      map['default_position'] = Variable<int>(defaultPosition.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumWordsCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('revision: $revision, ')
          ..write('contentSchema: $contentSchema, ')
          ..write('hanzi: $hanzi, ')
          ..write('pinyin: $pinyin, ')
          ..write('meaning: $meaning, ')
          ..write('searchText: $searchText, ')
          ..write('defaultPosition: $defaultPosition, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CurriculumSentencesTable extends CurriculumSentences
    with TableInfo<$CurriculumSentencesTable, CurriculumSentence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurriculumSentencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, payloadJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'curriculum_sentences';
  @override
  VerificationContext validateIntegrity(
    Insertable<CurriculumSentence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurriculumSentence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurriculumSentence(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $CurriculumSentencesTable createAlias(String alias) {
    return $CurriculumSentencesTable(attachedDatabase, alias);
  }
}

class CurriculumSentence extends DataClass
    implements Insertable<CurriculumSentence> {
  final String id;
  final String payloadJson;
  const CurriculumSentence({required this.id, required this.payloadJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  CurriculumSentencesCompanion toCompanion(bool nullToAbsent) {
    return CurriculumSentencesCompanion(
      id: Value(id),
      payloadJson: Value(payloadJson),
    );
  }

  factory CurriculumSentence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurriculumSentence(
      id: serializer.fromJson<String>(json['id']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  CurriculumSentence copyWith({String? id, String? payloadJson}) =>
      CurriculumSentence(
        id: id ?? this.id,
        payloadJson: payloadJson ?? this.payloadJson,
      );
  CurriculumSentence copyWithCompanion(CurriculumSentencesCompanion data) {
    return CurriculumSentence(
      id: data.id.present ? data.id.value : this.id,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumSentence(')
          ..write('id: $id, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurriculumSentence &&
          other.id == this.id &&
          other.payloadJson == this.payloadJson);
}

class CurriculumSentencesCompanion extends UpdateCompanion<CurriculumSentence> {
  final Value<String> id;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const CurriculumSentencesCompanion({
    this.id = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurriculumSentencesCompanion.insert({
    required String id,
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       payloadJson = Value(payloadJson);
  static Insertable<CurriculumSentence> custom({
    Expression<String>? id,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurriculumSentencesCompanion copyWith({
    Value<String>? id,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return CurriculumSentencesCompanion(
      id: id ?? this.id,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumSentencesCompanion(')
          ..write('id: $id, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CurriculumExamplesTable extends CurriculumExamples
    with TableInfo<$CurriculumExamplesTable, CurriculumExample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurriculumExamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES curriculum_words (id)',
    ),
  );
  static const VerificationMeta _sentenceIdMeta = const VerificationMeta(
    'sentenceId',
  );
  @override
  late final GeneratedColumn<String> sentenceId = GeneratedColumn<String>(
    'sentence_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES curriculum_sentences (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [wordId, sentenceId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'curriculum_examples';
  @override
  VerificationContext validateIntegrity(
    Insertable<CurriculumExample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('sentence_id')) {
      context.handle(
        _sentenceIdMeta,
        sentenceId.isAcceptableOrUnknown(data['sentence_id']!, _sentenceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId, position};
  @override
  CurriculumExample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurriculumExample(
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      sentenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sentence_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $CurriculumExamplesTable createAlias(String alias) {
    return $CurriculumExamplesTable(attachedDatabase, alias);
  }
}

class CurriculumExample extends DataClass
    implements Insertable<CurriculumExample> {
  final String wordId;
  final String sentenceId;
  final int position;
  const CurriculumExample({
    required this.wordId,
    required this.sentenceId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['sentence_id'] = Variable<String>(sentenceId);
    map['position'] = Variable<int>(position);
    return map;
  }

  CurriculumExamplesCompanion toCompanion(bool nullToAbsent) {
    return CurriculumExamplesCompanion(
      wordId: Value(wordId),
      sentenceId: Value(sentenceId),
      position: Value(position),
    );
  }

  factory CurriculumExample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurriculumExample(
      wordId: serializer.fromJson<String>(json['wordId']),
      sentenceId: serializer.fromJson<String>(json['sentenceId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'sentenceId': serializer.toJson<String>(sentenceId),
      'position': serializer.toJson<int>(position),
    };
  }

  CurriculumExample copyWith({
    String? wordId,
    String? sentenceId,
    int? position,
  }) => CurriculumExample(
    wordId: wordId ?? this.wordId,
    sentenceId: sentenceId ?? this.sentenceId,
    position: position ?? this.position,
  );
  CurriculumExample copyWithCompanion(CurriculumExamplesCompanion data) {
    return CurriculumExample(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      sentenceId: data.sentenceId.present
          ? data.sentenceId.value
          : this.sentenceId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumExample(')
          ..write('wordId: $wordId, ')
          ..write('sentenceId: $sentenceId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(wordId, sentenceId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurriculumExample &&
          other.wordId == this.wordId &&
          other.sentenceId == this.sentenceId &&
          other.position == this.position);
}

class CurriculumExamplesCompanion extends UpdateCompanion<CurriculumExample> {
  final Value<String> wordId;
  final Value<String> sentenceId;
  final Value<int> position;
  final Value<int> rowid;
  const CurriculumExamplesCompanion({
    this.wordId = const Value.absent(),
    this.sentenceId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurriculumExamplesCompanion.insert({
    required String wordId,
    required String sentenceId,
    required int position,
    this.rowid = const Value.absent(),
  }) : wordId = Value(wordId),
       sentenceId = Value(sentenceId),
       position = Value(position);
  static Insertable<CurriculumExample> custom({
    Expression<String>? wordId,
    Expression<String>? sentenceId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (sentenceId != null) 'sentence_id': sentenceId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurriculumExamplesCompanion copyWith({
    Value<String>? wordId,
    Value<String>? sentenceId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return CurriculumExamplesCompanion(
      wordId: wordId ?? this.wordId,
      sentenceId: sentenceId ?? this.sentenceId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (sentenceId.present) {
      map['sentence_id'] = Variable<String>(sentenceId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumExamplesCompanion(')
          ..write('wordId: $wordId, ')
          ..write('sentenceId: $sentenceId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CurriculumAudioTable extends CurriculumAudio
    with TableInfo<$CurriculumAudioTable, CurriculumAudioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurriculumAudioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentenceIdMeta = const VerificationMeta(
    'sentenceId',
  );
  @override
  late final GeneratedColumn<String> sentenceId = GeneratedColumn<String>(
    'sentence_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES curriculum_sentences (id)',
    ),
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localAvailableMeta = const VerificationMeta(
    'localAvailable',
  );
  @override
  late final GeneratedColumn<bool> localAvailable = GeneratedColumn<bool>(
    'local_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("local_available" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sentenceId,
    payloadJson,
    localAvailable,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'curriculum_audio';
  @override
  VerificationContext validateIntegrity(
    Insertable<CurriculumAudioData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sentence_id')) {
      context.handle(
        _sentenceIdMeta,
        sentenceId.isAcceptableOrUnknown(data['sentence_id']!, _sentenceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('local_available')) {
      context.handle(
        _localAvailableMeta,
        localAvailable.isAcceptableOrUnknown(
          data['local_available']!,
          _localAvailableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localAvailableMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurriculumAudioData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurriculumAudioData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sentenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sentence_id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      localAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}local_available'],
      )!,
    );
  }

  @override
  $CurriculumAudioTable createAlias(String alias) {
    return $CurriculumAudioTable(attachedDatabase, alias);
  }
}

class CurriculumAudioData extends DataClass
    implements Insertable<CurriculumAudioData> {
  final String id;
  final String sentenceId;
  final String payloadJson;
  final bool localAvailable;
  const CurriculumAudioData({
    required this.id,
    required this.sentenceId,
    required this.payloadJson,
    required this.localAvailable,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sentence_id'] = Variable<String>(sentenceId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['local_available'] = Variable<bool>(localAvailable);
    return map;
  }

  CurriculumAudioCompanion toCompanion(bool nullToAbsent) {
    return CurriculumAudioCompanion(
      id: Value(id),
      sentenceId: Value(sentenceId),
      payloadJson: Value(payloadJson),
      localAvailable: Value(localAvailable),
    );
  }

  factory CurriculumAudioData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurriculumAudioData(
      id: serializer.fromJson<String>(json['id']),
      sentenceId: serializer.fromJson<String>(json['sentenceId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      localAvailable: serializer.fromJson<bool>(json['localAvailable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sentenceId': serializer.toJson<String>(sentenceId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'localAvailable': serializer.toJson<bool>(localAvailable),
    };
  }

  CurriculumAudioData copyWith({
    String? id,
    String? sentenceId,
    String? payloadJson,
    bool? localAvailable,
  }) => CurriculumAudioData(
    id: id ?? this.id,
    sentenceId: sentenceId ?? this.sentenceId,
    payloadJson: payloadJson ?? this.payloadJson,
    localAvailable: localAvailable ?? this.localAvailable,
  );
  CurriculumAudioData copyWithCompanion(CurriculumAudioCompanion data) {
    return CurriculumAudioData(
      id: data.id.present ? data.id.value : this.id,
      sentenceId: data.sentenceId.present
          ? data.sentenceId.value
          : this.sentenceId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      localAvailable: data.localAvailable.present
          ? data.localAvailable.value
          : this.localAvailable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumAudioData(')
          ..write('id: $id, ')
          ..write('sentenceId: $sentenceId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('localAvailable: $localAvailable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sentenceId, payloadJson, localAvailable);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurriculumAudioData &&
          other.id == this.id &&
          other.sentenceId == this.sentenceId &&
          other.payloadJson == this.payloadJson &&
          other.localAvailable == this.localAvailable);
}

class CurriculumAudioCompanion extends UpdateCompanion<CurriculumAudioData> {
  final Value<String> id;
  final Value<String> sentenceId;
  final Value<String> payloadJson;
  final Value<bool> localAvailable;
  final Value<int> rowid;
  const CurriculumAudioCompanion({
    this.id = const Value.absent(),
    this.sentenceId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.localAvailable = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurriculumAudioCompanion.insert({
    required String id,
    required String sentenceId,
    required String payloadJson,
    required bool localAvailable,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sentenceId = Value(sentenceId),
       payloadJson = Value(payloadJson),
       localAvailable = Value(localAvailable);
  static Insertable<CurriculumAudioData> custom({
    Expression<String>? id,
    Expression<String>? sentenceId,
    Expression<String>? payloadJson,
    Expression<bool>? localAvailable,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sentenceId != null) 'sentence_id': sentenceId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (localAvailable != null) 'local_available': localAvailable,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurriculumAudioCompanion copyWith({
    Value<String>? id,
    Value<String>? sentenceId,
    Value<String>? payloadJson,
    Value<bool>? localAvailable,
    Value<int>? rowid,
  }) {
    return CurriculumAudioCompanion(
      id: id ?? this.id,
      sentenceId: sentenceId ?? this.sentenceId,
      payloadJson: payloadJson ?? this.payloadJson,
      localAvailable: localAvailable ?? this.localAvailable,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sentenceId.present) {
      map['sentence_id'] = Variable<String>(sentenceId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (localAvailable.present) {
      map['local_available'] = Variable<bool>(localAvailable.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumAudioCompanion(')
          ..write('id: $id, ')
          ..write('sentenceId: $sentenceId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('localAvailable: $localAvailable, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CurriculumQuestionsTable extends CurriculumQuestions
    with TableInfo<$CurriculumQuestionsTable, CurriculumQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurriculumQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES curriculum_words (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, wordId, position, payloadJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'curriculum_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CurriculumQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurriculumQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurriculumQuestion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $CurriculumQuestionsTable createAlias(String alias) {
    return $CurriculumQuestionsTable(attachedDatabase, alias);
  }
}

class CurriculumQuestion extends DataClass
    implements Insertable<CurriculumQuestion> {
  final String id;
  final String wordId;
  final int position;
  final String payloadJson;
  const CurriculumQuestion({
    required this.id,
    required this.wordId,
    required this.position,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['word_id'] = Variable<String>(wordId);
    map['position'] = Variable<int>(position);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  CurriculumQuestionsCompanion toCompanion(bool nullToAbsent) {
    return CurriculumQuestionsCompanion(
      id: Value(id),
      wordId: Value(wordId),
      position: Value(position),
      payloadJson: Value(payloadJson),
    );
  }

  factory CurriculumQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurriculumQuestion(
      id: serializer.fromJson<String>(json['id']),
      wordId: serializer.fromJson<String>(json['wordId']),
      position: serializer.fromJson<int>(json['position']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'wordId': serializer.toJson<String>(wordId),
      'position': serializer.toJson<int>(position),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  CurriculumQuestion copyWith({
    String? id,
    String? wordId,
    int? position,
    String? payloadJson,
  }) => CurriculumQuestion(
    id: id ?? this.id,
    wordId: wordId ?? this.wordId,
    position: position ?? this.position,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  CurriculumQuestion copyWithCompanion(CurriculumQuestionsCompanion data) {
    return CurriculumQuestion(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      position: data.position.present ? data.position.value : this.position,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumQuestion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('position: $position, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wordId, position, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurriculumQuestion &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.position == this.position &&
          other.payloadJson == this.payloadJson);
}

class CurriculumQuestionsCompanion extends UpdateCompanion<CurriculumQuestion> {
  final Value<String> id;
  final Value<String> wordId;
  final Value<int> position;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const CurriculumQuestionsCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.position = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurriculumQuestionsCompanion.insert({
    required String id,
    required String wordId,
    required int position,
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       wordId = Value(wordId),
       position = Value(position),
       payloadJson = Value(payloadJson);
  static Insertable<CurriculumQuestion> custom({
    Expression<String>? id,
    Expression<String>? wordId,
    Expression<int>? position,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (position != null) 'position': position,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurriculumQuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? wordId,
    Value<int>? position,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return CurriculumQuestionsCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      position: position ?? this.position,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('position: $position, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CurriculumInstallsTable extends CurriculumInstalls
    with TableInfo<$CurriculumInstallsTable, CurriculumInstall> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurriculumInstallsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _digestMeta = const VerificationMeta('digest');
  @override
  late final GeneratedColumn<String> digest = GeneratedColumn<String>(
    'digest',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, revision, digest];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'curriculum_installs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CurriculumInstall> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('digest')) {
      context.handle(
        _digestMeta,
        digest.isAcceptableOrUnknown(data['digest']!, _digestMeta),
      );
    } else if (isInserting) {
      context.missing(_digestMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurriculumInstall map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurriculumInstall(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      digest: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}digest'],
      )!,
    );
  }

  @override
  $CurriculumInstallsTable createAlias(String alias) {
    return $CurriculumInstallsTable(attachedDatabase, alias);
  }
}

class CurriculumInstall extends DataClass
    implements Insertable<CurriculumInstall> {
  final int id;
  final int revision;
  final String digest;
  const CurriculumInstall({
    required this.id,
    required this.revision,
    required this.digest,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['revision'] = Variable<int>(revision);
    map['digest'] = Variable<String>(digest);
    return map;
  }

  CurriculumInstallsCompanion toCompanion(bool nullToAbsent) {
    return CurriculumInstallsCompanion(
      id: Value(id),
      revision: Value(revision),
      digest: Value(digest),
    );
  }

  factory CurriculumInstall.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurriculumInstall(
      id: serializer.fromJson<int>(json['id']),
      revision: serializer.fromJson<int>(json['revision']),
      digest: serializer.fromJson<String>(json['digest']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'revision': serializer.toJson<int>(revision),
      'digest': serializer.toJson<String>(digest),
    };
  }

  CurriculumInstall copyWith({int? id, int? revision, String? digest}) =>
      CurriculumInstall(
        id: id ?? this.id,
        revision: revision ?? this.revision,
        digest: digest ?? this.digest,
      );
  CurriculumInstall copyWithCompanion(CurriculumInstallsCompanion data) {
    return CurriculumInstall(
      id: data.id.present ? data.id.value : this.id,
      revision: data.revision.present ? data.revision.value : this.revision,
      digest: data.digest.present ? data.digest.value : this.digest,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumInstall(')
          ..write('id: $id, ')
          ..write('revision: $revision, ')
          ..write('digest: $digest')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, revision, digest);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurriculumInstall &&
          other.id == this.id &&
          other.revision == this.revision &&
          other.digest == this.digest);
}

class CurriculumInstallsCompanion extends UpdateCompanion<CurriculumInstall> {
  final Value<int> id;
  final Value<int> revision;
  final Value<String> digest;
  const CurriculumInstallsCompanion({
    this.id = const Value.absent(),
    this.revision = const Value.absent(),
    this.digest = const Value.absent(),
  });
  CurriculumInstallsCompanion.insert({
    this.id = const Value.absent(),
    required int revision,
    required String digest,
  }) : revision = Value(revision),
       digest = Value(digest);
  static Insertable<CurriculumInstall> custom({
    Expression<int>? id,
    Expression<int>? revision,
    Expression<String>? digest,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revision != null) 'revision': revision,
      if (digest != null) 'digest': digest,
    });
  }

  CurriculumInstallsCompanion copyWith({
    Value<int>? id,
    Value<int>? revision,
    Value<String>? digest,
  }) {
    return CurriculumInstallsCompanion(
      id: id ?? this.id,
      revision: revision ?? this.revision,
      digest: digest ?? this.digest,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (digest.present) {
      map['digest'] = Variable<String>(digest.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurriculumInstallsCompanion(')
          ..write('id: $id, ')
          ..write('revision: $revision, ')
          ..write('digest: $digest')
          ..write(')'))
        .toString();
  }
}

class $LearningQueueTable extends LearningQueue
    with TableInfo<$LearningQueueTable, LearningQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES curriculum_words (id)',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [profileId, wordId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearningQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, wordId};
  @override
  LearningQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningQueueData(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $LearningQueueTable createAlias(String alias) {
    return $LearningQueueTable(attachedDatabase, alias);
  }
}

class LearningQueueData extends DataClass
    implements Insertable<LearningQueueData> {
  final int profileId;
  final String wordId;
  final int position;
  const LearningQueueData({
    required this.profileId,
    required this.wordId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['word_id'] = Variable<String>(wordId);
    map['position'] = Variable<int>(position);
    return map;
  }

  LearningQueueCompanion toCompanion(bool nullToAbsent) {
    return LearningQueueCompanion(
      profileId: Value(profileId),
      wordId: Value(wordId),
      position: Value(position),
    );
  }

  factory LearningQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningQueueData(
      profileId: serializer.fromJson<int>(json['profileId']),
      wordId: serializer.fromJson<String>(json['wordId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'wordId': serializer.toJson<String>(wordId),
      'position': serializer.toJson<int>(position),
    };
  }

  LearningQueueData copyWith({int? profileId, String? wordId, int? position}) =>
      LearningQueueData(
        profileId: profileId ?? this.profileId,
        wordId: wordId ?? this.wordId,
        position: position ?? this.position,
      );
  LearningQueueData copyWithCompanion(LearningQueueCompanion data) {
    return LearningQueueData(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningQueueData(')
          ..write('profileId: $profileId, ')
          ..write('wordId: $wordId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, wordId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningQueueData &&
          other.profileId == this.profileId &&
          other.wordId == this.wordId &&
          other.position == this.position);
}

class LearningQueueCompanion extends UpdateCompanion<LearningQueueData> {
  final Value<int> profileId;
  final Value<String> wordId;
  final Value<int> position;
  final Value<int> rowid;
  const LearningQueueCompanion({
    this.profileId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearningQueueCompanion.insert({
    required int profileId,
    required String wordId,
    required int position,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       wordId = Value(wordId),
       position = Value(position);
  static Insertable<LearningQueueData> custom({
    Expression<int>? profileId,
    Expression<String>? wordId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (wordId != null) 'word_id': wordId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearningQueueCompanion copyWith({
    Value<int>? profileId,
    Value<String>? wordId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return LearningQueueCompanion(
      profileId: profileId ?? this.profileId,
      wordId: wordId ?? this.wordId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearningQueueCompanion(')
          ..write('profileId: $profileId, ')
          ..write('wordId: $wordId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $AppPreferencesTable appPreferences = $AppPreferencesTable(this);
  late final $FoundationProgressTable foundationProgress =
      $FoundationProgressTable(this);
  late final $VocabularyProgressTable vocabularyProgress =
      $VocabularyProgressTable(this);
  late final $VocabularyAttemptsTable vocabularyAttempts =
      $VocabularyAttemptsTable(this);
  late final $PracticeResponsesTable practiceResponses =
      $PracticeResponsesTable(this);
  late final $MasteredWordsTable masteredWords = $MasteredWordsTable(this);
  late final $MasterWritingsTable masterWritings = $MasterWritingsTable(this);
  late final $GrammarLessonsTable grammarLessons = $GrammarLessonsTable(this);
  late final $GrammarExamplesTable grammarExamples = $GrammarExamplesTable(
    this,
  );
  late final $GrammarProgressTable grammarProgress = $GrammarProgressTable(
    this,
  );
  late final $GrammarInstallsTable grammarInstalls = $GrammarInstallsTable(
    this,
  );
  late final $ContentPacksTable contentPacks = $ContentPacksTable(this);
  late final $ContentWordsTable contentWords = $ContentWordsTable(this);
  late final $ContentExamplesTable contentExamples = $ContentExamplesTable(
    this,
  );
  late final $ContentExercisesTable contentExercises = $ContentExercisesTable(
    this,
  );
  late final $CurriculumWordsTable curriculumWords = $CurriculumWordsTable(
    this,
  );
  late final $CurriculumSentencesTable curriculumSentences =
      $CurriculumSentencesTable(this);
  late final $CurriculumExamplesTable curriculumExamples =
      $CurriculumExamplesTable(this);
  late final $CurriculumAudioTable curriculumAudio = $CurriculumAudioTable(
    this,
  );
  late final $CurriculumQuestionsTable curriculumQuestions =
      $CurriculumQuestionsTable(this);
  late final $CurriculumInstallsTable curriculumInstalls =
      $CurriculumInstallsTable(this);
  late final $LearningQueueTable learningQueue = $LearningQueueTable(this);
  late final Index curriculumAudioSentence = Index(
    'curriculum_audio_sentence',
    'CREATE INDEX curriculum_audio_sentence ON curriculum_audio (sentence_id)',
  );
  late final Index curriculumQuestionWord = Index(
    'curriculum_question_word',
    'CREATE INDEX curriculum_question_word ON curriculum_questions (word_id, position)',
  );
  late final Index queueProfilePosition = Index(
    'queue_profile_position',
    'CREATE INDEX queue_profile_position ON learning_queue (profile_id, position, word_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    appPreferences,
    foundationProgress,
    vocabularyProgress,
    vocabularyAttempts,
    practiceResponses,
    masteredWords,
    masterWritings,
    grammarLessons,
    grammarExamples,
    grammarProgress,
    grammarInstalls,
    contentPacks,
    contentWords,
    contentExamples,
    contentExercises,
    curriculumWords,
    curriculumSentences,
    curriculumExamples,
    curriculumAudio,
    curriculumQuestions,
    curriculumInstalls,
    learningQueue,
    curriculumAudioSentence,
    curriculumQuestionWord,
    queueProfilePosition,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_words',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('content_examples', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'content_words',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('content_exercises', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  required String name,
  required String level,
  required String goal,
  required int dailyMinutes,
  required bool showPinyin,
  required DateTime createdAt,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> level,
  Value<String> goal,
  Value<int> dailyMinutes,
  Value<bool> showPinyin,
  Value<DateTime> createdAt,
});

final class $$ProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AppPreferencesTable, List<AppPreference>>
  _appPreferencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appPreferences,
    aliasName: 'profiles__id__app_preferences__selected_profile_id',
  );

  $$AppPreferencesTableProcessedTableManager get appPreferencesRefs {
    final manager = $$AppPreferencesTableTableManager(
      $_db,
      $_db.appPreferences,
    ).filter((f) => f.selectedProfileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_appPreferencesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FoundationProgressTable,
    List<FoundationProgressData>
  >
  _foundationProgressRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.foundationProgress,
        aliasName: 'profiles__id__foundation_progress__profile_id',
      );

  $$FoundationProgressTableProcessedTableManager get foundationProgressRefs {
    final manager = $$FoundationProgressTableTableManager(
      $_db,
      $_db.foundationProgress,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _foundationProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $VocabularyProgressTable,
    List<VocabularyProgressData>
  >
  _vocabularyProgressRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.vocabularyProgress,
        aliasName: 'profiles__id__vocabulary_progress__profile_id',
      );

  $$VocabularyProgressTableProcessedTableManager get vocabularyProgressRefs {
    final manager = $$VocabularyProgressTableTableManager(
      $_db,
      $_db.vocabularyProgress,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _vocabularyProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VocabularyAttemptsTable, List<VocabularyAttempt>>
  _vocabularyAttemptsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.vocabularyAttempts,
        aliasName: 'profiles__id__vocabulary_attempts__profile_id',
      );

  $$VocabularyAttemptsTableProcessedTableManager get vocabularyAttemptsRefs {
    final manager = $$VocabularyAttemptsTableTableManager(
      $_db,
      $_db.vocabularyAttempts,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _vocabularyAttemptsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PracticeResponsesTable, List<PracticeResponse>>
  _practiceResponsesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.practiceResponses,
        aliasName: 'profiles__id__practice_responses__profile_id',
      );

  $$PracticeResponsesTableProcessedTableManager get practiceResponsesRefs {
    final manager = $$PracticeResponsesTableTableManager(
      $_db,
      $_db.practiceResponses,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _practiceResponsesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MasteredWordsTable, List<MasteredWord>>
  _masteredWordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.masteredWords,
    aliasName: 'profiles__id__mastered_words__profile_id',
  );

  $$MasteredWordsTableProcessedTableManager get masteredWordsRefs {
    final manager = $$MasteredWordsTableTableManager(
      $_db,
      $_db.masteredWords,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_masteredWordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MasterWritingsTable, List<MasterWriting>>
  _masterWritingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.masterWritings,
    aliasName: 'profiles__id__master_writings__profile_id',
  );

  $$MasterWritingsTableProcessedTableManager get masterWritingsRefs {
    final manager = $$MasterWritingsTableTableManager(
      $_db,
      $_db.masterWritings,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_masterWritingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GrammarProgressTable, List<GrammarProgressData>>
  _grammarProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.grammarProgress,
    aliasName: 'profiles__id__grammar_progress__profile_id',
  );

  $$GrammarProgressTableProcessedTableManager get grammarProgressRefs {
    final manager = $$GrammarProgressTableTableManager(
      $_db,
      $_db.grammarProgress,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _grammarProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LearningQueueTable, List<LearningQueueData>>
  _learningQueueRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.learningQueue,
    aliasName: 'profiles__id__learning_queue__profile_id',
  );

  $$LearningQueueTableProcessedTableManager get learningQueueRefs {
    final manager = $$LearningQueueTableTableManager(
      $_db,
      $_db.learningQueue,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_learningQueueRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyMinutes => $composableBuilder(
    column: $table.dailyMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showPinyin => $composableBuilder(
    column: $table.showPinyin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> appPreferencesRefs(
    Expression<bool> Function($$AppPreferencesTableFilterComposer f) f,
  ) {
    final $$AppPreferencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appPreferences,
      getReferencedColumn: (t) => t.selectedProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppPreferencesTableFilterComposer(
            $db: $db,
            $table: $db.appPreferences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> foundationProgressRefs(
    Expression<bool> Function($$FoundationProgressTableFilterComposer f) f,
  ) {
    final $$FoundationProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foundationProgress,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoundationProgressTableFilterComposer(
            $db: $db,
            $table: $db.foundationProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> vocabularyProgressRefs(
    Expression<bool> Function($$VocabularyProgressTableFilterComposer f) f,
  ) {
    final $$VocabularyProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabularyProgress,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularyProgressTableFilterComposer(
            $db: $db,
            $table: $db.vocabularyProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> vocabularyAttemptsRefs(
    Expression<bool> Function($$VocabularyAttemptsTableFilterComposer f) f,
  ) {
    final $$VocabularyAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabularyAttempts,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularyAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.vocabularyAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> practiceResponsesRefs(
    Expression<bool> Function($$PracticeResponsesTableFilterComposer f) f,
  ) {
    final $$PracticeResponsesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.practiceResponses,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PracticeResponsesTableFilterComposer(
            $db: $db,
            $table: $db.practiceResponses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> masteredWordsRefs(
    Expression<bool> Function($$MasteredWordsTableFilterComposer f) f,
  ) {
    final $$MasteredWordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.masteredWords,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasteredWordsTableFilterComposer(
            $db: $db,
            $table: $db.masteredWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> masterWritingsRefs(
    Expression<bool> Function($$MasterWritingsTableFilterComposer f) f,
  ) {
    final $$MasterWritingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.masterWritings,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasterWritingsTableFilterComposer(
            $db: $db,
            $table: $db.masterWritings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> grammarProgressRefs(
    Expression<bool> Function($$GrammarProgressTableFilterComposer f) f,
  ) {
    final $$GrammarProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grammarProgress,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarProgressTableFilterComposer(
            $db: $db,
            $table: $db.grammarProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> learningQueueRefs(
    Expression<bool> Function($$LearningQueueTableFilterComposer f) f,
  ) {
    final $$LearningQueueTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learningQueue,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearningQueueTableFilterComposer(
            $db: $db,
            $table: $db.learningQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyMinutes => $composableBuilder(
    column: $table.dailyMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showPinyin => $composableBuilder(
    column: $table.showPinyin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<int> get dailyMinutes => $composableBuilder(
    column: $table.dailyMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showPinyin => $composableBuilder(
    column: $table.showPinyin,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> appPreferencesRefs<T extends Object>(
    Expression<T> Function($$AppPreferencesTableAnnotationComposer a) f,
  ) {
    final $$AppPreferencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appPreferences,
      getReferencedColumn: (t) => t.selectedProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppPreferencesTableAnnotationComposer(
            $db: $db,
            $table: $db.appPreferences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> foundationProgressRefs<T extends Object>(
    Expression<T> Function($$FoundationProgressTableAnnotationComposer a) f,
  ) {
    final $$FoundationProgressTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.foundationProgress,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FoundationProgressTableAnnotationComposer(
                $db: $db,
                $table: $db.foundationProgress,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> vocabularyProgressRefs<T extends Object>(
    Expression<T> Function($$VocabularyProgressTableAnnotationComposer a) f,
  ) {
    final $$VocabularyProgressTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.vocabularyProgress,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VocabularyProgressTableAnnotationComposer(
                $db: $db,
                $table: $db.vocabularyProgress,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> vocabularyAttemptsRefs<T extends Object>(
    Expression<T> Function($$VocabularyAttemptsTableAnnotationComposer a) f,
  ) {
    final $$VocabularyAttemptsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.vocabularyAttempts,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$VocabularyAttemptsTableAnnotationComposer(
                $db: $db,
                $table: $db.vocabularyAttempts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> practiceResponsesRefs<T extends Object>(
    Expression<T> Function($$PracticeResponsesTableAnnotationComposer a) f,
  ) {
    final $$PracticeResponsesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.practiceResponses,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PracticeResponsesTableAnnotationComposer(
                $db: $db,
                $table: $db.practiceResponses,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> masteredWordsRefs<T extends Object>(
    Expression<T> Function($$MasteredWordsTableAnnotationComposer a) f,
  ) {
    final $$MasteredWordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.masteredWords,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasteredWordsTableAnnotationComposer(
            $db: $db,
            $table: $db.masteredWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> masterWritingsRefs<T extends Object>(
    Expression<T> Function($$MasterWritingsTableAnnotationComposer a) f,
  ) {
    final $$MasterWritingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.masterWritings,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MasterWritingsTableAnnotationComposer(
            $db: $db,
            $table: $db.masterWritings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> grammarProgressRefs<T extends Object>(
    Expression<T> Function($$GrammarProgressTableAnnotationComposer a) f,
  ) {
    final $$GrammarProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grammarProgress,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.grammarProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> learningQueueRefs<T extends Object>(
    Expression<T> Function($$LearningQueueTableAnnotationComposer a) f,
  ) {
    final $$LearningQueueTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learningQueue,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearningQueueTableAnnotationComposer(
            $db: $db,
            $table: $db.learningQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (ProfileRow, $$ProfilesTableReferences),
          ProfileRow,
          PrefetchHooks Function({
            bool appPreferencesRefs,
            bool foundationProgressRefs,
            bool vocabularyProgressRefs,
            bool vocabularyAttemptsRefs,
            bool practiceResponsesRefs,
            bool masteredWordsRefs,
            bool masterWritingsRefs,
            bool grammarProgressRefs,
            bool learningQueueRefs,
          })
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> goal = const Value.absent(),
                Value<int> dailyMinutes = const Value.absent(),
                Value<bool> showPinyin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                level: level,
                goal: goal,
                dailyMinutes: dailyMinutes,
                showPinyin: showPinyin,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String level,
                required String goal,
                required int dailyMinutes,
                required bool showPinyin,
                required DateTime createdAt,
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                level: level,
                goal: goal,
                dailyMinutes: dailyMinutes,
                showPinyin: showPinyin,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, ProfileRow>(table),
                  $$ProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                appPreferencesRefs = false,
                foundationProgressRefs = false,
                vocabularyProgressRefs = false,
                vocabularyAttemptsRefs = false,
                practiceResponsesRefs = false,
                masteredWordsRefs = false,
                masterWritingsRefs = false,
                grammarProgressRefs = false,
                learningQueueRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (appPreferencesRefs) db.appPreferences,
                    if (foundationProgressRefs) db.foundationProgress,
                    if (vocabularyProgressRefs) db.vocabularyProgress,
                    if (vocabularyAttemptsRefs) db.vocabularyAttempts,
                    if (practiceResponsesRefs) db.practiceResponses,
                    if (masteredWordsRefs) db.masteredWords,
                    if (masterWritingsRefs) db.masterWritings,
                    if (grammarProgressRefs) db.grammarProgress,
                    if (learningQueueRefs) db.learningQueue,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (appPreferencesRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          AppPreference,
                          $AppPreferencesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._appPreferencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).appPreferencesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'selected_profile_id',
                          typedResults: items,
                        ),
                      if (foundationProgressRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          FoundationProgressData,
                          $FoundationProgressTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._foundationProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).foundationProgressRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (vocabularyProgressRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          VocabularyProgressData,
                          $VocabularyProgressTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._vocabularyProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).vocabularyProgressRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (vocabularyAttemptsRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          VocabularyAttempt,
                          $VocabularyAttemptsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._vocabularyAttemptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).vocabularyAttemptsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (practiceResponsesRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          PracticeResponse,
                          $PracticeResponsesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._practiceResponsesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).practiceResponsesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (masteredWordsRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          MasteredWord,
                          $MasteredWordsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._masteredWordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).masteredWordsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (masterWritingsRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          MasterWriting,
                          $MasterWritingsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._masterWritingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).masterWritingsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (grammarProgressRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          GrammarProgressData,
                          $GrammarProgressTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._grammarProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).grammarProgressRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (learningQueueRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          LearningQueueData,
                          $LearningQueueTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._learningQueueRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).learningQueueRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, $$ProfilesTableReferences),
      ProfileRow,
      PrefetchHooks Function({
        bool appPreferencesRefs,
        bool foundationProgressRefs,
        bool vocabularyProgressRefs,
        bool vocabularyAttemptsRefs,
        bool practiceResponsesRefs,
        bool masteredWordsRefs,
        bool masterWritingsRefs,
        bool grammarProgressRefs,
        bool learningQueueRefs,
      })
    >;
typedef $$AppPreferencesTableCreateCompanionBuilder =
    AppPreferencesCompanion Function({
      Value<int> id,
      required int selectedProfileId,
    });
typedef $$AppPreferencesTableUpdateCompanionBuilder =
    AppPreferencesCompanion Function({
      Value<int> id,
      Value<int> selectedProfileId,
    });

final class $$AppPreferencesTableReferences
    extends BaseReferences<_$AppDatabase, $AppPreferencesTable, AppPreference> {
  $$AppPreferencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _selectedProfileIdTable(_$AppDatabase db) => db.profiles
      .createAlias('app_preferences__selected_profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get selectedProfileId {
    final $_column = $_itemColumn<int>('selected_profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_selectedProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AppPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get selectedProfileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.selectedProfileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get selectedProfileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.selectedProfileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get selectedProfileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.selectedProfileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppPreferencesTable,
          AppPreference,
          $$AppPreferencesTableFilterComposer,
          $$AppPreferencesTableOrderingComposer,
          $$AppPreferencesTableAnnotationComposer,
          $$AppPreferencesTableCreateCompanionBuilder,
          $$AppPreferencesTableUpdateCompanionBuilder,
          (AppPreference, $$AppPreferencesTableReferences),
          AppPreference,
          PrefetchHooks Function({bool selectedProfileId})
        > {
  $$AppPreferencesTableTableManager(
    _$AppDatabase db,
    $AppPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> selectedProfileId = const Value.absent(),
              }) => AppPreferencesCompanion(
                id: id,
                selectedProfileId: selectedProfileId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int selectedProfileId,
              }) => AppPreferencesCompanion.insert(
                id: id,
                selectedProfileId: selectedProfileId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppPreferencesTable, AppPreference>(table),
                  $$AppPreferencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({selectedProfileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (selectedProfileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.selectedProfileId,
                        referencedTable: $$AppPreferencesTableReferences
                            ._selectedProfileIdTable(db),
                        referencedColumn: $$AppPreferencesTableReferences
                            ._selectedProfileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AppPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppPreferencesTable,
      AppPreference,
      $$AppPreferencesTableFilterComposer,
      $$AppPreferencesTableOrderingComposer,
      $$AppPreferencesTableAnnotationComposer,
      $$AppPreferencesTableCreateCompanionBuilder,
      $$AppPreferencesTableUpdateCompanionBuilder,
      (AppPreference, $$AppPreferencesTableReferences),
      AppPreference,
      PrefetchHooks Function({bool selectedProfileId})
    >;
typedef $$FoundationProgressTableCreateCompanionBuilder =
    FoundationProgressCompanion Function({
      Value<int> profileId,
      required int step,
      required bool completed,
    });
typedef $$FoundationProgressTableUpdateCompanionBuilder =
    FoundationProgressCompanion Function({
      Value<int> profileId,
      Value<int> step,
      Value<bool> completed,
    });

final class $$FoundationProgressTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FoundationProgressTable,
          FoundationProgressData
        > {
  $$FoundationProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('foundation_progress__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FoundationProgressTableFilterComposer
    extends Composer<_$AppDatabase, $FoundationProgressTable> {
  $$FoundationProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoundationProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $FoundationProgressTable> {
  $$FoundationProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoundationProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoundationProgressTable> {
  $$FoundationProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoundationProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoundationProgressTable,
          FoundationProgressData,
          $$FoundationProgressTableFilterComposer,
          $$FoundationProgressTableOrderingComposer,
          $$FoundationProgressTableAnnotationComposer,
          $$FoundationProgressTableCreateCompanionBuilder,
          $$FoundationProgressTableUpdateCompanionBuilder,
          (FoundationProgressData, $$FoundationProgressTableReferences),
          FoundationProgressData,
          PrefetchHooks Function({bool profileId})
        > {
  $$FoundationProgressTableTableManager(
    _$AppDatabase db,
    $FoundationProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoundationProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoundationProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoundationProgressTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<int> step = const Value.absent(),
                Value<bool> completed = const Value.absent(),
              }) => FoundationProgressCompanion(
                profileId: profileId,
                step: step,
                completed: completed,
              ),
          createCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                required int step,
                required bool completed,
              }) => FoundationProgressCompanion.insert(
                profileId: profileId,
                step: step,
                completed: completed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoundationProgressTable, FoundationProgressData>(
                    table,
                  ),
                  $$FoundationProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$FoundationProgressTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$FoundationProgressTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FoundationProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoundationProgressTable,
      FoundationProgressData,
      $$FoundationProgressTableFilterComposer,
      $$FoundationProgressTableOrderingComposer,
      $$FoundationProgressTableAnnotationComposer,
      $$FoundationProgressTableCreateCompanionBuilder,
      $$FoundationProgressTableUpdateCompanionBuilder,
      (FoundationProgressData, $$FoundationProgressTableReferences),
      FoundationProgressData,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$VocabularyProgressTableCreateCompanionBuilder =
    VocabularyProgressCompanion Function({
      required int profileId,
      required String wordId,
      required String stage,
      required int dueAtMs,
      required int version,
      required int successfulReviews,
      Value<int> rowid,
    });
typedef $$VocabularyProgressTableUpdateCompanionBuilder =
    VocabularyProgressCompanion Function({
      Value<int> profileId,
      Value<String> wordId,
      Value<String> stage,
      Value<int> dueAtMs,
      Value<int> version,
      Value<int> successfulReviews,
      Value<int> rowid,
    });

final class $$VocabularyProgressTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $VocabularyProgressTable,
          VocabularyProgressData
        > {
  $$VocabularyProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('vocabulary_progress__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VocabularyProgressTableFilterComposer
    extends Composer<_$AppDatabase, $VocabularyProgressTable> {
  $$VocabularyProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueAtMs => $composableBuilder(
    column: $table.dueAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get successfulReviews => $composableBuilder(
    column: $table.successfulReviews,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabularyProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabularyProgressTable> {
  $$VocabularyProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueAtMs => $composableBuilder(
    column: $table.dueAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get successfulReviews => $composableBuilder(
    column: $table.successfulReviews,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabularyProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabularyProgressTable> {
  $$VocabularyProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<int> get dueAtMs =>
      $composableBuilder(column: $table.dueAtMs, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get successfulReviews => $composableBuilder(
    column: $table.successfulReviews,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabularyProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VocabularyProgressTable,
          VocabularyProgressData,
          $$VocabularyProgressTableFilterComposer,
          $$VocabularyProgressTableOrderingComposer,
          $$VocabularyProgressTableAnnotationComposer,
          $$VocabularyProgressTableCreateCompanionBuilder,
          $$VocabularyProgressTableUpdateCompanionBuilder,
          (VocabularyProgressData, $$VocabularyProgressTableReferences),
          VocabularyProgressData,
          PrefetchHooks Function({bool profileId})
        > {
  $$VocabularyProgressTableTableManager(
    _$AppDatabase db,
    $VocabularyProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabularyProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabularyProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabularyProgressTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<String> stage = const Value.absent(),
                Value<int> dueAtMs = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> successfulReviews = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VocabularyProgressCompanion(
                profileId: profileId,
                wordId: wordId,
                stage: stage,
                dueAtMs: dueAtMs,
                version: version,
                successfulReviews: successfulReviews,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required String wordId,
                required String stage,
                required int dueAtMs,
                required int version,
                required int successfulReviews,
                Value<int> rowid = const Value.absent(),
              }) => VocabularyProgressCompanion.insert(
                profileId: profileId,
                wordId: wordId,
                stage: stage,
                dueAtMs: dueAtMs,
                version: version,
                successfulReviews: successfulReviews,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VocabularyProgressTable, VocabularyProgressData>(
                    table,
                  ),
                  $$VocabularyProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$VocabularyProgressTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$VocabularyProgressTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VocabularyProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VocabularyProgressTable,
      VocabularyProgressData,
      $$VocabularyProgressTableFilterComposer,
      $$VocabularyProgressTableOrderingComposer,
      $$VocabularyProgressTableAnnotationComposer,
      $$VocabularyProgressTableCreateCompanionBuilder,
      $$VocabularyProgressTableUpdateCompanionBuilder,
      (VocabularyProgressData, $$VocabularyProgressTableReferences),
      VocabularyProgressData,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$VocabularyAttemptsTableCreateCompanionBuilder =
    VocabularyAttemptsCompanion Function({
      required String eventId,
      required int profileId,
      required String wordId,
      required String packId,
      required int contentRevision,
      required int versionBefore,
      required bool isReview,
      required String answersJson,
      required String questionsJson,
      required bool passed,
      required int answeredAtMs,
      required int nextDueAtMs,
      required String nextStage,
      Value<int> rowid,
    });
typedef $$VocabularyAttemptsTableUpdateCompanionBuilder =
    VocabularyAttemptsCompanion Function({
      Value<String> eventId,
      Value<int> profileId,
      Value<String> wordId,
      Value<String> packId,
      Value<int> contentRevision,
      Value<int> versionBefore,
      Value<bool> isReview,
      Value<String> answersJson,
      Value<String> questionsJson,
      Value<bool> passed,
      Value<int> answeredAtMs,
      Value<int> nextDueAtMs,
      Value<String> nextStage,
      Value<int> rowid,
    });

final class $$VocabularyAttemptsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $VocabularyAttemptsTable,
          VocabularyAttempt
        > {
  $$VocabularyAttemptsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('vocabulary_attempts__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VocabularyAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $VocabularyAttemptsTable> {
  $$VocabularyAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get versionBefore => $composableBuilder(
    column: $table.versionBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isReview => $composableBuilder(
    column: $table.isReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionsJson => $composableBuilder(
    column: $table.questionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get passed => $composableBuilder(
    column: $table.passed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get answeredAtMs => $composableBuilder(
    column: $table.answeredAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextDueAtMs => $composableBuilder(
    column: $table.nextDueAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextStage => $composableBuilder(
    column: $table.nextStage,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabularyAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabularyAttemptsTable> {
  $$VocabularyAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versionBefore => $composableBuilder(
    column: $table.versionBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isReview => $composableBuilder(
    column: $table.isReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionsJson => $composableBuilder(
    column: $table.questionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get passed => $composableBuilder(
    column: $table.passed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get answeredAtMs => $composableBuilder(
    column: $table.answeredAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextDueAtMs => $composableBuilder(
    column: $table.nextDueAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextStage => $composableBuilder(
    column: $table.nextStage,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabularyAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabularyAttemptsTable> {
  $$VocabularyAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<int> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get versionBefore => $composableBuilder(
    column: $table.versionBefore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isReview =>
      $composableBuilder(column: $table.isReview, builder: (column) => column);

  GeneratedColumn<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionsJson => $composableBuilder(
    column: $table.questionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get passed =>
      $composableBuilder(column: $table.passed, builder: (column) => column);

  GeneratedColumn<int> get answeredAtMs => $composableBuilder(
    column: $table.answeredAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextDueAtMs => $composableBuilder(
    column: $table.nextDueAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nextStage =>
      $composableBuilder(column: $table.nextStage, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabularyAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VocabularyAttemptsTable,
          VocabularyAttempt,
          $$VocabularyAttemptsTableFilterComposer,
          $$VocabularyAttemptsTableOrderingComposer,
          $$VocabularyAttemptsTableAnnotationComposer,
          $$VocabularyAttemptsTableCreateCompanionBuilder,
          $$VocabularyAttemptsTableUpdateCompanionBuilder,
          (VocabularyAttempt, $$VocabularyAttemptsTableReferences),
          VocabularyAttempt,
          PrefetchHooks Function({bool profileId})
        > {
  $$VocabularyAttemptsTableTableManager(
    _$AppDatabase db,
    $VocabularyAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabularyAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabularyAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabularyAttemptsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<int> contentRevision = const Value.absent(),
                Value<int> versionBefore = const Value.absent(),
                Value<bool> isReview = const Value.absent(),
                Value<String> answersJson = const Value.absent(),
                Value<String> questionsJson = const Value.absent(),
                Value<bool> passed = const Value.absent(),
                Value<int> answeredAtMs = const Value.absent(),
                Value<int> nextDueAtMs = const Value.absent(),
                Value<String> nextStage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VocabularyAttemptsCompanion(
                eventId: eventId,
                profileId: profileId,
                wordId: wordId,
                packId: packId,
                contentRevision: contentRevision,
                versionBefore: versionBefore,
                isReview: isReview,
                answersJson: answersJson,
                questionsJson: questionsJson,
                passed: passed,
                answeredAtMs: answeredAtMs,
                nextDueAtMs: nextDueAtMs,
                nextStage: nextStage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                required int profileId,
                required String wordId,
                required String packId,
                required int contentRevision,
                required int versionBefore,
                required bool isReview,
                required String answersJson,
                required String questionsJson,
                required bool passed,
                required int answeredAtMs,
                required int nextDueAtMs,
                required String nextStage,
                Value<int> rowid = const Value.absent(),
              }) => VocabularyAttemptsCompanion.insert(
                eventId: eventId,
                profileId: profileId,
                wordId: wordId,
                packId: packId,
                contentRevision: contentRevision,
                versionBefore: versionBefore,
                isReview: isReview,
                answersJson: answersJson,
                questionsJson: questionsJson,
                passed: passed,
                answeredAtMs: answeredAtMs,
                nextDueAtMs: nextDueAtMs,
                nextStage: nextStage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VocabularyAttemptsTable, VocabularyAttempt>(
                    table,
                  ),
                  $$VocabularyAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$VocabularyAttemptsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$VocabularyAttemptsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VocabularyAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VocabularyAttemptsTable,
      VocabularyAttempt,
      $$VocabularyAttemptsTableFilterComposer,
      $$VocabularyAttemptsTableOrderingComposer,
      $$VocabularyAttemptsTableAnnotationComposer,
      $$VocabularyAttemptsTableCreateCompanionBuilder,
      $$VocabularyAttemptsTableUpdateCompanionBuilder,
      (VocabularyAttempt, $$VocabularyAttemptsTableReferences),
      VocabularyAttempt,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$PracticeResponsesTableCreateCompanionBuilder =
    PracticeResponsesCompanion Function({
      required String id,
      required int profileId,
      required String wordId,
      required String questionId,
      required bool correct,
      required int answeredAtMs,
      Value<int> rowid,
    });
typedef $$PracticeResponsesTableUpdateCompanionBuilder =
    PracticeResponsesCompanion Function({
      Value<String> id,
      Value<int> profileId,
      Value<String> wordId,
      Value<String> questionId,
      Value<bool> correct,
      Value<int> answeredAtMs,
      Value<int> rowid,
    });

final class $$PracticeResponsesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PracticeResponsesTable,
          PracticeResponse
        > {
  $$PracticeResponsesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('practice_responses__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PracticeResponsesTableFilterComposer
    extends Composer<_$AppDatabase, $PracticeResponsesTable> {
  $$PracticeResponsesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get answeredAtMs => $composableBuilder(
    column: $table.answeredAtMs,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PracticeResponsesTableOrderingComposer
    extends Composer<_$AppDatabase, $PracticeResponsesTable> {
  $$PracticeResponsesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get answeredAtMs => $composableBuilder(
    column: $table.answeredAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PracticeResponsesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PracticeResponsesTable> {
  $$PracticeResponsesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get answeredAtMs => $composableBuilder(
    column: $table.answeredAtMs,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PracticeResponsesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PracticeResponsesTable,
          PracticeResponse,
          $$PracticeResponsesTableFilterComposer,
          $$PracticeResponsesTableOrderingComposer,
          $$PracticeResponsesTableAnnotationComposer,
          $$PracticeResponsesTableCreateCompanionBuilder,
          $$PracticeResponsesTableUpdateCompanionBuilder,
          (PracticeResponse, $$PracticeResponsesTableReferences),
          PracticeResponse,
          PrefetchHooks Function({bool profileId})
        > {
  $$PracticeResponsesTableTableManager(
    _$AppDatabase db,
    $PracticeResponsesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PracticeResponsesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PracticeResponsesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PracticeResponsesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<bool> correct = const Value.absent(),
                Value<int> answeredAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PracticeResponsesCompanion(
                id: id,
                profileId: profileId,
                wordId: wordId,
                questionId: questionId,
                correct: correct,
                answeredAtMs: answeredAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int profileId,
                required String wordId,
                required String questionId,
                required bool correct,
                required int answeredAtMs,
                Value<int> rowid = const Value.absent(),
              }) => PracticeResponsesCompanion.insert(
                id: id,
                profileId: profileId,
                wordId: wordId,
                questionId: questionId,
                correct: correct,
                answeredAtMs: answeredAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PracticeResponsesTable, PracticeResponse>(table),
                  $$PracticeResponsesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$PracticeResponsesTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$PracticeResponsesTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PracticeResponsesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PracticeResponsesTable,
      PracticeResponse,
      $$PracticeResponsesTableFilterComposer,
      $$PracticeResponsesTableOrderingComposer,
      $$PracticeResponsesTableAnnotationComposer,
      $$PracticeResponsesTableCreateCompanionBuilder,
      $$PracticeResponsesTableUpdateCompanionBuilder,
      (PracticeResponse, $$PracticeResponsesTableReferences),
      PracticeResponse,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$MasteredWordsTableCreateCompanionBuilder =
    MasteredWordsCompanion Function({
      required int profileId,
      required String wordId,
      required int masteredAtMs,
      Value<int> rowid,
    });
typedef $$MasteredWordsTableUpdateCompanionBuilder =
    MasteredWordsCompanion Function({
      Value<int> profileId,
      Value<String> wordId,
      Value<int> masteredAtMs,
      Value<int> rowid,
    });

final class $$MasteredWordsTableReferences
    extends BaseReferences<_$AppDatabase, $MasteredWordsTable, MasteredWord> {
  $$MasteredWordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('mastered_words__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MasteredWordsTableFilterComposer
    extends Composer<_$AppDatabase, $MasteredWordsTable> {
  $$MasteredWordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get masteredAtMs => $composableBuilder(
    column: $table.masteredAtMs,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasteredWordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MasteredWordsTable> {
  $$MasteredWordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get masteredAtMs => $composableBuilder(
    column: $table.masteredAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasteredWordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MasteredWordsTable> {
  $$MasteredWordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<int> get masteredAtMs => $composableBuilder(
    column: $table.masteredAtMs,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasteredWordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MasteredWordsTable,
          MasteredWord,
          $$MasteredWordsTableFilterComposer,
          $$MasteredWordsTableOrderingComposer,
          $$MasteredWordsTableAnnotationComposer,
          $$MasteredWordsTableCreateCompanionBuilder,
          $$MasteredWordsTableUpdateCompanionBuilder,
          (MasteredWord, $$MasteredWordsTableReferences),
          MasteredWord,
          PrefetchHooks Function({bool profileId})
        > {
  $$MasteredWordsTableTableManager(_$AppDatabase db, $MasteredWordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MasteredWordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MasteredWordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MasteredWordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<int> masteredAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MasteredWordsCompanion(
                profileId: profileId,
                wordId: wordId,
                masteredAtMs: masteredAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required String wordId,
                required int masteredAtMs,
                Value<int> rowid = const Value.absent(),
              }) => MasteredWordsCompanion.insert(
                profileId: profileId,
                wordId: wordId,
                masteredAtMs: masteredAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MasteredWordsTable, MasteredWord>(table),
                  $$MasteredWordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$MasteredWordsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$MasteredWordsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MasteredWordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MasteredWordsTable,
      MasteredWord,
      $$MasteredWordsTableFilterComposer,
      $$MasteredWordsTableOrderingComposer,
      $$MasteredWordsTableAnnotationComposer,
      $$MasteredWordsTableCreateCompanionBuilder,
      $$MasteredWordsTableUpdateCompanionBuilder,
      (MasteredWord, $$MasteredWordsTableReferences),
      MasteredWord,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$MasterWritingsTableCreateCompanionBuilder =
    MasterWritingsCompanion Function({
      required String id,
      required int profileId,
      required String wordId,
      required String prompt,
      required String sentence,
      required int writtenAtMs,
      Value<int> rowid,
    });
typedef $$MasterWritingsTableUpdateCompanionBuilder =
    MasterWritingsCompanion Function({
      Value<String> id,
      Value<int> profileId,
      Value<String> wordId,
      Value<String> prompt,
      Value<String> sentence,
      Value<int> writtenAtMs,
      Value<int> rowid,
    });

final class $$MasterWritingsTableReferences
    extends BaseReferences<_$AppDatabase, $MasterWritingsTable, MasterWriting> {
  $$MasterWritingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('master_writings__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MasterWritingsTableFilterComposer
    extends Composer<_$AppDatabase, $MasterWritingsTable> {
  $$MasterWritingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get writtenAtMs => $composableBuilder(
    column: $table.writtenAtMs,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasterWritingsTableOrderingComposer
    extends Composer<_$AppDatabase, $MasterWritingsTable> {
  $$MasterWritingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get writtenAtMs => $composableBuilder(
    column: $table.writtenAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasterWritingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MasterWritingsTable> {
  $$MasterWritingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get sentence =>
      $composableBuilder(column: $table.sentence, builder: (column) => column);

  GeneratedColumn<int> get writtenAtMs => $composableBuilder(
    column: $table.writtenAtMs,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MasterWritingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MasterWritingsTable,
          MasterWriting,
          $$MasterWritingsTableFilterComposer,
          $$MasterWritingsTableOrderingComposer,
          $$MasterWritingsTableAnnotationComposer,
          $$MasterWritingsTableCreateCompanionBuilder,
          $$MasterWritingsTableUpdateCompanionBuilder,
          (MasterWriting, $$MasterWritingsTableReferences),
          MasterWriting,
          PrefetchHooks Function({bool profileId})
        > {
  $$MasterWritingsTableTableManager(
    _$AppDatabase db,
    $MasterWritingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MasterWritingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MasterWritingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MasterWritingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<String> prompt = const Value.absent(),
                Value<String> sentence = const Value.absent(),
                Value<int> writtenAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MasterWritingsCompanion(
                id: id,
                profileId: profileId,
                wordId: wordId,
                prompt: prompt,
                sentence: sentence,
                writtenAtMs: writtenAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int profileId,
                required String wordId,
                required String prompt,
                required String sentence,
                required int writtenAtMs,
                Value<int> rowid = const Value.absent(),
              }) => MasterWritingsCompanion.insert(
                id: id,
                profileId: profileId,
                wordId: wordId,
                prompt: prompt,
                sentence: sentence,
                writtenAtMs: writtenAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MasterWritingsTable, MasterWriting>(table),
                  $$MasterWritingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$MasterWritingsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$MasterWritingsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MasterWritingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MasterWritingsTable,
      MasterWriting,
      $$MasterWritingsTableFilterComposer,
      $$MasterWritingsTableOrderingComposer,
      $$MasterWritingsTableAnnotationComposer,
      $$MasterWritingsTableCreateCompanionBuilder,
      $$MasterWritingsTableUpdateCompanionBuilder,
      (MasterWriting, $$MasterWritingsTableReferences),
      MasterWriting,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$GrammarLessonsTableCreateCompanionBuilder =
    GrammarLessonsCompanion Function({
      required String id,
      required int position,
      required int level,
      required String title,
      required String category,
      required String pattern,
      required String explanation,
      Value<String?> allsetId,
      Value<String?> allsetTitle,
      Value<String?> allsetNote,
      Value<int> rowid,
    });
typedef $$GrammarLessonsTableUpdateCompanionBuilder =
    GrammarLessonsCompanion Function({
      Value<String> id,
      Value<int> position,
      Value<int> level,
      Value<String> title,
      Value<String> category,
      Value<String> pattern,
      Value<String> explanation,
      Value<String?> allsetId,
      Value<String?> allsetTitle,
      Value<String?> allsetNote,
      Value<int> rowid,
    });

final class $$GrammarLessonsTableReferences
    extends
        BaseReferences<_$AppDatabase, $GrammarLessonsTable, GrammarLessonRow> {
  $$GrammarLessonsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$GrammarExamplesTable, List<GrammarExample>>
  _grammarExamplesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.grammarExamples,
    aliasName: 'grammar_lessons__id__grammar_examples__lesson_id',
  );

  $$GrammarExamplesTableProcessedTableManager get grammarExamplesRefs {
    final manager = $$GrammarExamplesTableTableManager(
      $_db,
      $_db.grammarExamples,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _grammarExamplesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GrammarProgressTable, List<GrammarProgressData>>
  _grammarProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.grammarProgress,
    aliasName: 'grammar_lessons__id__grammar_progress__lesson_id',
  );

  $$GrammarProgressTableProcessedTableManager get grammarProgressRefs {
    final manager = $$GrammarProgressTableTableManager(
      $_db,
      $_db.grammarProgress,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _grammarProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GrammarLessonsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarLessonsTable> {
  $$GrammarLessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allsetId => $composableBuilder(
    column: $table.allsetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allsetTitle => $composableBuilder(
    column: $table.allsetTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allsetNote => $composableBuilder(
    column: $table.allsetNote,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> grammarExamplesRefs(
    Expression<bool> Function($$GrammarExamplesTableFilterComposer f) f,
  ) {
    final $$GrammarExamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grammarExamples,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarExamplesTableFilterComposer(
            $db: $db,
            $table: $db.grammarExamples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> grammarProgressRefs(
    Expression<bool> Function($$GrammarProgressTableFilterComposer f) f,
  ) {
    final $$GrammarProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grammarProgress,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarProgressTableFilterComposer(
            $db: $db,
            $table: $db.grammarProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GrammarLessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarLessonsTable> {
  $$GrammarLessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allsetId => $composableBuilder(
    column: $table.allsetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allsetTitle => $composableBuilder(
    column: $table.allsetTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allsetNote => $composableBuilder(
    column: $table.allsetNote,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GrammarLessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarLessonsTable> {
  $$GrammarLessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allsetId =>
      $composableBuilder(column: $table.allsetId, builder: (column) => column);

  GeneratedColumn<String> get allsetTitle => $composableBuilder(
    column: $table.allsetTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allsetNote => $composableBuilder(
    column: $table.allsetNote,
    builder: (column) => column,
  );

  Expression<T> grammarExamplesRefs<T extends Object>(
    Expression<T> Function($$GrammarExamplesTableAnnotationComposer a) f,
  ) {
    final $$GrammarExamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grammarExamples,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarExamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.grammarExamples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> grammarProgressRefs<T extends Object>(
    Expression<T> Function($$GrammarProgressTableAnnotationComposer a) f,
  ) {
    final $$GrammarProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.grammarProgress,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.grammarProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GrammarLessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GrammarLessonsTable,
          GrammarLessonRow,
          $$GrammarLessonsTableFilterComposer,
          $$GrammarLessonsTableOrderingComposer,
          $$GrammarLessonsTableAnnotationComposer,
          $$GrammarLessonsTableCreateCompanionBuilder,
          $$GrammarLessonsTableUpdateCompanionBuilder,
          (GrammarLessonRow, $$GrammarLessonsTableReferences),
          GrammarLessonRow,
          PrefetchHooks Function({
            bool grammarExamplesRefs,
            bool grammarProgressRefs,
          })
        > {
  $$GrammarLessonsTableTableManager(
    _$AppDatabase db,
    $GrammarLessonsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarLessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarLessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarLessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<String?> allsetId = const Value.absent(),
                Value<String?> allsetTitle = const Value.absent(),
                Value<String?> allsetNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GrammarLessonsCompanion(
                id: id,
                position: position,
                level: level,
                title: title,
                category: category,
                pattern: pattern,
                explanation: explanation,
                allsetId: allsetId,
                allsetTitle: allsetTitle,
                allsetNote: allsetNote,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int position,
                required int level,
                required String title,
                required String category,
                required String pattern,
                required String explanation,
                Value<String?> allsetId = const Value.absent(),
                Value<String?> allsetTitle = const Value.absent(),
                Value<String?> allsetNote = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GrammarLessonsCompanion.insert(
                id: id,
                position: position,
                level: level,
                title: title,
                category: category,
                pattern: pattern,
                explanation: explanation,
                allsetId: allsetId,
                allsetTitle: allsetTitle,
                allsetNote: allsetNote,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GrammarLessonsTable, GrammarLessonRow>(table),
                  $$GrammarLessonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({grammarExamplesRefs = false, grammarProgressRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (grammarExamplesRefs) db.grammarExamples,
                    if (grammarProgressRefs) db.grammarProgress,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (grammarExamplesRefs)
                        await $_getPrefetchedDataByColumns<
                          GrammarLessonRow,
                          $GrammarLessonsTable,
                          GrammarExample,
                          $GrammarExamplesTable
                        >(
                          currentTable: table,
                          referencedTable: $$GrammarLessonsTableReferences
                              ._grammarExamplesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GrammarLessonsTableReferences(
                                db,
                                table,
                                p0,
                              ).grammarExamplesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'lesson_id',
                          typedResults: items,
                        ),
                      if (grammarProgressRefs)
                        await $_getPrefetchedDataByColumns<
                          GrammarLessonRow,
                          $GrammarLessonsTable,
                          GrammarProgressData,
                          $GrammarProgressTable
                        >(
                          currentTable: table,
                          referencedTable: $$GrammarLessonsTableReferences
                              ._grammarProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GrammarLessonsTableReferences(
                                db,
                                table,
                                p0,
                              ).grammarProgressRefs,
                          currentColumn: 'id',
                          referencedColumn: 'lesson_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GrammarLessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GrammarLessonsTable,
      GrammarLessonRow,
      $$GrammarLessonsTableFilterComposer,
      $$GrammarLessonsTableOrderingComposer,
      $$GrammarLessonsTableAnnotationComposer,
      $$GrammarLessonsTableCreateCompanionBuilder,
      $$GrammarLessonsTableUpdateCompanionBuilder,
      (GrammarLessonRow, $$GrammarLessonsTableReferences),
      GrammarLessonRow,
      PrefetchHooks Function({
        bool grammarExamplesRefs,
        bool grammarProgressRefs,
      })
    >;
typedef $$GrammarExamplesTableCreateCompanionBuilder =
    GrammarExamplesCompanion Function({
      required String lessonId,
      required int position,
      required String chinese,
      required String pinyin,
      required String english,
      required String source,
      Value<int> rowid,
    });
typedef $$GrammarExamplesTableUpdateCompanionBuilder =
    GrammarExamplesCompanion Function({
      Value<String> lessonId,
      Value<int> position,
      Value<String> chinese,
      Value<String> pinyin,
      Value<String> english,
      Value<String> source,
      Value<int> rowid,
    });

final class $$GrammarExamplesTableReferences
    extends
        BaseReferences<_$AppDatabase, $GrammarExamplesTable, GrammarExample> {
  $$GrammarExamplesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GrammarLessonsTable _lessonIdTable(_$AppDatabase db) => db
      .grammarLessons
      .createAlias('grammar_examples__lesson_id__grammar_lessons__id');

  $$GrammarLessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<String>('lesson_id')!;

    final manager = $$GrammarLessonsTableTableManager(
      $_db,
      $_db.grammarLessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GrammarExamplesTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarExamplesTable> {
  $$GrammarExamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chinese => $composableBuilder(
    column: $table.chinese,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinyin => $composableBuilder(
    column: $table.pinyin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get english => $composableBuilder(
    column: $table.english,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  $$GrammarLessonsTableFilterComposer get lessonId {
    final $$GrammarLessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.grammarLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarLessonsTableFilterComposer(
            $db: $db,
            $table: $db.grammarLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrammarExamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarExamplesTable> {
  $$GrammarExamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chinese => $composableBuilder(
    column: $table.chinese,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinyin => $composableBuilder(
    column: $table.pinyin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get english => $composableBuilder(
    column: $table.english,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  $$GrammarLessonsTableOrderingComposer get lessonId {
    final $$GrammarLessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.grammarLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarLessonsTableOrderingComposer(
            $db: $db,
            $table: $db.grammarLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrammarExamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarExamplesTable> {
  $$GrammarExamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get chinese =>
      $composableBuilder(column: $table.chinese, builder: (column) => column);

  GeneratedColumn<String> get pinyin =>
      $composableBuilder(column: $table.pinyin, builder: (column) => column);

  GeneratedColumn<String> get english =>
      $composableBuilder(column: $table.english, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  $$GrammarLessonsTableAnnotationComposer get lessonId {
    final $$GrammarLessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.grammarLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarLessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.grammarLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrammarExamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GrammarExamplesTable,
          GrammarExample,
          $$GrammarExamplesTableFilterComposer,
          $$GrammarExamplesTableOrderingComposer,
          $$GrammarExamplesTableAnnotationComposer,
          $$GrammarExamplesTableCreateCompanionBuilder,
          $$GrammarExamplesTableUpdateCompanionBuilder,
          (GrammarExample, $$GrammarExamplesTableReferences),
          GrammarExample,
          PrefetchHooks Function({bool lessonId})
        > {
  $$GrammarExamplesTableTableManager(
    _$AppDatabase db,
    $GrammarExamplesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarExamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarExamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarExamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> lessonId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> chinese = const Value.absent(),
                Value<String> pinyin = const Value.absent(),
                Value<String> english = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GrammarExamplesCompanion(
                lessonId: lessonId,
                position: position,
                chinese: chinese,
                pinyin: pinyin,
                english: english,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String lessonId,
                required int position,
                required String chinese,
                required String pinyin,
                required String english,
                required String source,
                Value<int> rowid = const Value.absent(),
              }) => GrammarExamplesCompanion.insert(
                lessonId: lessonId,
                position: position,
                chinese: chinese,
                pinyin: pinyin,
                english: english,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GrammarExamplesTable, GrammarExample>(table),
                  $$GrammarExamplesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (lessonId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.lessonId,
                        referencedTable: $$GrammarExamplesTableReferences
                            ._lessonIdTable(db),
                        referencedColumn: $$GrammarExamplesTableReferences
                            ._lessonIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GrammarExamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GrammarExamplesTable,
      GrammarExample,
      $$GrammarExamplesTableFilterComposer,
      $$GrammarExamplesTableOrderingComposer,
      $$GrammarExamplesTableAnnotationComposer,
      $$GrammarExamplesTableCreateCompanionBuilder,
      $$GrammarExamplesTableUpdateCompanionBuilder,
      (GrammarExample, $$GrammarExamplesTableReferences),
      GrammarExample,
      PrefetchHooks Function({bool lessonId})
    >;
typedef $$GrammarProgressTableCreateCompanionBuilder =
    GrammarProgressCompanion Function({
      required int profileId,
      required String lessonId,
      required int completedAtMs,
      Value<int> rowid,
    });
typedef $$GrammarProgressTableUpdateCompanionBuilder =
    GrammarProgressCompanion Function({
      Value<int> profileId,
      Value<String> lessonId,
      Value<int> completedAtMs,
      Value<int> rowid,
    });

final class $$GrammarProgressTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GrammarProgressTable,
          GrammarProgressData
        > {
  $$GrammarProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('grammar_progress__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GrammarLessonsTable _lessonIdTable(_$AppDatabase db) => db
      .grammarLessons
      .createAlias('grammar_progress__lesson_id__grammar_lessons__id');

  $$GrammarLessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<String>('lesson_id')!;

    final manager = $$GrammarLessonsTableTableManager(
      $_db,
      $_db.grammarLessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GrammarProgressTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarProgressTable> {
  $$GrammarProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GrammarLessonsTableFilterComposer get lessonId {
    final $$GrammarLessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.grammarLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarLessonsTableFilterComposer(
            $db: $db,
            $table: $db.grammarLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrammarProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarProgressTable> {
  $$GrammarProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GrammarLessonsTableOrderingComposer get lessonId {
    final $$GrammarLessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.grammarLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarLessonsTableOrderingComposer(
            $db: $db,
            $table: $db.grammarLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrammarProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarProgressTable> {
  $$GrammarProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get completedAtMs => $composableBuilder(
    column: $table.completedAtMs,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GrammarLessonsTableAnnotationComposer get lessonId {
    final $$GrammarLessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.grammarLessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarLessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.grammarLessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrammarProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GrammarProgressTable,
          GrammarProgressData,
          $$GrammarProgressTableFilterComposer,
          $$GrammarProgressTableOrderingComposer,
          $$GrammarProgressTableAnnotationComposer,
          $$GrammarProgressTableCreateCompanionBuilder,
          $$GrammarProgressTableUpdateCompanionBuilder,
          (GrammarProgressData, $$GrammarProgressTableReferences),
          GrammarProgressData,
          PrefetchHooks Function({bool profileId, bool lessonId})
        > {
  $$GrammarProgressTableTableManager(
    _$AppDatabase db,
    $GrammarProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<int> completedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GrammarProgressCompanion(
                profileId: profileId,
                lessonId: lessonId,
                completedAtMs: completedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required String lessonId,
                required int completedAtMs,
                Value<int> rowid = const Value.absent(),
              }) => GrammarProgressCompanion.insert(
                profileId: profileId,
                lessonId: lessonId,
                completedAtMs: completedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GrammarProgressTable, GrammarProgressData>(
                    table,
                  ),
                  $$GrammarProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false, lessonId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$GrammarProgressTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$GrammarProgressTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (lessonId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.lessonId,
                        referencedTable: $$GrammarProgressTableReferences
                            ._lessonIdTable(db),
                        referencedColumn: $$GrammarProgressTableReferences
                            ._lessonIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GrammarProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GrammarProgressTable,
      GrammarProgressData,
      $$GrammarProgressTableFilterComposer,
      $$GrammarProgressTableOrderingComposer,
      $$GrammarProgressTableAnnotationComposer,
      $$GrammarProgressTableCreateCompanionBuilder,
      $$GrammarProgressTableUpdateCompanionBuilder,
      (GrammarProgressData, $$GrammarProgressTableReferences),
      GrammarProgressData,
      PrefetchHooks Function({bool profileId, bool lessonId})
    >;
typedef $$GrammarInstallsTableCreateCompanionBuilder =
    GrammarInstallsCompanion Function({
      Value<int> id,
      required int revision,
      required String digest,
    });
typedef $$GrammarInstallsTableUpdateCompanionBuilder =
    GrammarInstallsCompanion Function({
      Value<int> id,
      Value<int> revision,
      Value<String> digest,
    });

class $$GrammarInstallsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarInstallsTable> {
  $$GrammarInstallsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get digest => $composableBuilder(
    column: $table.digest,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GrammarInstallsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarInstallsTable> {
  $$GrammarInstallsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get digest => $composableBuilder(
    column: $table.digest,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GrammarInstallsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarInstallsTable> {
  $$GrammarInstallsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get digest =>
      $composableBuilder(column: $table.digest, builder: (column) => column);
}

class $$GrammarInstallsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GrammarInstallsTable,
          GrammarInstall,
          $$GrammarInstallsTableFilterComposer,
          $$GrammarInstallsTableOrderingComposer,
          $$GrammarInstallsTableAnnotationComposer,
          $$GrammarInstallsTableCreateCompanionBuilder,
          $$GrammarInstallsTableUpdateCompanionBuilder,
          (
            GrammarInstall,
            BaseReferences<
              _$AppDatabase,
              $GrammarInstallsTable,
              GrammarInstall
            >,
          ),
          GrammarInstall,
          PrefetchHooks Function()
        > {
  $$GrammarInstallsTableTableManager(
    _$AppDatabase db,
    $GrammarInstallsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarInstallsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarInstallsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarInstallsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> digest = const Value.absent(),
              }) => GrammarInstallsCompanion(
                id: id,
                revision: revision,
                digest: digest,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int revision,
                required String digest,
              }) => GrammarInstallsCompanion.insert(
                id: id,
                revision: revision,
                digest: digest,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GrammarInstallsTable, GrammarInstall>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $GrammarInstallsTable,
                    GrammarInstall
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GrammarInstallsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GrammarInstallsTable,
      GrammarInstall,
      $$GrammarInstallsTableFilterComposer,
      $$GrammarInstallsTableOrderingComposer,
      $$GrammarInstallsTableAnnotationComposer,
      $$GrammarInstallsTableCreateCompanionBuilder,
      $$GrammarInstallsTableUpdateCompanionBuilder,
      (
        GrammarInstall,
        BaseReferences<_$AppDatabase, $GrammarInstallsTable, GrammarInstall>,
      ),
      GrammarInstall,
      PrefetchHooks Function()
    >;
typedef $$ContentPacksTableCreateCompanionBuilder =
    ContentPacksCompanion Function({
      required String id,
      required int revision,
      required int contentSchema,
      required String canonicalJson,
      Value<int> rowid,
    });
typedef $$ContentPacksTableUpdateCompanionBuilder =
    ContentPacksCompanion Function({
      Value<String> id,
      Value<int> revision,
      Value<int> contentSchema,
      Value<String> canonicalJson,
      Value<int> rowid,
    });

final class $$ContentPacksTableReferences
    extends BaseReferences<_$AppDatabase, $ContentPacksTable, ContentPack> {
  $$ContentPacksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ContentWordsTable, List<ContentWord>>
  _contentWordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contentWords,
    aliasName: 'content_packs__id__content_words__pack_id',
  );

  $$ContentWordsTableProcessedTableManager get contentWordsRefs {
    final manager = $$ContentWordsTableTableManager(
      $_db,
      $_db.contentWords,
    ).filter((f) => f.packId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_contentWordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ContentPacksTableFilterComposer
    extends Composer<_$AppDatabase, $ContentPacksTable> {
  $$ContentPacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentSchema => $composableBuilder(
    column: $table.contentSchema,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalJson => $composableBuilder(
    column: $table.canonicalJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> contentWordsRefs(
    Expression<bool> Function($$ContentWordsTableFilterComposer f) f,
  ) {
    final $$ContentWordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contentWords,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentWordsTableFilterComposer(
            $db: $db,
            $table: $db.contentWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContentPacksTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentPacksTable> {
  $$ContentPacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentSchema => $composableBuilder(
    column: $table.contentSchema,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalJson => $composableBuilder(
    column: $table.canonicalJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentPacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentPacksTable> {
  $$ContentPacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get contentSchema => $composableBuilder(
    column: $table.contentSchema,
    builder: (column) => column,
  );

  GeneratedColumn<String> get canonicalJson => $composableBuilder(
    column: $table.canonicalJson,
    builder: (column) => column,
  );

  Expression<T> contentWordsRefs<T extends Object>(
    Expression<T> Function($$ContentWordsTableAnnotationComposer a) f,
  ) {
    final $$ContentWordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contentWords,
      getReferencedColumn: (t) => t.packId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentWordsTableAnnotationComposer(
            $db: $db,
            $table: $db.contentWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContentPacksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentPacksTable,
          ContentPack,
          $$ContentPacksTableFilterComposer,
          $$ContentPacksTableOrderingComposer,
          $$ContentPacksTableAnnotationComposer,
          $$ContentPacksTableCreateCompanionBuilder,
          $$ContentPacksTableUpdateCompanionBuilder,
          (ContentPack, $$ContentPacksTableReferences),
          ContentPack,
          PrefetchHooks Function({bool contentWordsRefs})
        > {
  $$ContentPacksTableTableManager(_$AppDatabase db, $ContentPacksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentPacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentPacksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentPacksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> contentSchema = const Value.absent(),
                Value<String> canonicalJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentPacksCompanion(
                id: id,
                revision: revision,
                contentSchema: contentSchema,
                canonicalJson: canonicalJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int revision,
                required int contentSchema,
                required String canonicalJson,
                Value<int> rowid = const Value.absent(),
              }) => ContentPacksCompanion.insert(
                id: id,
                revision: revision,
                contentSchema: contentSchema,
                canonicalJson: canonicalJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentPacksTable, ContentPack>(table),
                  $$ContentPacksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({contentWordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (contentWordsRefs) db.contentWords],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (contentWordsRefs)
                    await $_getPrefetchedDataByColumns<
                      ContentPack,
                      $ContentPacksTable,
                      ContentWord,
                      $ContentWordsTable
                    >(
                      currentTable: table,
                      referencedTable: $$ContentPacksTableReferences
                          ._contentWordsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ContentPacksTableReferences(
                            db,
                            table,
                            p0,
                          ).contentWordsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'pack_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ContentPacksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentPacksTable,
      ContentPack,
      $$ContentPacksTableFilterComposer,
      $$ContentPacksTableOrderingComposer,
      $$ContentPacksTableAnnotationComposer,
      $$ContentPacksTableCreateCompanionBuilder,
      $$ContentPacksTableUpdateCompanionBuilder,
      (ContentPack, $$ContentPacksTableReferences),
      ContentPack,
      PrefetchHooks Function({bool contentWordsRefs})
    >;
typedef $$ContentWordsTableCreateCompanionBuilder =
    ContentWordsCompanion Function({
      required String id,
      required String packId,
      required int position,
      required String hanzi,
      required String pinyin,
      required String metadataJson,
      Value<int> rowid,
    });
typedef $$ContentWordsTableUpdateCompanionBuilder =
    ContentWordsCompanion Function({
      Value<String> id,
      Value<String> packId,
      Value<int> position,
      Value<String> hanzi,
      Value<String> pinyin,
      Value<String> metadataJson,
      Value<int> rowid,
    });

final class $$ContentWordsTableReferences
    extends BaseReferences<_$AppDatabase, $ContentWordsTable, ContentWord> {
  $$ContentWordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContentPacksTable _packIdTable(_$AppDatabase db) =>
      db.contentPacks.createAlias('content_words__pack_id__content_packs__id');

  $$ContentPacksTableProcessedTableManager get packId {
    final $_column = $_itemColumn<String>('pack_id')!;

    final manager = $$ContentPacksTableTableManager(
      $_db,
      $_db.contentPacks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_packIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ContentExamplesTable, List<ContentExample>>
  _contentExamplesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contentExamples,
    aliasName: 'content_words__id__content_examples__word_id',
  );

  $$ContentExamplesTableProcessedTableManager get contentExamplesRefs {
    final manager = $$ContentExamplesTableTableManager(
      $_db,
      $_db.contentExamples,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _contentExamplesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContentExercisesTable, List<ContentExercise>>
  _contentExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.contentExercises,
    aliasName: 'content_words__id__content_exercises__word_id',
  );

  $$ContentExercisesTableProcessedTableManager get contentExercisesRefs {
    final manager = $$ContentExercisesTableTableManager(
      $_db,
      $_db.contentExercises,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _contentExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ContentWordsTableFilterComposer
    extends Composer<_$AppDatabase, $ContentWordsTable> {
  $$ContentWordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hanzi => $composableBuilder(
    column: $table.hanzi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinyin => $composableBuilder(
    column: $table.pinyin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentPacksTableFilterComposer get packId {
    final $$ContentPacksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableFilterComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> contentExamplesRefs(
    Expression<bool> Function($$ContentExamplesTableFilterComposer f) f,
  ) {
    final $$ContentExamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contentExamples,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentExamplesTableFilterComposer(
            $db: $db,
            $table: $db.contentExamples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contentExercisesRefs(
    Expression<bool> Function($$ContentExercisesTableFilterComposer f) f,
  ) {
    final $$ContentExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contentExercises,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentExercisesTableFilterComposer(
            $db: $db,
            $table: $db.contentExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContentWordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentWordsTable> {
  $$ContentWordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hanzi => $composableBuilder(
    column: $table.hanzi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinyin => $composableBuilder(
    column: $table.pinyin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentPacksTableOrderingComposer get packId {
    final $$ContentPacksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableOrderingComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContentWordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentWordsTable> {
  $$ContentWordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get hanzi =>
      $composableBuilder(column: $table.hanzi, builder: (column) => column);

  GeneratedColumn<String> get pinyin =>
      $composableBuilder(column: $table.pinyin, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  $$ContentPacksTableAnnotationComposer get packId {
    final $$ContentPacksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.packId,
      referencedTable: $db.contentPacks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentPacksTableAnnotationComposer(
            $db: $db,
            $table: $db.contentPacks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> contentExamplesRefs<T extends Object>(
    Expression<T> Function($$ContentExamplesTableAnnotationComposer a) f,
  ) {
    final $$ContentExamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contentExamples,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentExamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.contentExamples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contentExercisesRefs<T extends Object>(
    Expression<T> Function($$ContentExercisesTableAnnotationComposer a) f,
  ) {
    final $$ContentExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contentExercises,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.contentExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ContentWordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentWordsTable,
          ContentWord,
          $$ContentWordsTableFilterComposer,
          $$ContentWordsTableOrderingComposer,
          $$ContentWordsTableAnnotationComposer,
          $$ContentWordsTableCreateCompanionBuilder,
          $$ContentWordsTableUpdateCompanionBuilder,
          (ContentWord, $$ContentWordsTableReferences),
          ContentWord,
          PrefetchHooks Function({
            bool packId,
            bool contentExamplesRefs,
            bool contentExercisesRefs,
          })
        > {
  $$ContentWordsTableTableManager(_$AppDatabase db, $ContentWordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentWordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentWordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentWordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> hanzi = const Value.absent(),
                Value<String> pinyin = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentWordsCompanion(
                id: id,
                packId: packId,
                position: position,
                hanzi: hanzi,
                pinyin: pinyin,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required int position,
                required String hanzi,
                required String pinyin,
                required String metadataJson,
                Value<int> rowid = const Value.absent(),
              }) => ContentWordsCompanion.insert(
                id: id,
                packId: packId,
                position: position,
                hanzi: hanzi,
                pinyin: pinyin,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentWordsTable, ContentWord>(table),
                  $$ContentWordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                packId = false,
                contentExamplesRefs = false,
                contentExercisesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (contentExamplesRefs) db.contentExamples,
                    if (contentExercisesRefs) db.contentExercises,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (packId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.packId,
                            referencedTable: $$ContentWordsTableReferences
                                ._packIdTable(db),
                            referencedColumn: $$ContentWordsTableReferences
                                ._packIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (contentExamplesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentWord,
                          $ContentWordsTable,
                          ContentExample,
                          $ContentExamplesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentWordsTableReferences
                              ._contentExamplesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentWordsTableReferences(
                                db,
                                table,
                                p0,
                              ).contentExamplesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'word_id',
                          typedResults: items,
                        ),
                      if (contentExercisesRefs)
                        await $_getPrefetchedDataByColumns<
                          ContentWord,
                          $ContentWordsTable,
                          ContentExercise,
                          $ContentExercisesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ContentWordsTableReferences
                              ._contentExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ContentWordsTableReferences(
                                db,
                                table,
                                p0,
                              ).contentExercisesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'word_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ContentWordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentWordsTable,
      ContentWord,
      $$ContentWordsTableFilterComposer,
      $$ContentWordsTableOrderingComposer,
      $$ContentWordsTableAnnotationComposer,
      $$ContentWordsTableCreateCompanionBuilder,
      $$ContentWordsTableUpdateCompanionBuilder,
      (ContentWord, $$ContentWordsTableReferences),
      ContentWord,
      PrefetchHooks Function({
        bool packId,
        bool contentExamplesRefs,
        bool contentExercisesRefs,
      })
    >;
typedef $$ContentExamplesTableCreateCompanionBuilder =
    ContentExamplesCompanion Function({
      required String wordId,
      required int position,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$ContentExamplesTableUpdateCompanionBuilder =
    ContentExamplesCompanion Function({
      Value<String> wordId,
      Value<int> position,
      Value<String> payloadJson,
      Value<int> rowid,
    });

final class $$ContentExamplesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ContentExamplesTable, ContentExample> {
  $$ContentExamplesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContentWordsTable _wordIdTable(_$AppDatabase db) => db.contentWords
      .createAlias('content_examples__word_id__content_words__id');

  $$ContentWordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<String>('word_id')!;

    final manager = $$ContentWordsTableTableManager(
      $_db,
      $_db.contentWords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContentExamplesTableFilterComposer
    extends Composer<_$AppDatabase, $ContentExamplesTable> {
  $$ContentExamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentWordsTableFilterComposer get wordId {
    final $$ContentWordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.contentWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentWordsTableFilterComposer(
            $db: $db,
            $table: $db.contentWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContentExamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentExamplesTable> {
  $$ContentExamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentWordsTableOrderingComposer get wordId {
    final $$ContentWordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.contentWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentWordsTableOrderingComposer(
            $db: $db,
            $table: $db.contentWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContentExamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentExamplesTable> {
  $$ContentExamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  $$ContentWordsTableAnnotationComposer get wordId {
    final $$ContentWordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.contentWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentWordsTableAnnotationComposer(
            $db: $db,
            $table: $db.contentWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContentExamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentExamplesTable,
          ContentExample,
          $$ContentExamplesTableFilterComposer,
          $$ContentExamplesTableOrderingComposer,
          $$ContentExamplesTableAnnotationComposer,
          $$ContentExamplesTableCreateCompanionBuilder,
          $$ContentExamplesTableUpdateCompanionBuilder,
          (ContentExample, $$ContentExamplesTableReferences),
          ContentExample,
          PrefetchHooks Function({bool wordId})
        > {
  $$ContentExamplesTableTableManager(
    _$AppDatabase db,
    $ContentExamplesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentExamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentExamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentExamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> wordId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentExamplesCompanion(
                wordId: wordId,
                position: position,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String wordId,
                required int position,
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => ContentExamplesCompanion.insert(
                wordId: wordId,
                position: position,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentExamplesTable, ContentExample>(table),
                  $$ContentExamplesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wordId,
                        referencedTable: $$ContentExamplesTableReferences
                            ._wordIdTable(db),
                        referencedColumn: $$ContentExamplesTableReferences
                            ._wordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ContentExamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentExamplesTable,
      ContentExample,
      $$ContentExamplesTableFilterComposer,
      $$ContentExamplesTableOrderingComposer,
      $$ContentExamplesTableAnnotationComposer,
      $$ContentExamplesTableCreateCompanionBuilder,
      $$ContentExamplesTableUpdateCompanionBuilder,
      (ContentExample, $$ContentExamplesTableReferences),
      ContentExample,
      PrefetchHooks Function({bool wordId})
    >;
typedef $$ContentExercisesTableCreateCompanionBuilder =
    ContentExercisesCompanion Function({
      required String wordId,
      required String questionId,
      required int position,
      required String kind,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$ContentExercisesTableUpdateCompanionBuilder =
    ContentExercisesCompanion Function({
      Value<String> wordId,
      Value<String> questionId,
      Value<int> position,
      Value<String> kind,
      Value<String> payloadJson,
      Value<int> rowid,
    });

final class $$ContentExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ContentExercisesTable, ContentExercise> {
  $$ContentExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ContentWordsTable _wordIdTable(_$AppDatabase db) => db.contentWords
      .createAlias('content_exercises__word_id__content_words__id');

  $$ContentWordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<String>('word_id')!;

    final manager = $$ContentWordsTableTableManager(
      $_db,
      $_db.contentWords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContentExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ContentExercisesTable> {
  $$ContentExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  $$ContentWordsTableFilterComposer get wordId {
    final $$ContentWordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.contentWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentWordsTableFilterComposer(
            $db: $db,
            $table: $db.contentWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContentExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentExercisesTable> {
  $$ContentExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$ContentWordsTableOrderingComposer get wordId {
    final $$ContentWordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.contentWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentWordsTableOrderingComposer(
            $db: $db,
            $table: $db.contentWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContentExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentExercisesTable> {
  $$ContentExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  $$ContentWordsTableAnnotationComposer get wordId {
    final $$ContentWordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.contentWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContentWordsTableAnnotationComposer(
            $db: $db,
            $table: $db.contentWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContentExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentExercisesTable,
          ContentExercise,
          $$ContentExercisesTableFilterComposer,
          $$ContentExercisesTableOrderingComposer,
          $$ContentExercisesTableAnnotationComposer,
          $$ContentExercisesTableCreateCompanionBuilder,
          $$ContentExercisesTableUpdateCompanionBuilder,
          (ContentExercise, $$ContentExercisesTableReferences),
          ContentExercise,
          PrefetchHooks Function({bool wordId})
        > {
  $$ContentExercisesTableTableManager(
    _$AppDatabase db,
    $ContentExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> wordId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentExercisesCompanion(
                wordId: wordId,
                questionId: questionId,
                position: position,
                kind: kind,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String wordId,
                required String questionId,
                required int position,
                required String kind,
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => ContentExercisesCompanion.insert(
                wordId: wordId,
                questionId: questionId,
                position: position,
                kind: kind,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentExercisesTable, ContentExercise>(table),
                  $$ContentExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wordId,
                        referencedTable: $$ContentExercisesTableReferences
                            ._wordIdTable(db),
                        referencedColumn: $$ContentExercisesTableReferences
                            ._wordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ContentExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentExercisesTable,
      ContentExercise,
      $$ContentExercisesTableFilterComposer,
      $$ContentExercisesTableOrderingComposer,
      $$ContentExercisesTableAnnotationComposer,
      $$ContentExercisesTableCreateCompanionBuilder,
      $$ContentExercisesTableUpdateCompanionBuilder,
      (ContentExercise, $$ContentExercisesTableReferences),
      ContentExercise,
      PrefetchHooks Function({bool wordId})
    >;
typedef $$CurriculumWordsTableCreateCompanionBuilder =
    CurriculumWordsCompanion Function({
      required String id,
      required String packId,
      required int revision,
      required int contentSchema,
      required String hanzi,
      required String pinyin,
      required String meaning,
      required String searchText,
      required int defaultPosition,
      required String metadataJson,
      Value<int> rowid,
    });
typedef $$CurriculumWordsTableUpdateCompanionBuilder =
    CurriculumWordsCompanion Function({
      Value<String> id,
      Value<String> packId,
      Value<int> revision,
      Value<int> contentSchema,
      Value<String> hanzi,
      Value<String> pinyin,
      Value<String> meaning,
      Value<String> searchText,
      Value<int> defaultPosition,
      Value<String> metadataJson,
      Value<int> rowid,
    });

final class $$CurriculumWordsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CurriculumWordsTable, CurriculumWord> {
  $$CurriculumWordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CurriculumExamplesTable, List<CurriculumExample>>
  _curriculumExamplesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.curriculumExamples,
        aliasName: 'curriculum_words__id__curriculum_examples__word_id',
      );

  $$CurriculumExamplesTableProcessedTableManager get curriculumExamplesRefs {
    final manager = $$CurriculumExamplesTableTableManager(
      $_db,
      $_db.curriculumExamples,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _curriculumExamplesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CurriculumQuestionsTable,
    List<CurriculumQuestion>
  >
  _curriculumQuestionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.curriculumQuestions,
        aliasName: 'curriculum_words__id__curriculum_questions__word_id',
      );

  $$CurriculumQuestionsTableProcessedTableManager get curriculumQuestionsRefs {
    final manager = $$CurriculumQuestionsTableTableManager(
      $_db,
      $_db.curriculumQuestions,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _curriculumQuestionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LearningQueueTable, List<LearningQueueData>>
  _learningQueueRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.learningQueue,
    aliasName: 'curriculum_words__id__learning_queue__word_id',
  );

  $$LearningQueueTableProcessedTableManager get learningQueueRefs {
    final manager = $$LearningQueueTableTableManager(
      $_db,
      $_db.learningQueue,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_learningQueueRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CurriculumWordsTableFilterComposer
    extends Composer<_$AppDatabase, $CurriculumWordsTable> {
  $$CurriculumWordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentSchema => $composableBuilder(
    column: $table.contentSchema,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hanzi => $composableBuilder(
    column: $table.hanzi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinyin => $composableBuilder(
    column: $table.pinyin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultPosition => $composableBuilder(
    column: $table.defaultPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> curriculumExamplesRefs(
    Expression<bool> Function($$CurriculumExamplesTableFilterComposer f) f,
  ) {
    final $$CurriculumExamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.curriculumExamples,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumExamplesTableFilterComposer(
            $db: $db,
            $table: $db.curriculumExamples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> curriculumQuestionsRefs(
    Expression<bool> Function($$CurriculumQuestionsTableFilterComposer f) f,
  ) {
    final $$CurriculumQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.curriculumQuestions,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.curriculumQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> learningQueueRefs(
    Expression<bool> Function($$LearningQueueTableFilterComposer f) f,
  ) {
    final $$LearningQueueTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learningQueue,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearningQueueTableFilterComposer(
            $db: $db,
            $table: $db.learningQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CurriculumWordsTableOrderingComposer
    extends Composer<_$AppDatabase, $CurriculumWordsTable> {
  $$CurriculumWordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentSchema => $composableBuilder(
    column: $table.contentSchema,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hanzi => $composableBuilder(
    column: $table.hanzi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinyin => $composableBuilder(
    column: $table.pinyin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultPosition => $composableBuilder(
    column: $table.defaultPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CurriculumWordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurriculumWordsTable> {
  $$CurriculumWordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get contentSchema => $composableBuilder(
    column: $table.contentSchema,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hanzi =>
      $composableBuilder(column: $table.hanzi, builder: (column) => column);

  GeneratedColumn<String> get pinyin =>
      $composableBuilder(column: $table.pinyin, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);

  GeneratedColumn<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultPosition => $composableBuilder(
    column: $table.defaultPosition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  Expression<T> curriculumExamplesRefs<T extends Object>(
    Expression<T> Function($$CurriculumExamplesTableAnnotationComposer a) f,
  ) {
    final $$CurriculumExamplesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.curriculumExamples,
          getReferencedColumn: (t) => t.wordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CurriculumExamplesTableAnnotationComposer(
                $db: $db,
                $table: $db.curriculumExamples,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> curriculumQuestionsRefs<T extends Object>(
    Expression<T> Function($$CurriculumQuestionsTableAnnotationComposer a) f,
  ) {
    final $$CurriculumQuestionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.curriculumQuestions,
          getReferencedColumn: (t) => t.wordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CurriculumQuestionsTableAnnotationComposer(
                $db: $db,
                $table: $db.curriculumQuestions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> learningQueueRefs<T extends Object>(
    Expression<T> Function($$LearningQueueTableAnnotationComposer a) f,
  ) {
    final $$LearningQueueTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learningQueue,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearningQueueTableAnnotationComposer(
            $db: $db,
            $table: $db.learningQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CurriculumWordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurriculumWordsTable,
          CurriculumWord,
          $$CurriculumWordsTableFilterComposer,
          $$CurriculumWordsTableOrderingComposer,
          $$CurriculumWordsTableAnnotationComposer,
          $$CurriculumWordsTableCreateCompanionBuilder,
          $$CurriculumWordsTableUpdateCompanionBuilder,
          (CurriculumWord, $$CurriculumWordsTableReferences),
          CurriculumWord,
          PrefetchHooks Function({
            bool curriculumExamplesRefs,
            bool curriculumQuestionsRefs,
            bool learningQueueRefs,
          })
        > {
  $$CurriculumWordsTableTableManager(
    _$AppDatabase db,
    $CurriculumWordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurriculumWordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurriculumWordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurriculumWordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> contentSchema = const Value.absent(),
                Value<String> hanzi = const Value.absent(),
                Value<String> pinyin = const Value.absent(),
                Value<String> meaning = const Value.absent(),
                Value<String> searchText = const Value.absent(),
                Value<int> defaultPosition = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurriculumWordsCompanion(
                id: id,
                packId: packId,
                revision: revision,
                contentSchema: contentSchema,
                hanzi: hanzi,
                pinyin: pinyin,
                meaning: meaning,
                searchText: searchText,
                defaultPosition: defaultPosition,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String packId,
                required int revision,
                required int contentSchema,
                required String hanzi,
                required String pinyin,
                required String meaning,
                required String searchText,
                required int defaultPosition,
                required String metadataJson,
                Value<int> rowid = const Value.absent(),
              }) => CurriculumWordsCompanion.insert(
                id: id,
                packId: packId,
                revision: revision,
                contentSchema: contentSchema,
                hanzi: hanzi,
                pinyin: pinyin,
                meaning: meaning,
                searchText: searchText,
                defaultPosition: defaultPosition,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CurriculumWordsTable, CurriculumWord>(table),
                  $$CurriculumWordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                curriculumExamplesRefs = false,
                curriculumQuestionsRefs = false,
                learningQueueRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (curriculumExamplesRefs) db.curriculumExamples,
                    if (curriculumQuestionsRefs) db.curriculumQuestions,
                    if (learningQueueRefs) db.learningQueue,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (curriculumExamplesRefs)
                        await $_getPrefetchedDataByColumns<
                          CurriculumWord,
                          $CurriculumWordsTable,
                          CurriculumExample,
                          $CurriculumExamplesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CurriculumWordsTableReferences
                              ._curriculumExamplesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CurriculumWordsTableReferences(
                                db,
                                table,
                                p0,
                              ).curriculumExamplesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'word_id',
                          typedResults: items,
                        ),
                      if (curriculumQuestionsRefs)
                        await $_getPrefetchedDataByColumns<
                          CurriculumWord,
                          $CurriculumWordsTable,
                          CurriculumQuestion,
                          $CurriculumQuestionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CurriculumWordsTableReferences
                              ._curriculumQuestionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CurriculumWordsTableReferences(
                                db,
                                table,
                                p0,
                              ).curriculumQuestionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'word_id',
                          typedResults: items,
                        ),
                      if (learningQueueRefs)
                        await $_getPrefetchedDataByColumns<
                          CurriculumWord,
                          $CurriculumWordsTable,
                          LearningQueueData,
                          $LearningQueueTable
                        >(
                          currentTable: table,
                          referencedTable: $$CurriculumWordsTableReferences
                              ._learningQueueRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CurriculumWordsTableReferences(
                                db,
                                table,
                                p0,
                              ).learningQueueRefs,
                          currentColumn: 'id',
                          referencedColumn: 'word_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CurriculumWordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurriculumWordsTable,
      CurriculumWord,
      $$CurriculumWordsTableFilterComposer,
      $$CurriculumWordsTableOrderingComposer,
      $$CurriculumWordsTableAnnotationComposer,
      $$CurriculumWordsTableCreateCompanionBuilder,
      $$CurriculumWordsTableUpdateCompanionBuilder,
      (CurriculumWord, $$CurriculumWordsTableReferences),
      CurriculumWord,
      PrefetchHooks Function({
        bool curriculumExamplesRefs,
        bool curriculumQuestionsRefs,
        bool learningQueueRefs,
      })
    >;
typedef $$CurriculumSentencesTableCreateCompanionBuilder =
    CurriculumSentencesCompanion Function({
      required String id,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$CurriculumSentencesTableUpdateCompanionBuilder =
    CurriculumSentencesCompanion Function({
      Value<String> id,
      Value<String> payloadJson,
      Value<int> rowid,
    });

final class $$CurriculumSentencesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CurriculumSentencesTable,
          CurriculumSentence
        > {
  $$CurriculumSentencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CurriculumExamplesTable, List<CurriculumExample>>
  _curriculumExamplesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.curriculumExamples,
        aliasName: 'curriculum_sentences__id__curriculum_examples__sentence_id',
      );

  $$CurriculumExamplesTableProcessedTableManager get curriculumExamplesRefs {
    final manager = $$CurriculumExamplesTableTableManager(
      $_db,
      $_db.curriculumExamples,
    ).filter((f) => f.sentenceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _curriculumExamplesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CurriculumAudioTable, List<CurriculumAudioData>>
  _curriculumAudioRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.curriculumAudio,
    aliasName: 'curriculum_sentences__id__curriculum_audio__sentence_id',
  );

  $$CurriculumAudioTableProcessedTableManager get curriculumAudioRefs {
    final manager = $$CurriculumAudioTableTableManager(
      $_db,
      $_db.curriculumAudio,
    ).filter((f) => f.sentenceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _curriculumAudioRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CurriculumSentencesTableFilterComposer
    extends Composer<_$AppDatabase, $CurriculumSentencesTable> {
  $$CurriculumSentencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> curriculumExamplesRefs(
    Expression<bool> Function($$CurriculumExamplesTableFilterComposer f) f,
  ) {
    final $$CurriculumExamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.curriculumExamples,
      getReferencedColumn: (t) => t.sentenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumExamplesTableFilterComposer(
            $db: $db,
            $table: $db.curriculumExamples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> curriculumAudioRefs(
    Expression<bool> Function($$CurriculumAudioTableFilterComposer f) f,
  ) {
    final $$CurriculumAudioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.curriculumAudio,
      getReferencedColumn: (t) => t.sentenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumAudioTableFilterComposer(
            $db: $db,
            $table: $db.curriculumAudio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CurriculumSentencesTableOrderingComposer
    extends Composer<_$AppDatabase, $CurriculumSentencesTable> {
  $$CurriculumSentencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CurriculumSentencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurriculumSentencesTable> {
  $$CurriculumSentencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  Expression<T> curriculumExamplesRefs<T extends Object>(
    Expression<T> Function($$CurriculumExamplesTableAnnotationComposer a) f,
  ) {
    final $$CurriculumExamplesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.curriculumExamples,
          getReferencedColumn: (t) => t.sentenceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CurriculumExamplesTableAnnotationComposer(
                $db: $db,
                $table: $db.curriculumExamples,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> curriculumAudioRefs<T extends Object>(
    Expression<T> Function($$CurriculumAudioTableAnnotationComposer a) f,
  ) {
    final $$CurriculumAudioTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.curriculumAudio,
      getReferencedColumn: (t) => t.sentenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumAudioTableAnnotationComposer(
            $db: $db,
            $table: $db.curriculumAudio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CurriculumSentencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurriculumSentencesTable,
          CurriculumSentence,
          $$CurriculumSentencesTableFilterComposer,
          $$CurriculumSentencesTableOrderingComposer,
          $$CurriculumSentencesTableAnnotationComposer,
          $$CurriculumSentencesTableCreateCompanionBuilder,
          $$CurriculumSentencesTableUpdateCompanionBuilder,
          (CurriculumSentence, $$CurriculumSentencesTableReferences),
          CurriculumSentence,
          PrefetchHooks Function({
            bool curriculumExamplesRefs,
            bool curriculumAudioRefs,
          })
        > {
  $$CurriculumSentencesTableTableManager(
    _$AppDatabase db,
    $CurriculumSentencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurriculumSentencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurriculumSentencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CurriculumSentencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurriculumSentencesCompanion(
                id: id,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => CurriculumSentencesCompanion.insert(
                id: id,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CurriculumSentencesTable, CurriculumSentence>(
                    table,
                  ),
                  $$CurriculumSentencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({curriculumExamplesRefs = false, curriculumAudioRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (curriculumExamplesRefs) db.curriculumExamples,
                    if (curriculumAudioRefs) db.curriculumAudio,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (curriculumExamplesRefs)
                        await $_getPrefetchedDataByColumns<
                          CurriculumSentence,
                          $CurriculumSentencesTable,
                          CurriculumExample,
                          $CurriculumExamplesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CurriculumSentencesTableReferences
                              ._curriculumExamplesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CurriculumSentencesTableReferences(
                                db,
                                table,
                                p0,
                              ).curriculumExamplesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'sentence_id',
                          typedResults: items,
                        ),
                      if (curriculumAudioRefs)
                        await $_getPrefetchedDataByColumns<
                          CurriculumSentence,
                          $CurriculumSentencesTable,
                          CurriculumAudioData,
                          $CurriculumAudioTable
                        >(
                          currentTable: table,
                          referencedTable: $$CurriculumSentencesTableReferences
                              ._curriculumAudioRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CurriculumSentencesTableReferences(
                                db,
                                table,
                                p0,
                              ).curriculumAudioRefs,
                          currentColumn: 'id',
                          referencedColumn: 'sentence_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CurriculumSentencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurriculumSentencesTable,
      CurriculumSentence,
      $$CurriculumSentencesTableFilterComposer,
      $$CurriculumSentencesTableOrderingComposer,
      $$CurriculumSentencesTableAnnotationComposer,
      $$CurriculumSentencesTableCreateCompanionBuilder,
      $$CurriculumSentencesTableUpdateCompanionBuilder,
      (CurriculumSentence, $$CurriculumSentencesTableReferences),
      CurriculumSentence,
      PrefetchHooks Function({
        bool curriculumExamplesRefs,
        bool curriculumAudioRefs,
      })
    >;
typedef $$CurriculumExamplesTableCreateCompanionBuilder =
    CurriculumExamplesCompanion Function({
      required String wordId,
      required String sentenceId,
      required int position,
      Value<int> rowid,
    });
typedef $$CurriculumExamplesTableUpdateCompanionBuilder =
    CurriculumExamplesCompanion Function({
      Value<String> wordId,
      Value<String> sentenceId,
      Value<int> position,
      Value<int> rowid,
    });

final class $$CurriculumExamplesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CurriculumExamplesTable,
          CurriculumExample
        > {
  $$CurriculumExamplesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CurriculumWordsTable _wordIdTable(_$AppDatabase db) => db
      .curriculumWords
      .createAlias('curriculum_examples__word_id__curriculum_words__id');

  $$CurriculumWordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<String>('word_id')!;

    final manager = $$CurriculumWordsTableTableManager(
      $_db,
      $_db.curriculumWords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CurriculumSentencesTable _sentenceIdTable(_$AppDatabase db) =>
      db.curriculumSentences.createAlias(
        'curriculum_examples__sentence_id__curriculum_sentences__id',
      );

  $$CurriculumSentencesTableProcessedTableManager get sentenceId {
    final $_column = $_itemColumn<String>('sentence_id')!;

    final manager = $$CurriculumSentencesTableTableManager(
      $_db,
      $_db.curriculumSentences,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sentenceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CurriculumExamplesTableFilterComposer
    extends Composer<_$AppDatabase, $CurriculumExamplesTable> {
  $$CurriculumExamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$CurriculumWordsTableFilterComposer get wordId {
    final $$CurriculumWordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.curriculumWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumWordsTableFilterComposer(
            $db: $db,
            $table: $db.curriculumWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CurriculumSentencesTableFilterComposer get sentenceId {
    final $$CurriculumSentencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sentenceId,
      referencedTable: $db.curriculumSentences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumSentencesTableFilterComposer(
            $db: $db,
            $table: $db.curriculumSentences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CurriculumExamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $CurriculumExamplesTable> {
  $$CurriculumExamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$CurriculumWordsTableOrderingComposer get wordId {
    final $$CurriculumWordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.curriculumWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumWordsTableOrderingComposer(
            $db: $db,
            $table: $db.curriculumWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CurriculumSentencesTableOrderingComposer get sentenceId {
    final $$CurriculumSentencesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sentenceId,
          referencedTable: $db.curriculumSentences,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CurriculumSentencesTableOrderingComposer(
                $db: $db,
                $table: $db.curriculumSentences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CurriculumExamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurriculumExamplesTable> {
  $$CurriculumExamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$CurriculumWordsTableAnnotationComposer get wordId {
    final $$CurriculumWordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.curriculumWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumWordsTableAnnotationComposer(
            $db: $db,
            $table: $db.curriculumWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CurriculumSentencesTableAnnotationComposer get sentenceId {
    final $$CurriculumSentencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sentenceId,
          referencedTable: $db.curriculumSentences,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CurriculumSentencesTableAnnotationComposer(
                $db: $db,
                $table: $db.curriculumSentences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CurriculumExamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurriculumExamplesTable,
          CurriculumExample,
          $$CurriculumExamplesTableFilterComposer,
          $$CurriculumExamplesTableOrderingComposer,
          $$CurriculumExamplesTableAnnotationComposer,
          $$CurriculumExamplesTableCreateCompanionBuilder,
          $$CurriculumExamplesTableUpdateCompanionBuilder,
          (CurriculumExample, $$CurriculumExamplesTableReferences),
          CurriculumExample,
          PrefetchHooks Function({bool wordId, bool sentenceId})
        > {
  $$CurriculumExamplesTableTableManager(
    _$AppDatabase db,
    $CurriculumExamplesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurriculumExamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurriculumExamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurriculumExamplesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> wordId = const Value.absent(),
                Value<String> sentenceId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurriculumExamplesCompanion(
                wordId: wordId,
                sentenceId: sentenceId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String wordId,
                required String sentenceId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => CurriculumExamplesCompanion.insert(
                wordId: wordId,
                sentenceId: sentenceId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CurriculumExamplesTable, CurriculumExample>(
                    table,
                  ),
                  $$CurriculumExamplesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false, sentenceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wordId,
                        referencedTable: $$CurriculumExamplesTableReferences
                            ._wordIdTable(db),
                        referencedColumn: $$CurriculumExamplesTableReferences
                            ._wordIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (sentenceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sentenceId,
                        referencedTable: $$CurriculumExamplesTableReferences
                            ._sentenceIdTable(db),
                        referencedColumn: $$CurriculumExamplesTableReferences
                            ._sentenceIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CurriculumExamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurriculumExamplesTable,
      CurriculumExample,
      $$CurriculumExamplesTableFilterComposer,
      $$CurriculumExamplesTableOrderingComposer,
      $$CurriculumExamplesTableAnnotationComposer,
      $$CurriculumExamplesTableCreateCompanionBuilder,
      $$CurriculumExamplesTableUpdateCompanionBuilder,
      (CurriculumExample, $$CurriculumExamplesTableReferences),
      CurriculumExample,
      PrefetchHooks Function({bool wordId, bool sentenceId})
    >;
typedef $$CurriculumAudioTableCreateCompanionBuilder =
    CurriculumAudioCompanion Function({
      required String id,
      required String sentenceId,
      required String payloadJson,
      required bool localAvailable,
      Value<int> rowid,
    });
typedef $$CurriculumAudioTableUpdateCompanionBuilder =
    CurriculumAudioCompanion Function({
      Value<String> id,
      Value<String> sentenceId,
      Value<String> payloadJson,
      Value<bool> localAvailable,
      Value<int> rowid,
    });

final class $$CurriculumAudioTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CurriculumAudioTable,
          CurriculumAudioData
        > {
  $$CurriculumAudioTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CurriculumSentencesTable _sentenceIdTable(_$AppDatabase db) => db
      .curriculumSentences
      .createAlias('curriculum_audio__sentence_id__curriculum_sentences__id');

  $$CurriculumSentencesTableProcessedTableManager get sentenceId {
    final $_column = $_itemColumn<String>('sentence_id')!;

    final manager = $$CurriculumSentencesTableTableManager(
      $_db,
      $_db.curriculumSentences,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sentenceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CurriculumAudioTableFilterComposer
    extends Composer<_$AppDatabase, $CurriculumAudioTable> {
  $$CurriculumAudioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get localAvailable => $composableBuilder(
    column: $table.localAvailable,
    builder: (column) => ColumnFilters(column),
  );

  $$CurriculumSentencesTableFilterComposer get sentenceId {
    final $$CurriculumSentencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sentenceId,
      referencedTable: $db.curriculumSentences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumSentencesTableFilterComposer(
            $db: $db,
            $table: $db.curriculumSentences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CurriculumAudioTableOrderingComposer
    extends Composer<_$AppDatabase, $CurriculumAudioTable> {
  $$CurriculumAudioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get localAvailable => $composableBuilder(
    column: $table.localAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  $$CurriculumSentencesTableOrderingComposer get sentenceId {
    final $$CurriculumSentencesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sentenceId,
          referencedTable: $db.curriculumSentences,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CurriculumSentencesTableOrderingComposer(
                $db: $db,
                $table: $db.curriculumSentences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CurriculumAudioTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurriculumAudioTable> {
  $$CurriculumAudioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get localAvailable => $composableBuilder(
    column: $table.localAvailable,
    builder: (column) => column,
  );

  $$CurriculumSentencesTableAnnotationComposer get sentenceId {
    final $$CurriculumSentencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sentenceId,
          referencedTable: $db.curriculumSentences,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CurriculumSentencesTableAnnotationComposer(
                $db: $db,
                $table: $db.curriculumSentences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CurriculumAudioTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurriculumAudioTable,
          CurriculumAudioData,
          $$CurriculumAudioTableFilterComposer,
          $$CurriculumAudioTableOrderingComposer,
          $$CurriculumAudioTableAnnotationComposer,
          $$CurriculumAudioTableCreateCompanionBuilder,
          $$CurriculumAudioTableUpdateCompanionBuilder,
          (CurriculumAudioData, $$CurriculumAudioTableReferences),
          CurriculumAudioData,
          PrefetchHooks Function({bool sentenceId})
        > {
  $$CurriculumAudioTableTableManager(
    _$AppDatabase db,
    $CurriculumAudioTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurriculumAudioTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurriculumAudioTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurriculumAudioTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sentenceId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<bool> localAvailable = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurriculumAudioCompanion(
                id: id,
                sentenceId: sentenceId,
                payloadJson: payloadJson,
                localAvailable: localAvailable,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sentenceId,
                required String payloadJson,
                required bool localAvailable,
                Value<int> rowid = const Value.absent(),
              }) => CurriculumAudioCompanion.insert(
                id: id,
                sentenceId: sentenceId,
                payloadJson: payloadJson,
                localAvailable: localAvailable,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CurriculumAudioTable, CurriculumAudioData>(
                    table,
                  ),
                  $$CurriculumAudioTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sentenceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sentenceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sentenceId,
                        referencedTable: $$CurriculumAudioTableReferences
                            ._sentenceIdTable(db),
                        referencedColumn: $$CurriculumAudioTableReferences
                            ._sentenceIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CurriculumAudioTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurriculumAudioTable,
      CurriculumAudioData,
      $$CurriculumAudioTableFilterComposer,
      $$CurriculumAudioTableOrderingComposer,
      $$CurriculumAudioTableAnnotationComposer,
      $$CurriculumAudioTableCreateCompanionBuilder,
      $$CurriculumAudioTableUpdateCompanionBuilder,
      (CurriculumAudioData, $$CurriculumAudioTableReferences),
      CurriculumAudioData,
      PrefetchHooks Function({bool sentenceId})
    >;
typedef $$CurriculumQuestionsTableCreateCompanionBuilder =
    CurriculumQuestionsCompanion Function({
      required String id,
      required String wordId,
      required int position,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$CurriculumQuestionsTableUpdateCompanionBuilder =
    CurriculumQuestionsCompanion Function({
      Value<String> id,
      Value<String> wordId,
      Value<int> position,
      Value<String> payloadJson,
      Value<int> rowid,
    });

final class $$CurriculumQuestionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CurriculumQuestionsTable,
          CurriculumQuestion
        > {
  $$CurriculumQuestionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CurriculumWordsTable _wordIdTable(_$AppDatabase db) => db
      .curriculumWords
      .createAlias('curriculum_questions__word_id__curriculum_words__id');

  $$CurriculumWordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<String>('word_id')!;

    final manager = $$CurriculumWordsTableTableManager(
      $_db,
      $_db.curriculumWords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CurriculumQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $CurriculumQuestionsTable> {
  $$CurriculumQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  $$CurriculumWordsTableFilterComposer get wordId {
    final $$CurriculumWordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.curriculumWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumWordsTableFilterComposer(
            $db: $db,
            $table: $db.curriculumWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CurriculumQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CurriculumQuestionsTable> {
  $$CurriculumQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$CurriculumWordsTableOrderingComposer get wordId {
    final $$CurriculumWordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.curriculumWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumWordsTableOrderingComposer(
            $db: $db,
            $table: $db.curriculumWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CurriculumQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurriculumQuestionsTable> {
  $$CurriculumQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  $$CurriculumWordsTableAnnotationComposer get wordId {
    final $$CurriculumWordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.curriculumWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumWordsTableAnnotationComposer(
            $db: $db,
            $table: $db.curriculumWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CurriculumQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurriculumQuestionsTable,
          CurriculumQuestion,
          $$CurriculumQuestionsTableFilterComposer,
          $$CurriculumQuestionsTableOrderingComposer,
          $$CurriculumQuestionsTableAnnotationComposer,
          $$CurriculumQuestionsTableCreateCompanionBuilder,
          $$CurriculumQuestionsTableUpdateCompanionBuilder,
          (CurriculumQuestion, $$CurriculumQuestionsTableReferences),
          CurriculumQuestion,
          PrefetchHooks Function({bool wordId})
        > {
  $$CurriculumQuestionsTableTableManager(
    _$AppDatabase db,
    $CurriculumQuestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurriculumQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurriculumQuestionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CurriculumQuestionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurriculumQuestionsCompanion(
                id: id,
                wordId: wordId,
                position: position,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String wordId,
                required int position,
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => CurriculumQuestionsCompanion.insert(
                id: id,
                wordId: wordId,
                position: position,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CurriculumQuestionsTable, CurriculumQuestion>(
                    table,
                  ),
                  $$CurriculumQuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wordId,
                        referencedTable: $$CurriculumQuestionsTableReferences
                            ._wordIdTable(db),
                        referencedColumn: $$CurriculumQuestionsTableReferences
                            ._wordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CurriculumQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurriculumQuestionsTable,
      CurriculumQuestion,
      $$CurriculumQuestionsTableFilterComposer,
      $$CurriculumQuestionsTableOrderingComposer,
      $$CurriculumQuestionsTableAnnotationComposer,
      $$CurriculumQuestionsTableCreateCompanionBuilder,
      $$CurriculumQuestionsTableUpdateCompanionBuilder,
      (CurriculumQuestion, $$CurriculumQuestionsTableReferences),
      CurriculumQuestion,
      PrefetchHooks Function({bool wordId})
    >;
typedef $$CurriculumInstallsTableCreateCompanionBuilder =
    CurriculumInstallsCompanion Function({
      Value<int> id,
      required int revision,
      required String digest,
    });
typedef $$CurriculumInstallsTableUpdateCompanionBuilder =
    CurriculumInstallsCompanion Function({
      Value<int> id,
      Value<int> revision,
      Value<String> digest,
    });

class $$CurriculumInstallsTableFilterComposer
    extends Composer<_$AppDatabase, $CurriculumInstallsTable> {
  $$CurriculumInstallsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get digest => $composableBuilder(
    column: $table.digest,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CurriculumInstallsTableOrderingComposer
    extends Composer<_$AppDatabase, $CurriculumInstallsTable> {
  $$CurriculumInstallsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get digest => $composableBuilder(
    column: $table.digest,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CurriculumInstallsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurriculumInstallsTable> {
  $$CurriculumInstallsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get digest =>
      $composableBuilder(column: $table.digest, builder: (column) => column);
}

class $$CurriculumInstallsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurriculumInstallsTable,
          CurriculumInstall,
          $$CurriculumInstallsTableFilterComposer,
          $$CurriculumInstallsTableOrderingComposer,
          $$CurriculumInstallsTableAnnotationComposer,
          $$CurriculumInstallsTableCreateCompanionBuilder,
          $$CurriculumInstallsTableUpdateCompanionBuilder,
          (
            CurriculumInstall,
            BaseReferences<
              _$AppDatabase,
              $CurriculumInstallsTable,
              CurriculumInstall
            >,
          ),
          CurriculumInstall,
          PrefetchHooks Function()
        > {
  $$CurriculumInstallsTableTableManager(
    _$AppDatabase db,
    $CurriculumInstallsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurriculumInstallsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurriculumInstallsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurriculumInstallsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> digest = const Value.absent(),
              }) => CurriculumInstallsCompanion(
                id: id,
                revision: revision,
                digest: digest,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int revision,
                required String digest,
              }) => CurriculumInstallsCompanion.insert(
                id: id,
                revision: revision,
                digest: digest,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CurriculumInstallsTable, CurriculumInstall>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CurriculumInstallsTable,
                    CurriculumInstall
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CurriculumInstallsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurriculumInstallsTable,
      CurriculumInstall,
      $$CurriculumInstallsTableFilterComposer,
      $$CurriculumInstallsTableOrderingComposer,
      $$CurriculumInstallsTableAnnotationComposer,
      $$CurriculumInstallsTableCreateCompanionBuilder,
      $$CurriculumInstallsTableUpdateCompanionBuilder,
      (
        CurriculumInstall,
        BaseReferences<
          _$AppDatabase,
          $CurriculumInstallsTable,
          CurriculumInstall
        >,
      ),
      CurriculumInstall,
      PrefetchHooks Function()
    >;
typedef $$LearningQueueTableCreateCompanionBuilder =
    LearningQueueCompanion Function({
      required int profileId,
      required String wordId,
      required int position,
      Value<int> rowid,
    });
typedef $$LearningQueueTableUpdateCompanionBuilder =
    LearningQueueCompanion Function({
      Value<int> profileId,
      Value<String> wordId,
      Value<int> position,
      Value<int> rowid,
    });

final class $$LearningQueueTableReferences
    extends
        BaseReferences<_$AppDatabase, $LearningQueueTable, LearningQueueData> {
  $$LearningQueueTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('learning_queue__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CurriculumWordsTable _wordIdTable(_$AppDatabase db) => db
      .curriculumWords
      .createAlias('learning_queue__word_id__curriculum_words__id');

  $$CurriculumWordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<String>('word_id')!;

    final manager = $$CurriculumWordsTableTableManager(
      $_db,
      $_db.curriculumWords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LearningQueueTableFilterComposer
    extends Composer<_$AppDatabase, $LearningQueueTable> {
  $$LearningQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CurriculumWordsTableFilterComposer get wordId {
    final $$CurriculumWordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.curriculumWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumWordsTableFilterComposer(
            $db: $db,
            $table: $db.curriculumWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LearningQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $LearningQueueTable> {
  $$LearningQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CurriculumWordsTableOrderingComposer get wordId {
    final $$CurriculumWordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.curriculumWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumWordsTableOrderingComposer(
            $db: $db,
            $table: $db.curriculumWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LearningQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearningQueueTable> {
  $$LearningQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CurriculumWordsTableAnnotationComposer get wordId {
    final $$CurriculumWordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.curriculumWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurriculumWordsTableAnnotationComposer(
            $db: $db,
            $table: $db.curriculumWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LearningQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LearningQueueTable,
          LearningQueueData,
          $$LearningQueueTableFilterComposer,
          $$LearningQueueTableOrderingComposer,
          $$LearningQueueTableAnnotationComposer,
          $$LearningQueueTableCreateCompanionBuilder,
          $$LearningQueueTableUpdateCompanionBuilder,
          (LearningQueueData, $$LearningQueueTableReferences),
          LearningQueueData,
          PrefetchHooks Function({bool profileId, bool wordId})
        > {
  $$LearningQueueTableTableManager(_$AppDatabase db, $LearningQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearningQueueCompanion(
                profileId: profileId,
                wordId: wordId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required String wordId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => LearningQueueCompanion.insert(
                profileId: profileId,
                wordId: wordId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LearningQueueTable, LearningQueueData>(table),
                  $$LearningQueueTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false, wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$LearningQueueTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$LearningQueueTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (wordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wordId,
                        referencedTable: $$LearningQueueTableReferences
                            ._wordIdTable(db),
                        referencedColumn: $$LearningQueueTableReferences
                            ._wordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LearningQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LearningQueueTable,
      LearningQueueData,
      $$LearningQueueTableFilterComposer,
      $$LearningQueueTableOrderingComposer,
      $$LearningQueueTableAnnotationComposer,
      $$LearningQueueTableCreateCompanionBuilder,
      $$LearningQueueTableUpdateCompanionBuilder,
      (LearningQueueData, $$LearningQueueTableReferences),
      LearningQueueData,
      PrefetchHooks Function({bool profileId, bool wordId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$AppPreferencesTableTableManager get appPreferences =>
      $$AppPreferencesTableTableManager(_db, _db.appPreferences);
  $$FoundationProgressTableTableManager get foundationProgress =>
      $$FoundationProgressTableTableManager(_db, _db.foundationProgress);
  $$VocabularyProgressTableTableManager get vocabularyProgress =>
      $$VocabularyProgressTableTableManager(_db, _db.vocabularyProgress);
  $$VocabularyAttemptsTableTableManager get vocabularyAttempts =>
      $$VocabularyAttemptsTableTableManager(_db, _db.vocabularyAttempts);
  $$PracticeResponsesTableTableManager get practiceResponses =>
      $$PracticeResponsesTableTableManager(_db, _db.practiceResponses);
  $$MasteredWordsTableTableManager get masteredWords =>
      $$MasteredWordsTableTableManager(_db, _db.masteredWords);
  $$MasterWritingsTableTableManager get masterWritings =>
      $$MasterWritingsTableTableManager(_db, _db.masterWritings);
  $$GrammarLessonsTableTableManager get grammarLessons =>
      $$GrammarLessonsTableTableManager(_db, _db.grammarLessons);
  $$GrammarExamplesTableTableManager get grammarExamples =>
      $$GrammarExamplesTableTableManager(_db, _db.grammarExamples);
  $$GrammarProgressTableTableManager get grammarProgress =>
      $$GrammarProgressTableTableManager(_db, _db.grammarProgress);
  $$GrammarInstallsTableTableManager get grammarInstalls =>
      $$GrammarInstallsTableTableManager(_db, _db.grammarInstalls);
  $$ContentPacksTableTableManager get contentPacks =>
      $$ContentPacksTableTableManager(_db, _db.contentPacks);
  $$ContentWordsTableTableManager get contentWords =>
      $$ContentWordsTableTableManager(_db, _db.contentWords);
  $$ContentExamplesTableTableManager get contentExamples =>
      $$ContentExamplesTableTableManager(_db, _db.contentExamples);
  $$ContentExercisesTableTableManager get contentExercises =>
      $$ContentExercisesTableTableManager(_db, _db.contentExercises);
  $$CurriculumWordsTableTableManager get curriculumWords =>
      $$CurriculumWordsTableTableManager(_db, _db.curriculumWords);
  $$CurriculumSentencesTableTableManager get curriculumSentences =>
      $$CurriculumSentencesTableTableManager(_db, _db.curriculumSentences);
  $$CurriculumExamplesTableTableManager get curriculumExamples =>
      $$CurriculumExamplesTableTableManager(_db, _db.curriculumExamples);
  $$CurriculumAudioTableTableManager get curriculumAudio =>
      $$CurriculumAudioTableTableManager(_db, _db.curriculumAudio);
  $$CurriculumQuestionsTableTableManager get curriculumQuestions =>
      $$CurriculumQuestionsTableTableManager(_db, _db.curriculumQuestions);
  $$CurriculumInstallsTableTableManager get curriculumInstalls =>
      $$CurriculumInstallsTableTableManager(_db, _db.curriculumInstalls);
  $$LearningQueueTableTableManager get learningQueue =>
      $$LearningQueueTableTableManager(_db, _db.learningQueue);
}
