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
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (appPreferencesRefs) db.appPreferences,
                    if (foundationProgressRefs) db.foundationProgress,
                    if (vocabularyProgressRefs) db.vocabularyProgress,
                    if (vocabularyAttemptsRefs) db.vocabularyAttempts,
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
}
