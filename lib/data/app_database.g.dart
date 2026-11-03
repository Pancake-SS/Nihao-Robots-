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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $AppPreferencesTable appPreferences = $AppPreferencesTable(this);
  late final $FoundationProgressTable foundationProgress =
      $FoundationProgressTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    appPreferences,
    foundationProgress,
  ];
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
              ({appPreferencesRefs = false, foundationProgressRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (appPreferencesRefs) db.appPreferences,
                    if (foundationProgressRefs) db.foundationProgress,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$AppPreferencesTableTableManager get appPreferences =>
      $$AppPreferencesTableTableManager(_db, _db.appPreferences);
  $$FoundationProgressTableTableManager get foundationProgress =>
      $$FoundationProgressTableTableManager(_db, _db.foundationProgress);
}
