// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recoveryEmailMeta =
      const VerificationMeta('recoveryEmail');
  @override
  late final GeneratedColumn<String> recoveryEmail = GeneratedColumn<String>(
      'recovery_email', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 5, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _mustChangePasswordMeta =
      const VerificationMeta('mustChangePassword');
  @override
  late final GeneratedColumn<bool> mustChangePassword = GeneratedColumn<bool>(
      'must_change_password', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("must_change_password" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        passwordHash,
        recoveryEmail,
        role,
        mustChangePassword,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('recovery_email')) {
      context.handle(
          _recoveryEmailMeta,
          recoveryEmail.isAcceptableOrUnknown(
              data['recovery_email']!, _recoveryEmailMeta));
    } else if (isInserting) {
      context.missing(_recoveryEmailMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('must_change_password')) {
      context.handle(
          _mustChangePasswordMeta,
          mustChangePassword.isAcceptableOrUnknown(
              data['must_change_password']!, _mustChangePasswordMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      recoveryEmail: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recovery_email'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      mustChangePassword: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}must_change_password'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String passwordHash;
  final String recoveryEmail;
  final String role;
  final bool mustChangePassword;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User(
      {required this.id,
      required this.username,
      required this.passwordHash,
      required this.recoveryEmail,
      required this.role,
      required this.mustChangePassword,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['recovery_email'] = Variable<String>(recoveryEmail);
    map['role'] = Variable<String>(role);
    map['must_change_password'] = Variable<bool>(mustChangePassword);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      passwordHash: Value(passwordHash),
      recoveryEmail: Value(recoveryEmail),
      role: Value(role),
      mustChangePassword: Value(mustChangePassword),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      recoveryEmail: serializer.fromJson<String>(json['recoveryEmail']),
      role: serializer.fromJson<String>(json['role']),
      mustChangePassword: serializer.fromJson<bool>(json['mustChangePassword']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'recoveryEmail': serializer.toJson<String>(recoveryEmail),
      'role': serializer.toJson<String>(role),
      'mustChangePassword': serializer.toJson<bool>(mustChangePassword),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith(
          {int? id,
          String? username,
          String? passwordHash,
          String? recoveryEmail,
          String? role,
          bool? mustChangePassword,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        passwordHash: passwordHash ?? this.passwordHash,
        recoveryEmail: recoveryEmail ?? this.recoveryEmail,
        role: role ?? this.role,
        mustChangePassword: mustChangePassword ?? this.mustChangePassword,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      recoveryEmail: data.recoveryEmail.present
          ? data.recoveryEmail.value
          : this.recoveryEmail,
      role: data.role.present ? data.role.value : this.role,
      mustChangePassword: data.mustChangePassword.present
          ? data.mustChangePassword.value
          : this.mustChangePassword,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('recoveryEmail: $recoveryEmail, ')
          ..write('role: $role, ')
          ..write('mustChangePassword: $mustChangePassword, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, passwordHash, recoveryEmail,
      role, mustChangePassword, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.recoveryEmail == this.recoveryEmail &&
          other.role == this.role &&
          other.mustChangePassword == this.mustChangePassword &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<String> recoveryEmail;
  final Value<String> role;
  final Value<bool> mustChangePassword;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.recoveryEmail = const Value.absent(),
    this.role = const Value.absent(),
    this.mustChangePassword = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String passwordHash,
    required String recoveryEmail,
    required String role,
    this.mustChangePassword = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : username = Value(username),
        passwordHash = Value(passwordHash),
        recoveryEmail = Value(recoveryEmail),
        role = Value(role);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? recoveryEmail,
    Expression<String>? role,
    Expression<bool>? mustChangePassword,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (recoveryEmail != null) 'recovery_email': recoveryEmail,
      if (role != null) 'role': role,
      if (mustChangePassword != null)
        'must_change_password': mustChangePassword,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? passwordHash,
      Value<String>? recoveryEmail,
      Value<String>? role,
      Value<bool>? mustChangePassword,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      recoveryEmail: recoveryEmail ?? this.recoveryEmail,
      role: role ?? this.role,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (recoveryEmail.present) {
      map['recovery_email'] = Variable<String>(recoveryEmail.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (mustChangePassword.present) {
      map['must_change_password'] = Variable<bool>(mustChangePassword.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('recoveryEmail: $recoveryEmail, ')
          ..write('role: $role, ')
          ..write('mustChangePassword: $mustChangePassword, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _unitOfMeasurementMeta =
      const VerificationMeta('unitOfMeasurement');
  @override
  late final GeneratedColumn<String> unitOfMeasurement =
      GeneratedColumn<String>('unit_of_measurement', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
              minTextLength: 1, maxTextLength: 20),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _currentStockMeta =
      const VerificationMeta('currentStock');
  @override
  late final GeneratedColumn<double> currentStock = GeneratedColumn<double>(
      'current_stock', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _costPriceMeta =
      const VerificationMeta('costPrice');
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
      'cost_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _minStockAlertMeta =
      const VerificationMeta('minStockAlert');
  @override
  late final GeneratedColumn<double> minStockAlert = GeneratedColumn<double>(
      'min_stock_alert', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(10.0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        unitOfMeasurement,
        currentStock,
        costPrice,
        minStockAlert,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(Insertable<Ingredient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit_of_measurement')) {
      context.handle(
          _unitOfMeasurementMeta,
          unitOfMeasurement.isAcceptableOrUnknown(
              data['unit_of_measurement']!, _unitOfMeasurementMeta));
    } else if (isInserting) {
      context.missing(_unitOfMeasurementMeta);
    }
    if (data.containsKey('current_stock')) {
      context.handle(
          _currentStockMeta,
          currentStock.isAcceptableOrUnknown(
              data['current_stock']!, _currentStockMeta));
    }
    if (data.containsKey('cost_price')) {
      context.handle(_costPriceMeta,
          costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta));
    } else if (isInserting) {
      context.missing(_costPriceMeta);
    }
    if (data.containsKey('min_stock_alert')) {
      context.handle(
          _minStockAlertMeta,
          minStockAlert.isAcceptableOrUnknown(
              data['min_stock_alert']!, _minStockAlertMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      unitOfMeasurement: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unit_of_measurement'])!,
      currentStock: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_stock'])!,
      costPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_price'])!,
      minStockAlert: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}min_stock_alert'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final int id;
  final String name;
  final String unitOfMeasurement;
  final double currentStock;
  final double costPrice;
  final double minStockAlert;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Ingredient(
      {required this.id,
      required this.name,
      required this.unitOfMeasurement,
      required this.currentStock,
      required this.costPrice,
      required this.minStockAlert,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['unit_of_measurement'] = Variable<String>(unitOfMeasurement);
    map['current_stock'] = Variable<double>(currentStock);
    map['cost_price'] = Variable<double>(costPrice);
    map['min_stock_alert'] = Variable<double>(minStockAlert);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      name: Value(name),
      unitOfMeasurement: Value(unitOfMeasurement),
      currentStock: Value(currentStock),
      costPrice: Value(costPrice),
      minStockAlert: Value(minStockAlert),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Ingredient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      unitOfMeasurement: serializer.fromJson<String>(json['unitOfMeasurement']),
      currentStock: serializer.fromJson<double>(json['currentStock']),
      costPrice: serializer.fromJson<double>(json['costPrice']),
      minStockAlert: serializer.fromJson<double>(json['minStockAlert']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'unitOfMeasurement': serializer.toJson<String>(unitOfMeasurement),
      'currentStock': serializer.toJson<double>(currentStock),
      'costPrice': serializer.toJson<double>(costPrice),
      'minStockAlert': serializer.toJson<double>(minStockAlert),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Ingredient copyWith(
          {int? id,
          String? name,
          String? unitOfMeasurement,
          double? currentStock,
          double? costPrice,
          double? minStockAlert,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Ingredient(
        id: id ?? this.id,
        name: name ?? this.name,
        unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
        currentStock: currentStock ?? this.currentStock,
        costPrice: costPrice ?? this.costPrice,
        minStockAlert: minStockAlert ?? this.minStockAlert,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      unitOfMeasurement: data.unitOfMeasurement.present
          ? data.unitOfMeasurement.value
          : this.unitOfMeasurement,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      minStockAlert: data.minStockAlert.present
          ? data.minStockAlert.value
          : this.minStockAlert,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unitOfMeasurement: $unitOfMeasurement, ')
          ..write('currentStock: $currentStock, ')
          ..write('costPrice: $costPrice, ')
          ..write('minStockAlert: $minStockAlert, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, unitOfMeasurement, currentStock,
      costPrice, minStockAlert, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.name == this.name &&
          other.unitOfMeasurement == this.unitOfMeasurement &&
          other.currentStock == this.currentStock &&
          other.costPrice == this.costPrice &&
          other.minStockAlert == this.minStockAlert &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> unitOfMeasurement;
  final Value<double> currentStock;
  final Value<double> costPrice;
  final Value<double> minStockAlert;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.unitOfMeasurement = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.minStockAlert = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String unitOfMeasurement,
    this.currentStock = const Value.absent(),
    required double costPrice,
    this.minStockAlert = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        unitOfMeasurement = Value(unitOfMeasurement),
        costPrice = Value(costPrice);
  static Insertable<Ingredient> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? unitOfMeasurement,
    Expression<double>? currentStock,
    Expression<double>? costPrice,
    Expression<double>? minStockAlert,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (unitOfMeasurement != null) 'unit_of_measurement': unitOfMeasurement,
      if (currentStock != null) 'current_stock': currentStock,
      if (costPrice != null) 'cost_price': costPrice,
      if (minStockAlert != null) 'min_stock_alert': minStockAlert,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  IngredientsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? unitOfMeasurement,
      Value<double>? currentStock,
      Value<double>? costPrice,
      Value<double>? minStockAlert,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return IngredientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
      currentStock: currentStock ?? this.currentStock,
      costPrice: costPrice ?? this.costPrice,
      minStockAlert: minStockAlert ?? this.minStockAlert,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (unitOfMeasurement.present) {
      map['unit_of_measurement'] = Variable<String>(unitOfMeasurement.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<double>(currentStock.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (minStockAlert.present) {
      map['min_stock_alert'] = Variable<double>(minStockAlert.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unitOfMeasurement: $unitOfMeasurement, ')
          ..write('currentStock: $currentStock, ')
          ..write('costPrice: $costPrice, ')
          ..write('minStockAlert: $minStockAlert, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MealsTable extends Meals with TableInfo<$MealsTable, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _sellingPriceMeta =
      const VerificationMeta('sellingPrice');
  @override
  late final GeneratedColumn<double> sellingPrice = GeneratedColumn<double>(
      'selling_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, sellingPrice, category, isActive, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(Insertable<Meal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('selling_price')) {
      context.handle(
          _sellingPriceMeta,
          sellingPrice.isAcceptableOrUnknown(
              data['selling_price']!, _sellingPriceMeta));
    } else if (isInserting) {
      context.missing(_sellingPriceMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sellingPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}selling_price'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class Meal extends DataClass implements Insertable<Meal> {
  final int id;
  final String name;
  final double sellingPrice;
  final String category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Meal(
      {required this.id,
      required this.name,
      required this.sellingPrice,
      required this.category,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['selling_price'] = Variable<double>(sellingPrice);
    map['category'] = Variable<String>(category);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      name: Value(name),
      sellingPrice: Value(sellingPrice),
      category: Value(category),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Meal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sellingPrice: serializer.fromJson<double>(json['sellingPrice']),
      category: serializer.fromJson<String>(json['category']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sellingPrice': serializer.toJson<double>(sellingPrice),
      'category': serializer.toJson<String>(category),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Meal copyWith(
          {int? id,
          String? name,
          double? sellingPrice,
          String? category,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Meal(
        id: id ?? this.id,
        name: name ?? this.name,
        sellingPrice: sellingPrice ?? this.sellingPrice,
        category: category ?? this.category,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      category: data.category.present ? data.category.value : this.category,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('category: $category, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, sellingPrice, category, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.id == this.id &&
          other.name == this.name &&
          other.sellingPrice == this.sellingPrice &&
          other.category == this.category &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> sellingPrice;
  final Value<String> category;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.category = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double sellingPrice,
    required String category,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        sellingPrice = Value(sellingPrice),
        category = Value(category);
  static Insertable<Meal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? sellingPrice,
    Expression<String>? category,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (category != null) 'category': category,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MealsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? sellingPrice,
      Value<String>? category,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MealsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (sellingPrice.present) {
      map['selling_price'] = Variable<double>(sellingPrice.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('category: $category, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<int> mealId = GeneratedColumn<int>(
      'meal_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES meals (id)'));
  static const VerificationMeta _ingredientIdMeta =
      const VerificationMeta('ingredientId');
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
      'ingredient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES ingredients (id)'));
  static const VerificationMeta _quantityRequiredMeta =
      const VerificationMeta('quantityRequired');
  @override
  late final GeneratedColumn<double> quantityRequired = GeneratedColumn<double>(
      'quantity_required', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, mealId, ingredientId, quantityRequired];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(Insertable<Recipe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_id')) {
      context.handle(_mealIdMeta,
          mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta));
    } else if (isInserting) {
      context.missing(_mealIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
          _ingredientIdMeta,
          ingredientId.isAcceptableOrUnknown(
              data['ingredient_id']!, _ingredientIdMeta));
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('quantity_required')) {
      context.handle(
          _quantityRequiredMeta,
          quantityRequired.isAcceptableOrUnknown(
              data['quantity_required']!, _quantityRequiredMeta));
    } else if (isInserting) {
      context.missing(_quantityRequiredMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {mealId, ingredientId},
      ];
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      mealId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meal_id'])!,
      ingredientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingredient_id'])!,
      quantityRequired: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}quantity_required'])!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final int id;
  final int mealId;
  final int ingredientId;
  final double quantityRequired;
  const Recipe(
      {required this.id,
      required this.mealId,
      required this.ingredientId,
      required this.quantityRequired});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_id'] = Variable<int>(mealId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    map['quantity_required'] = Variable<double>(quantityRequired);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      mealId: Value(mealId),
      ingredientId: Value(ingredientId),
      quantityRequired: Value(quantityRequired),
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<int>(json['id']),
      mealId: serializer.fromJson<int>(json['mealId']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
      quantityRequired: serializer.fromJson<double>(json['quantityRequired']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealId': serializer.toJson<int>(mealId),
      'ingredientId': serializer.toJson<int>(ingredientId),
      'quantityRequired': serializer.toJson<double>(quantityRequired),
    };
  }

  Recipe copyWith(
          {int? id,
          int? mealId,
          int? ingredientId,
          double? quantityRequired}) =>
      Recipe(
        id: id ?? this.id,
        mealId: mealId ?? this.mealId,
        ingredientId: ingredientId ?? this.ingredientId,
        quantityRequired: quantityRequired ?? this.quantityRequired,
      );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      quantityRequired: data.quantityRequired.present
          ? data.quantityRequired.value
          : this.quantityRequired,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantityRequired: $quantityRequired')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mealId, ingredientId, quantityRequired);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.mealId == this.mealId &&
          other.ingredientId == this.ingredientId &&
          other.quantityRequired == this.quantityRequired);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<int> id;
  final Value<int> mealId;
  final Value<int> ingredientId;
  final Value<double> quantityRequired;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.mealId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.quantityRequired = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required int mealId,
    required int ingredientId,
    required double quantityRequired,
  })  : mealId = Value(mealId),
        ingredientId = Value(ingredientId),
        quantityRequired = Value(quantityRequired);
  static Insertable<Recipe> custom({
    Expression<int>? id,
    Expression<int>? mealId,
    Expression<int>? ingredientId,
    Expression<double>? quantityRequired,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealId != null) 'meal_id': mealId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (quantityRequired != null) 'quantity_required': quantityRequired,
    });
  }

  RecipesCompanion copyWith(
      {Value<int>? id,
      Value<int>? mealId,
      Value<int>? ingredientId,
      Value<double>? quantityRequired}) {
    return RecipesCompanion(
      id: id ?? this.id,
      mealId: mealId ?? this.mealId,
      ingredientId: ingredientId ?? this.ingredientId,
      quantityRequired: quantityRequired ?? this.quantityRequired,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<int>(mealId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (quantityRequired.present) {
      map['quantity_required'] = Variable<double>(quantityRequired.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantityRequired: $quantityRequired')
          ..write(')'))
        .toString();
  }
}

class $ShiftsTable extends Shifts with TableInfo<$ShiftsTable, Shift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _cashierIdMeta =
      const VerificationMeta('cashierId');
  @override
  late final GeneratedColumn<int> cashierId = GeneratedColumn<int>(
      'cashier_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('open'));
  static const VerificationMeta _startingCashMeta =
      const VerificationMeta('startingCash');
  @override
  late final GeneratedColumn<double> startingCash = GeneratedColumn<double>(
      'starting_cash', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _expectedClosingCashMeta =
      const VerificationMeta('expectedClosingCash');
  @override
  late final GeneratedColumn<double> expectedClosingCash =
      GeneratedColumn<double>('expected_closing_cash', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _actualClosingCashMeta =
      const VerificationMeta('actualClosingCash');
  @override
  late final GeneratedColumn<double> actualClosingCash =
      GeneratedColumn<double>('actual_closing_cash', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _varianceMeta =
      const VerificationMeta('variance');
  @override
  late final GeneratedColumn<double> variance = GeneratedColumn<double>(
      'variance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _totalSalesMeta =
      const VerificationMeta('totalSales');
  @override
  late final GeneratedColumn<double> totalSales = GeneratedColumn<double>(
      'total_sales', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalPurchasesMeta =
      const VerificationMeta('totalPurchases');
  @override
  late final GeneratedColumn<double> totalPurchases = GeneratedColumn<double>(
      'total_purchases', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalCashInMeta =
      const VerificationMeta('totalCashIn');
  @override
  late final GeneratedColumn<double> totalCashIn = GeneratedColumn<double>(
      'total_cash_in', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalCashOutMeta =
      const VerificationMeta('totalCashOut');
  @override
  late final GeneratedColumn<double> totalCashOut = GeneratedColumn<double>(
      'total_cash_out', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _openedAtMeta =
      const VerificationMeta('openedAt');
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
      'opened_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _closedAtMeta =
      const VerificationMeta('closedAt');
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
      'closed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cashierId,
        status,
        startingCash,
        expectedClosingCash,
        actualClosingCash,
        variance,
        totalSales,
        totalPurchases,
        totalCashIn,
        totalCashOut,
        openedAt,
        closedAt,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts';
  @override
  VerificationContext validateIntegrity(Insertable<Shift> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cashier_id')) {
      context.handle(_cashierIdMeta,
          cashierId.isAcceptableOrUnknown(data['cashier_id']!, _cashierIdMeta));
    } else if (isInserting) {
      context.missing(_cashierIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('starting_cash')) {
      context.handle(
          _startingCashMeta,
          startingCash.isAcceptableOrUnknown(
              data['starting_cash']!, _startingCashMeta));
    } else if (isInserting) {
      context.missing(_startingCashMeta);
    }
    if (data.containsKey('expected_closing_cash')) {
      context.handle(
          _expectedClosingCashMeta,
          expectedClosingCash.isAcceptableOrUnknown(
              data['expected_closing_cash']!, _expectedClosingCashMeta));
    }
    if (data.containsKey('actual_closing_cash')) {
      context.handle(
          _actualClosingCashMeta,
          actualClosingCash.isAcceptableOrUnknown(
              data['actual_closing_cash']!, _actualClosingCashMeta));
    }
    if (data.containsKey('variance')) {
      context.handle(_varianceMeta,
          variance.isAcceptableOrUnknown(data['variance']!, _varianceMeta));
    }
    if (data.containsKey('total_sales')) {
      context.handle(
          _totalSalesMeta,
          totalSales.isAcceptableOrUnknown(
              data['total_sales']!, _totalSalesMeta));
    }
    if (data.containsKey('total_purchases')) {
      context.handle(
          _totalPurchasesMeta,
          totalPurchases.isAcceptableOrUnknown(
              data['total_purchases']!, _totalPurchasesMeta));
    }
    if (data.containsKey('total_cash_in')) {
      context.handle(
          _totalCashInMeta,
          totalCashIn.isAcceptableOrUnknown(
              data['total_cash_in']!, _totalCashInMeta));
    }
    if (data.containsKey('total_cash_out')) {
      context.handle(
          _totalCashOutMeta,
          totalCashOut.isAcceptableOrUnknown(
              data['total_cash_out']!, _totalCashOutMeta));
    }
    if (data.containsKey('opened_at')) {
      context.handle(_openedAtMeta,
          openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta));
    }
    if (data.containsKey('closed_at')) {
      context.handle(_closedAtMeta,
          closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shift(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cashierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cashier_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      startingCash: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}starting_cash'])!,
      expectedClosingCash: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}expected_closing_cash']),
      actualClosingCash: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}actual_closing_cash']),
      variance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}variance']),
      totalSales: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_sales'])!,
      totalPurchases: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_purchases'])!,
      totalCashIn: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_cash_in'])!,
      totalCashOut: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_cash_out'])!,
      openedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}opened_at'])!,
      closedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}closed_at']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $ShiftsTable createAlias(String alias) {
    return $ShiftsTable(attachedDatabase, alias);
  }
}

class Shift extends DataClass implements Insertable<Shift> {
  final int id;
  final int cashierId;
  final String status;
  final double startingCash;
  final double? expectedClosingCash;
  final double? actualClosingCash;
  final double? variance;
  final double totalSales;
  final double totalPurchases;
  final double totalCashIn;
  final double totalCashOut;
  final DateTime openedAt;
  final DateTime? closedAt;
  final String? notes;
  const Shift(
      {required this.id,
      required this.cashierId,
      required this.status,
      required this.startingCash,
      this.expectedClosingCash,
      this.actualClosingCash,
      this.variance,
      required this.totalSales,
      required this.totalPurchases,
      required this.totalCashIn,
      required this.totalCashOut,
      required this.openedAt,
      this.closedAt,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cashier_id'] = Variable<int>(cashierId);
    map['status'] = Variable<String>(status);
    map['starting_cash'] = Variable<double>(startingCash);
    if (!nullToAbsent || expectedClosingCash != null) {
      map['expected_closing_cash'] = Variable<double>(expectedClosingCash);
    }
    if (!nullToAbsent || actualClosingCash != null) {
      map['actual_closing_cash'] = Variable<double>(actualClosingCash);
    }
    if (!nullToAbsent || variance != null) {
      map['variance'] = Variable<double>(variance);
    }
    map['total_sales'] = Variable<double>(totalSales);
    map['total_purchases'] = Variable<double>(totalPurchases);
    map['total_cash_in'] = Variable<double>(totalCashIn);
    map['total_cash_out'] = Variable<double>(totalCashOut);
    map['opened_at'] = Variable<DateTime>(openedAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ShiftsCompanion toCompanion(bool nullToAbsent) {
    return ShiftsCompanion(
      id: Value(id),
      cashierId: Value(cashierId),
      status: Value(status),
      startingCash: Value(startingCash),
      expectedClosingCash: expectedClosingCash == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedClosingCash),
      actualClosingCash: actualClosingCash == null && nullToAbsent
          ? const Value.absent()
          : Value(actualClosingCash),
      variance: variance == null && nullToAbsent
          ? const Value.absent()
          : Value(variance),
      totalSales: Value(totalSales),
      totalPurchases: Value(totalPurchases),
      totalCashIn: Value(totalCashIn),
      totalCashOut: Value(totalCashOut),
      openedAt: Value(openedAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Shift.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shift(
      id: serializer.fromJson<int>(json['id']),
      cashierId: serializer.fromJson<int>(json['cashierId']),
      status: serializer.fromJson<String>(json['status']),
      startingCash: serializer.fromJson<double>(json['startingCash']),
      expectedClosingCash:
          serializer.fromJson<double?>(json['expectedClosingCash']),
      actualClosingCash:
          serializer.fromJson<double?>(json['actualClosingCash']),
      variance: serializer.fromJson<double?>(json['variance']),
      totalSales: serializer.fromJson<double>(json['totalSales']),
      totalPurchases: serializer.fromJson<double>(json['totalPurchases']),
      totalCashIn: serializer.fromJson<double>(json['totalCashIn']),
      totalCashOut: serializer.fromJson<double>(json['totalCashOut']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cashierId': serializer.toJson<int>(cashierId),
      'status': serializer.toJson<String>(status),
      'startingCash': serializer.toJson<double>(startingCash),
      'expectedClosingCash': serializer.toJson<double?>(expectedClosingCash),
      'actualClosingCash': serializer.toJson<double?>(actualClosingCash),
      'variance': serializer.toJson<double?>(variance),
      'totalSales': serializer.toJson<double>(totalSales),
      'totalPurchases': serializer.toJson<double>(totalPurchases),
      'totalCashIn': serializer.toJson<double>(totalCashIn),
      'totalCashOut': serializer.toJson<double>(totalCashOut),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Shift copyWith(
          {int? id,
          int? cashierId,
          String? status,
          double? startingCash,
          Value<double?> expectedClosingCash = const Value.absent(),
          Value<double?> actualClosingCash = const Value.absent(),
          Value<double?> variance = const Value.absent(),
          double? totalSales,
          double? totalPurchases,
          double? totalCashIn,
          double? totalCashOut,
          DateTime? openedAt,
          Value<DateTime?> closedAt = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      Shift(
        id: id ?? this.id,
        cashierId: cashierId ?? this.cashierId,
        status: status ?? this.status,
        startingCash: startingCash ?? this.startingCash,
        expectedClosingCash: expectedClosingCash.present
            ? expectedClosingCash.value
            : this.expectedClosingCash,
        actualClosingCash: actualClosingCash.present
            ? actualClosingCash.value
            : this.actualClosingCash,
        variance: variance.present ? variance.value : this.variance,
        totalSales: totalSales ?? this.totalSales,
        totalPurchases: totalPurchases ?? this.totalPurchases,
        totalCashIn: totalCashIn ?? this.totalCashIn,
        totalCashOut: totalCashOut ?? this.totalCashOut,
        openedAt: openedAt ?? this.openedAt,
        closedAt: closedAt.present ? closedAt.value : this.closedAt,
        notes: notes.present ? notes.value : this.notes,
      );
  Shift copyWithCompanion(ShiftsCompanion data) {
    return Shift(
      id: data.id.present ? data.id.value : this.id,
      cashierId: data.cashierId.present ? data.cashierId.value : this.cashierId,
      status: data.status.present ? data.status.value : this.status,
      startingCash: data.startingCash.present
          ? data.startingCash.value
          : this.startingCash,
      expectedClosingCash: data.expectedClosingCash.present
          ? data.expectedClosingCash.value
          : this.expectedClosingCash,
      actualClosingCash: data.actualClosingCash.present
          ? data.actualClosingCash.value
          : this.actualClosingCash,
      variance: data.variance.present ? data.variance.value : this.variance,
      totalSales:
          data.totalSales.present ? data.totalSales.value : this.totalSales,
      totalPurchases: data.totalPurchases.present
          ? data.totalPurchases.value
          : this.totalPurchases,
      totalCashIn:
          data.totalCashIn.present ? data.totalCashIn.value : this.totalCashIn,
      totalCashOut: data.totalCashOut.present
          ? data.totalCashOut.value
          : this.totalCashOut,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shift(')
          ..write('id: $id, ')
          ..write('cashierId: $cashierId, ')
          ..write('status: $status, ')
          ..write('startingCash: $startingCash, ')
          ..write('expectedClosingCash: $expectedClosingCash, ')
          ..write('actualClosingCash: $actualClosingCash, ')
          ..write('variance: $variance, ')
          ..write('totalSales: $totalSales, ')
          ..write('totalPurchases: $totalPurchases, ')
          ..write('totalCashIn: $totalCashIn, ')
          ..write('totalCashOut: $totalCashOut, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      cashierId,
      status,
      startingCash,
      expectedClosingCash,
      actualClosingCash,
      variance,
      totalSales,
      totalPurchases,
      totalCashIn,
      totalCashOut,
      openedAt,
      closedAt,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shift &&
          other.id == this.id &&
          other.cashierId == this.cashierId &&
          other.status == this.status &&
          other.startingCash == this.startingCash &&
          other.expectedClosingCash == this.expectedClosingCash &&
          other.actualClosingCash == this.actualClosingCash &&
          other.variance == this.variance &&
          other.totalSales == this.totalSales &&
          other.totalPurchases == this.totalPurchases &&
          other.totalCashIn == this.totalCashIn &&
          other.totalCashOut == this.totalCashOut &&
          other.openedAt == this.openedAt &&
          other.closedAt == this.closedAt &&
          other.notes == this.notes);
}

class ShiftsCompanion extends UpdateCompanion<Shift> {
  final Value<int> id;
  final Value<int> cashierId;
  final Value<String> status;
  final Value<double> startingCash;
  final Value<double?> expectedClosingCash;
  final Value<double?> actualClosingCash;
  final Value<double?> variance;
  final Value<double> totalSales;
  final Value<double> totalPurchases;
  final Value<double> totalCashIn;
  final Value<double> totalCashOut;
  final Value<DateTime> openedAt;
  final Value<DateTime?> closedAt;
  final Value<String?> notes;
  const ShiftsCompanion({
    this.id = const Value.absent(),
    this.cashierId = const Value.absent(),
    this.status = const Value.absent(),
    this.startingCash = const Value.absent(),
    this.expectedClosingCash = const Value.absent(),
    this.actualClosingCash = const Value.absent(),
    this.variance = const Value.absent(),
    this.totalSales = const Value.absent(),
    this.totalPurchases = const Value.absent(),
    this.totalCashIn = const Value.absent(),
    this.totalCashOut = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ShiftsCompanion.insert({
    this.id = const Value.absent(),
    required int cashierId,
    this.status = const Value.absent(),
    required double startingCash,
    this.expectedClosingCash = const Value.absent(),
    this.actualClosingCash = const Value.absent(),
    this.variance = const Value.absent(),
    this.totalSales = const Value.absent(),
    this.totalPurchases = const Value.absent(),
    this.totalCashIn = const Value.absent(),
    this.totalCashOut = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.notes = const Value.absent(),
  })  : cashierId = Value(cashierId),
        startingCash = Value(startingCash);
  static Insertable<Shift> custom({
    Expression<int>? id,
    Expression<int>? cashierId,
    Expression<String>? status,
    Expression<double>? startingCash,
    Expression<double>? expectedClosingCash,
    Expression<double>? actualClosingCash,
    Expression<double>? variance,
    Expression<double>? totalSales,
    Expression<double>? totalPurchases,
    Expression<double>? totalCashIn,
    Expression<double>? totalCashOut,
    Expression<DateTime>? openedAt,
    Expression<DateTime>? closedAt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cashierId != null) 'cashier_id': cashierId,
      if (status != null) 'status': status,
      if (startingCash != null) 'starting_cash': startingCash,
      if (expectedClosingCash != null)
        'expected_closing_cash': expectedClosingCash,
      if (actualClosingCash != null) 'actual_closing_cash': actualClosingCash,
      if (variance != null) 'variance': variance,
      if (totalSales != null) 'total_sales': totalSales,
      if (totalPurchases != null) 'total_purchases': totalPurchases,
      if (totalCashIn != null) 'total_cash_in': totalCashIn,
      if (totalCashOut != null) 'total_cash_out': totalCashOut,
      if (openedAt != null) 'opened_at': openedAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (notes != null) 'notes': notes,
    });
  }

  ShiftsCompanion copyWith(
      {Value<int>? id,
      Value<int>? cashierId,
      Value<String>? status,
      Value<double>? startingCash,
      Value<double?>? expectedClosingCash,
      Value<double?>? actualClosingCash,
      Value<double?>? variance,
      Value<double>? totalSales,
      Value<double>? totalPurchases,
      Value<double>? totalCashIn,
      Value<double>? totalCashOut,
      Value<DateTime>? openedAt,
      Value<DateTime?>? closedAt,
      Value<String?>? notes}) {
    return ShiftsCompanion(
      id: id ?? this.id,
      cashierId: cashierId ?? this.cashierId,
      status: status ?? this.status,
      startingCash: startingCash ?? this.startingCash,
      expectedClosingCash: expectedClosingCash ?? this.expectedClosingCash,
      actualClosingCash: actualClosingCash ?? this.actualClosingCash,
      variance: variance ?? this.variance,
      totalSales: totalSales ?? this.totalSales,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      totalCashIn: totalCashIn ?? this.totalCashIn,
      totalCashOut: totalCashOut ?? this.totalCashOut,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cashierId.present) {
      map['cashier_id'] = Variable<int>(cashierId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startingCash.present) {
      map['starting_cash'] = Variable<double>(startingCash.value);
    }
    if (expectedClosingCash.present) {
      map['expected_closing_cash'] =
          Variable<double>(expectedClosingCash.value);
    }
    if (actualClosingCash.present) {
      map['actual_closing_cash'] = Variable<double>(actualClosingCash.value);
    }
    if (variance.present) {
      map['variance'] = Variable<double>(variance.value);
    }
    if (totalSales.present) {
      map['total_sales'] = Variable<double>(totalSales.value);
    }
    if (totalPurchases.present) {
      map['total_purchases'] = Variable<double>(totalPurchases.value);
    }
    if (totalCashIn.present) {
      map['total_cash_in'] = Variable<double>(totalCashIn.value);
    }
    if (totalCashOut.present) {
      map['total_cash_out'] = Variable<double>(totalCashOut.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsCompanion(')
          ..write('id: $id, ')
          ..write('cashierId: $cashierId, ')
          ..write('status: $status, ')
          ..write('startingCash: $startingCash, ')
          ..write('expectedClosingCash: $expectedClosingCash, ')
          ..write('actualClosingCash: $actualClosingCash, ')
          ..write('variance: $variance, ')
          ..write('totalSales: $totalSales, ')
          ..write('totalPurchases: $totalPurchases, ')
          ..write('totalCashIn: $totalCashIn, ')
          ..write('totalCashOut: $totalCashOut, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $TablesTable extends Tables
    with TableInfo<$TablesTable, RestaurantTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('available'));
  static const VerificationMeta _seatsCountMeta =
      const VerificationMeta('seatsCount');
  @override
  late final GeneratedColumn<int> seatsCount = GeneratedColumn<int>(
      'seats_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  @override
  List<GeneratedColumn> get $columns => [id, name, status, seatsCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tables';
  @override
  VerificationContext validateIntegrity(Insertable<RestaurantTable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('seats_count')) {
      context.handle(
          _seatsCountMeta,
          seatsCount.isAcceptableOrUnknown(
              data['seats_count']!, _seatsCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestaurantTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestaurantTable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      seatsCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}seats_count'])!,
    );
  }

  @override
  $TablesTable createAlias(String alias) {
    return $TablesTable(attachedDatabase, alias);
  }
}

class RestaurantTable extends DataClass implements Insertable<RestaurantTable> {
  final int id;
  final String name;
  final String status;
  final int seatsCount;
  const RestaurantTable(
      {required this.id,
      required this.name,
      required this.status,
      required this.seatsCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['seats_count'] = Variable<int>(seatsCount);
    return map;
  }

  TablesCompanion toCompanion(bool nullToAbsent) {
    return TablesCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      seatsCount: Value(seatsCount),
    );
  }

  factory RestaurantTable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestaurantTable(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      seatsCount: serializer.fromJson<int>(json['seatsCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'seatsCount': serializer.toJson<int>(seatsCount),
    };
  }

  RestaurantTable copyWith(
          {int? id, String? name, String? status, int? seatsCount}) =>
      RestaurantTable(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
        seatsCount: seatsCount ?? this.seatsCount,
      );
  RestaurantTable copyWithCompanion(TablesCompanion data) {
    return RestaurantTable(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      seatsCount:
          data.seatsCount.present ? data.seatsCount.value : this.seatsCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestaurantTable(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('seatsCount: $seatsCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, status, seatsCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestaurantTable &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status &&
          other.seatsCount == this.seatsCount);
}

class TablesCompanion extends UpdateCompanion<RestaurantTable> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> status;
  final Value<int> seatsCount;
  const TablesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.seatsCount = const Value.absent(),
  });
  TablesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.status = const Value.absent(),
    this.seatsCount = const Value.absent(),
  }) : name = Value(name);
  static Insertable<RestaurantTable> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<int>? seatsCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (seatsCount != null) 'seats_count': seatsCount,
    });
  }

  TablesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? status,
      Value<int>? seatsCount}) {
    return TablesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      seatsCount: seatsCount ?? this.seatsCount,
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
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (seatsCount.present) {
      map['seats_count'] = Variable<int>(seatsCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TablesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('seatsCount: $seatsCount')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _shiftIdMeta =
      const VerificationMeta('shiftId');
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
      'shift_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES shifts (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _subtotalAmountMeta =
      const VerificationMeta('subtotalAmount');
  @override
  late final GeneratedColumn<double> subtotalAmount = GeneratedColumn<double>(
      'subtotal_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
      'discount_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _taxAmountMeta =
      const VerificationMeta('taxAmount');
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
      'tax_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _orderTypeMeta =
      const VerificationMeta('orderType');
  @override
  late final GeneratedColumn<String> orderType = GeneratedColumn<String>(
      'order_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('takeaway'));
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _tableIdMeta =
      const VerificationMeta('tableId');
  @override
  late final GeneratedColumn<int> tableId = GeneratedColumn<int>(
      'table_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tables (id)'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        shiftId,
        type,
        totalAmount,
        subtotalAmount,
        discountAmount,
        taxAmount,
        orderType,
        paymentMethod,
        tableId,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(_shiftIdMeta,
          shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('subtotal_amount')) {
      context.handle(
          _subtotalAmountMeta,
          subtotalAmount.isAcceptableOrUnknown(
              data['subtotal_amount']!, _subtotalAmountMeta));
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount']!, _discountAmountMeta));
    }
    if (data.containsKey('tax_amount')) {
      context.handle(_taxAmountMeta,
          taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta));
    }
    if (data.containsKey('order_type')) {
      context.handle(_orderTypeMeta,
          orderType.isAcceptableOrUnknown(data['order_type']!, _orderTypeMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('table_id')) {
      context.handle(_tableIdMeta,
          tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      shiftId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shift_id']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      subtotalAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}subtotal_amount'])!,
      discountAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_amount'])!,
      taxAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_amount'])!,
      orderType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_type'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      tableId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}table_id']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final int userId;
  final int? shiftId;
  final String type;
  final double totalAmount;
  final double subtotalAmount;
  final double discountAmount;
  final double taxAmount;
  final String orderType;
  final String paymentMethod;
  final int? tableId;
  final String? notes;
  final DateTime createdAt;
  const Transaction(
      {required this.id,
      required this.userId,
      this.shiftId,
      required this.type,
      required this.totalAmount,
      required this.subtotalAmount,
      required this.discountAmount,
      required this.taxAmount,
      required this.orderType,
      required this.paymentMethod,
      this.tableId,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<int>(shiftId);
    }
    map['type'] = Variable<String>(type);
    map['total_amount'] = Variable<double>(totalAmount);
    map['subtotal_amount'] = Variable<double>(subtotalAmount);
    map['discount_amount'] = Variable<double>(discountAmount);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['order_type'] = Variable<String>(orderType);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || tableId != null) {
      map['table_id'] = Variable<int>(tableId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      userId: Value(userId),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      type: Value(type),
      totalAmount: Value(totalAmount),
      subtotalAmount: Value(subtotalAmount),
      discountAmount: Value(discountAmount),
      taxAmount: Value(taxAmount),
      orderType: Value(orderType),
      paymentMethod: Value(paymentMethod),
      tableId: tableId == null && nullToAbsent
          ? const Value.absent()
          : Value(tableId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      shiftId: serializer.fromJson<int?>(json['shiftId']),
      type: serializer.fromJson<String>(json['type']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      subtotalAmount: serializer.fromJson<double>(json['subtotalAmount']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      orderType: serializer.fromJson<String>(json['orderType']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      tableId: serializer.fromJson<int?>(json['tableId']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'shiftId': serializer.toJson<int?>(shiftId),
      'type': serializer.toJson<String>(type),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'subtotalAmount': serializer.toJson<double>(subtotalAmount),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'orderType': serializer.toJson<String>(orderType),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'tableId': serializer.toJson<int?>(tableId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Transaction copyWith(
          {int? id,
          int? userId,
          Value<int?> shiftId = const Value.absent(),
          String? type,
          double? totalAmount,
          double? subtotalAmount,
          double? discountAmount,
          double? taxAmount,
          String? orderType,
          String? paymentMethod,
          Value<int?> tableId = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      Transaction(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        shiftId: shiftId.present ? shiftId.value : this.shiftId,
        type: type ?? this.type,
        totalAmount: totalAmount ?? this.totalAmount,
        subtotalAmount: subtotalAmount ?? this.subtotalAmount,
        discountAmount: discountAmount ?? this.discountAmount,
        taxAmount: taxAmount ?? this.taxAmount,
        orderType: orderType ?? this.orderType,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        tableId: tableId.present ? tableId.value : this.tableId,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      type: data.type.present ? data.type.value : this.type,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      subtotalAmount: data.subtotalAmount.present
          ? data.subtotalAmount.value
          : this.subtotalAmount,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      orderType: data.orderType.present ? data.orderType.value : this.orderType,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('shiftId: $shiftId, ')
          ..write('type: $type, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('subtotalAmount: $subtotalAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('orderType: $orderType, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('tableId: $tableId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      shiftId,
      type,
      totalAmount,
      subtotalAmount,
      discountAmount,
      taxAmount,
      orderType,
      paymentMethod,
      tableId,
      notes,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.shiftId == this.shiftId &&
          other.type == this.type &&
          other.totalAmount == this.totalAmount &&
          other.subtotalAmount == this.subtotalAmount &&
          other.discountAmount == this.discountAmount &&
          other.taxAmount == this.taxAmount &&
          other.orderType == this.orderType &&
          other.paymentMethod == this.paymentMethod &&
          other.tableId == this.tableId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int?> shiftId;
  final Value<String> type;
  final Value<double> totalAmount;
  final Value<double> subtotalAmount;
  final Value<double> discountAmount;
  final Value<double> taxAmount;
  final Value<String> orderType;
  final Value<String> paymentMethod;
  final Value<int?> tableId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.type = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.subtotalAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.orderType = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.tableId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.shiftId = const Value.absent(),
    required String type,
    required double totalAmount,
    this.subtotalAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.orderType = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.tableId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        type = Value(type),
        totalAmount = Value(totalAmount);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? shiftId,
    Expression<String>? type,
    Expression<double>? totalAmount,
    Expression<double>? subtotalAmount,
    Expression<double>? discountAmount,
    Expression<double>? taxAmount,
    Expression<String>? orderType,
    Expression<String>? paymentMethod,
    Expression<int>? tableId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (shiftId != null) 'shift_id': shiftId,
      if (type != null) 'type': type,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (subtotalAmount != null) 'subtotal_amount': subtotalAmount,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (orderType != null) 'order_type': orderType,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (tableId != null) 'table_id': tableId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int?>? shiftId,
      Value<String>? type,
      Value<double>? totalAmount,
      Value<double>? subtotalAmount,
      Value<double>? discountAmount,
      Value<double>? taxAmount,
      Value<String>? orderType,
      Value<String>? paymentMethod,
      Value<int?>? tableId,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      shiftId: shiftId ?? this.shiftId,
      type: type ?? this.type,
      totalAmount: totalAmount ?? this.totalAmount,
      subtotalAmount: subtotalAmount ?? this.subtotalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      orderType: orderType ?? this.orderType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      tableId: tableId ?? this.tableId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (subtotalAmount.present) {
      map['subtotal_amount'] = Variable<double>(subtotalAmount.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(orderType.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (tableId.present) {
      map['table_id'] = Variable<int>(tableId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('shiftId: $shiftId, ')
          ..write('type: $type, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('subtotalAmount: $subtotalAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('orderType: $orderType, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('tableId: $tableId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionItemsTable extends TransactionItems
    with TableInfo<$TransactionItemsTable, TransactionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES transactions (id)'));
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<int> mealId = GeneratedColumn<int>(
      'meal_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES meals (id)'));
  static const VerificationMeta _ingredientIdMeta =
      const VerificationMeta('ingredientId');
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
      'ingredient_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES ingredients (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceAtTimeMeta =
      const VerificationMeta('priceAtTime');
  @override
  late final GeneratedColumn<double> priceAtTime = GeneratedColumn<double>(
      'price_at_time', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _itemTypeMeta =
      const VerificationMeta('itemType');
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
      'item_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transactionId,
        mealId,
        ingredientId,
        quantity,
        priceAtTime,
        itemType
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_items';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('meal_id')) {
      context.handle(_mealIdMeta,
          mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta));
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
          _ingredientIdMeta,
          ingredientId.isAcceptableOrUnknown(
              data['ingredient_id']!, _ingredientIdMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price_at_time')) {
      context.handle(
          _priceAtTimeMeta,
          priceAtTime.isAcceptableOrUnknown(
              data['price_at_time']!, _priceAtTimeMeta));
    } else if (isInserting) {
      context.missing(_priceAtTimeMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(_itemTypeMeta,
          itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta));
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transaction_id'])!,
      mealId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meal_id']),
      ingredientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingredient_id']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      priceAtTime: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_at_time'])!,
      itemType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_type'])!,
    );
  }

  @override
  $TransactionItemsTable createAlias(String alias) {
    return $TransactionItemsTable(attachedDatabase, alias);
  }
}

class TransactionItem extends DataClass implements Insertable<TransactionItem> {
  final int id;
  final int transactionId;
  final int? mealId;
  final int? ingredientId;
  final double quantity;
  final double priceAtTime;
  final String itemType;
  const TransactionItem(
      {required this.id,
      required this.transactionId,
      this.mealId,
      this.ingredientId,
      required this.quantity,
      required this.priceAtTime,
      required this.itemType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    if (!nullToAbsent || mealId != null) {
      map['meal_id'] = Variable<int>(mealId);
    }
    if (!nullToAbsent || ingredientId != null) {
      map['ingredient_id'] = Variable<int>(ingredientId);
    }
    map['quantity'] = Variable<double>(quantity);
    map['price_at_time'] = Variable<double>(priceAtTime);
    map['item_type'] = Variable<String>(itemType);
    return map;
  }

  TransactionItemsCompanion toCompanion(bool nullToAbsent) {
    return TransactionItemsCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      mealId:
          mealId == null && nullToAbsent ? const Value.absent() : Value(mealId),
      ingredientId: ingredientId == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredientId),
      quantity: Value(quantity),
      priceAtTime: Value(priceAtTime),
      itemType: Value(itemType),
    );
  }

  factory TransactionItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionItem(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      mealId: serializer.fromJson<int?>(json['mealId']),
      ingredientId: serializer.fromJson<int?>(json['ingredientId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      priceAtTime: serializer.fromJson<double>(json['priceAtTime']),
      itemType: serializer.fromJson<String>(json['itemType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'mealId': serializer.toJson<int?>(mealId),
      'ingredientId': serializer.toJson<int?>(ingredientId),
      'quantity': serializer.toJson<double>(quantity),
      'priceAtTime': serializer.toJson<double>(priceAtTime),
      'itemType': serializer.toJson<String>(itemType),
    };
  }

  TransactionItem copyWith(
          {int? id,
          int? transactionId,
          Value<int?> mealId = const Value.absent(),
          Value<int?> ingredientId = const Value.absent(),
          double? quantity,
          double? priceAtTime,
          String? itemType}) =>
      TransactionItem(
        id: id ?? this.id,
        transactionId: transactionId ?? this.transactionId,
        mealId: mealId.present ? mealId.value : this.mealId,
        ingredientId:
            ingredientId.present ? ingredientId.value : this.ingredientId,
        quantity: quantity ?? this.quantity,
        priceAtTime: priceAtTime ?? this.priceAtTime,
        itemType: itemType ?? this.itemType,
      );
  TransactionItem copyWithCompanion(TransactionItemsCompanion data) {
    return TransactionItem(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      priceAtTime:
          data.priceAtTime.present ? data.priceAtTime.value : this.priceAtTime,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItem(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('mealId: $mealId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantity: $quantity, ')
          ..write('priceAtTime: $priceAtTime, ')
          ..write('itemType: $itemType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, transactionId, mealId, ingredientId, quantity, priceAtTime, itemType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionItem &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.mealId == this.mealId &&
          other.ingredientId == this.ingredientId &&
          other.quantity == this.quantity &&
          other.priceAtTime == this.priceAtTime &&
          other.itemType == this.itemType);
}

class TransactionItemsCompanion extends UpdateCompanion<TransactionItem> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int?> mealId;
  final Value<int?> ingredientId;
  final Value<double> quantity;
  final Value<double> priceAtTime;
  final Value<String> itemType;
  const TransactionItemsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.mealId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.priceAtTime = const Value.absent(),
    this.itemType = const Value.absent(),
  });
  TransactionItemsCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    this.mealId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    required double quantity,
    required double priceAtTime,
    required String itemType,
  })  : transactionId = Value(transactionId),
        quantity = Value(quantity),
        priceAtTime = Value(priceAtTime),
        itemType = Value(itemType);
  static Insertable<TransactionItem> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? mealId,
    Expression<int>? ingredientId,
    Expression<double>? quantity,
    Expression<double>? priceAtTime,
    Expression<String>? itemType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (mealId != null) 'meal_id': mealId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (quantity != null) 'quantity': quantity,
      if (priceAtTime != null) 'price_at_time': priceAtTime,
      if (itemType != null) 'item_type': itemType,
    });
  }

  TransactionItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? transactionId,
      Value<int?>? mealId,
      Value<int?>? ingredientId,
      Value<double>? quantity,
      Value<double>? priceAtTime,
      Value<String>? itemType}) {
    return TransactionItemsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      mealId: mealId ?? this.mealId,
      ingredientId: ingredientId ?? this.ingredientId,
      quantity: quantity ?? this.quantity,
      priceAtTime: priceAtTime ?? this.priceAtTime,
      itemType: itemType ?? this.itemType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<int>(mealId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (priceAtTime.present) {
      map['price_at_time'] = Variable<double>(priceAtTime.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItemsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('mealId: $mealId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantity: $quantity, ')
          ..write('priceAtTime: $priceAtTime, ')
          ..write('itemType: $itemType')
          ..write(')'))
        .toString();
  }
}

class $PurchaseInvoicesTable extends PurchaseInvoices
    with TableInfo<$PurchaseInvoicesTable, PurchaseInvoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseInvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
      'invoice_number', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _supplierNameMeta =
      const VerificationMeta('supplierName');
  @override
  late final GeneratedColumn<String> supplierName = GeneratedColumn<String>(
      'supplier_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _shiftIdMeta =
      const VerificationMeta('shiftId');
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
      'shift_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES shifts (id)'));
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('completed'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        invoiceNumber,
        supplierName,
        userId,
        shiftId,
        totalAmount,
        notes,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_invoices';
  @override
  VerificationContext validateIntegrity(Insertable<PurchaseInvoice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('supplier_name')) {
      context.handle(
          _supplierNameMeta,
          supplierName.isAcceptableOrUnknown(
              data['supplier_name']!, _supplierNameMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(_shiftIdMeta,
          shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseInvoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseInvoice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_number'])!,
      supplierName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_name']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      shiftId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shift_id']),
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PurchaseInvoicesTable createAlias(String alias) {
    return $PurchaseInvoicesTable(attachedDatabase, alias);
  }
}

class PurchaseInvoice extends DataClass implements Insertable<PurchaseInvoice> {
  final int id;
  final String invoiceNumber;
  final String? supplierName;
  final int userId;
  final int? shiftId;
  final double totalAmount;
  final String? notes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PurchaseInvoice(
      {required this.id,
      required this.invoiceNumber,
      this.supplierName,
      required this.userId,
      this.shiftId,
      required this.totalAmount,
      this.notes,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    if (!nullToAbsent || supplierName != null) {
      map['supplier_name'] = Variable<String>(supplierName);
    }
    map['user_id'] = Variable<int>(userId);
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<int>(shiftId);
    }
    map['total_amount'] = Variable<double>(totalAmount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PurchaseInvoicesCompanion toCompanion(bool nullToAbsent) {
    return PurchaseInvoicesCompanion(
      id: Value(id),
      invoiceNumber: Value(invoiceNumber),
      supplierName: supplierName == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierName),
      userId: Value(userId),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      totalAmount: Value(totalAmount),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PurchaseInvoice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseInvoice(
      id: serializer.fromJson<int>(json['id']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      supplierName: serializer.fromJson<String?>(json['supplierName']),
      userId: serializer.fromJson<int>(json['userId']),
      shiftId: serializer.fromJson<int?>(json['shiftId']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'supplierName': serializer.toJson<String?>(supplierName),
      'userId': serializer.toJson<int>(userId),
      'shiftId': serializer.toJson<int?>(shiftId),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PurchaseInvoice copyWith(
          {int? id,
          String? invoiceNumber,
          Value<String?> supplierName = const Value.absent(),
          int? userId,
          Value<int?> shiftId = const Value.absent(),
          double? totalAmount,
          Value<String?> notes = const Value.absent(),
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      PurchaseInvoice(
        id: id ?? this.id,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        supplierName:
            supplierName.present ? supplierName.value : this.supplierName,
        userId: userId ?? this.userId,
        shiftId: shiftId.present ? shiftId.value : this.shiftId,
        totalAmount: totalAmount ?? this.totalAmount,
        notes: notes.present ? notes.value : this.notes,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PurchaseInvoice copyWithCompanion(PurchaseInvoicesCompanion data) {
    return PurchaseInvoice(
      id: data.id.present ? data.id.value : this.id,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      supplierName: data.supplierName.present
          ? data.supplierName.value
          : this.supplierName,
      userId: data.userId.present ? data.userId.value : this.userId,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseInvoice(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('supplierName: $supplierName, ')
          ..write('userId: $userId, ')
          ..write('shiftId: $shiftId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, invoiceNumber, supplierName, userId,
      shiftId, totalAmount, notes, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseInvoice &&
          other.id == this.id &&
          other.invoiceNumber == this.invoiceNumber &&
          other.supplierName == this.supplierName &&
          other.userId == this.userId &&
          other.shiftId == this.shiftId &&
          other.totalAmount == this.totalAmount &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PurchaseInvoicesCompanion extends UpdateCompanion<PurchaseInvoice> {
  final Value<int> id;
  final Value<String> invoiceNumber;
  final Value<String?> supplierName;
  final Value<int> userId;
  final Value<int?> shiftId;
  final Value<double> totalAmount;
  final Value<String?> notes;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PurchaseInvoicesCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.userId = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PurchaseInvoicesCompanion.insert({
    this.id = const Value.absent(),
    required String invoiceNumber,
    this.supplierName = const Value.absent(),
    required int userId,
    this.shiftId = const Value.absent(),
    required double totalAmount,
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : invoiceNumber = Value(invoiceNumber),
        userId = Value(userId),
        totalAmount = Value(totalAmount);
  static Insertable<PurchaseInvoice> custom({
    Expression<int>? id,
    Expression<String>? invoiceNumber,
    Expression<String>? supplierName,
    Expression<int>? userId,
    Expression<int>? shiftId,
    Expression<double>? totalAmount,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (supplierName != null) 'supplier_name': supplierName,
      if (userId != null) 'user_id': userId,
      if (shiftId != null) 'shift_id': shiftId,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PurchaseInvoicesCompanion copyWith(
      {Value<int>? id,
      Value<String>? invoiceNumber,
      Value<String?>? supplierName,
      Value<int>? userId,
      Value<int?>? shiftId,
      Value<double>? totalAmount,
      Value<String?>? notes,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return PurchaseInvoicesCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      supplierName: supplierName ?? this.supplierName,
      userId: userId ?? this.userId,
      shiftId: shiftId ?? this.shiftId,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (supplierName.present) {
      map['supplier_name'] = Variable<String>(supplierName.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseInvoicesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('supplierName: $supplierName, ')
          ..write('userId: $userId, ')
          ..write('shiftId: $shiftId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTable extends PurchaseItems
    with TableInfo<$PurchaseItemsTable, PurchaseItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _purchaseInvoiceIdMeta =
      const VerificationMeta('purchaseInvoiceId');
  @override
  late final GeneratedColumn<int> purchaseInvoiceId = GeneratedColumn<int>(
      'purchase_invoice_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES purchase_invoices (id) ON DELETE CASCADE'));
  static const VerificationMeta _ingredientIdMeta =
      const VerificationMeta('ingredientId');
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
      'ingredient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES ingredients (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitCostMeta =
      const VerificationMeta('unitCost');
  @override
  late final GeneratedColumn<double> unitCost = GeneratedColumn<double>(
      'unit_cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lineTotalMeta =
      const VerificationMeta('lineTotal');
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
      'line_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        purchaseInvoiceId,
        ingredientId,
        quantity,
        unitCost,
        lineTotal,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_items';
  @override
  VerificationContext validateIntegrity(Insertable<PurchaseItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_invoice_id')) {
      context.handle(
          _purchaseInvoiceIdMeta,
          purchaseInvoiceId.isAcceptableOrUnknown(
              data['purchase_invoice_id']!, _purchaseInvoiceIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseInvoiceIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
          _ingredientIdMeta,
          ingredientId.isAcceptableOrUnknown(
              data['ingredient_id']!, _ingredientIdMeta));
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_cost')) {
      context.handle(_unitCostMeta,
          unitCost.isAcceptableOrUnknown(data['unit_cost']!, _unitCostMeta));
    } else if (isInserting) {
      context.missing(_unitCostMeta);
    }
    if (data.containsKey('line_total')) {
      context.handle(_lineTotalMeta,
          lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta));
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      purchaseInvoiceId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}purchase_invoice_id'])!,
      ingredientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingredient_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unitCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_cost'])!,
      lineTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}line_total'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PurchaseItemsTable createAlias(String alias) {
    return $PurchaseItemsTable(attachedDatabase, alias);
  }
}

class PurchaseItem extends DataClass implements Insertable<PurchaseItem> {
  final int id;
  final int purchaseInvoiceId;
  final int ingredientId;
  final double quantity;
  final double unitCost;
  final double lineTotal;
  final DateTime createdAt;
  const PurchaseItem(
      {required this.id,
      required this.purchaseInvoiceId,
      required this.ingredientId,
      required this.quantity,
      required this.unitCost,
      required this.lineTotal,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_invoice_id'] = Variable<int>(purchaseInvoiceId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    map['quantity'] = Variable<double>(quantity);
    map['unit_cost'] = Variable<double>(unitCost);
    map['line_total'] = Variable<double>(lineTotal);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchaseItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsCompanion(
      id: Value(id),
      purchaseInvoiceId: Value(purchaseInvoiceId),
      ingredientId: Value(ingredientId),
      quantity: Value(quantity),
      unitCost: Value(unitCost),
      lineTotal: Value(lineTotal),
      createdAt: Value(createdAt),
    );
  }

  factory PurchaseItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItem(
      id: serializer.fromJson<int>(json['id']),
      purchaseInvoiceId: serializer.fromJson<int>(json['purchaseInvoiceId']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitCost: serializer.fromJson<double>(json['unitCost']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseInvoiceId': serializer.toJson<int>(purchaseInvoiceId),
      'ingredientId': serializer.toJson<int>(ingredientId),
      'quantity': serializer.toJson<double>(quantity),
      'unitCost': serializer.toJson<double>(unitCost),
      'lineTotal': serializer.toJson<double>(lineTotal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PurchaseItem copyWith(
          {int? id,
          int? purchaseInvoiceId,
          int? ingredientId,
          double? quantity,
          double? unitCost,
          double? lineTotal,
          DateTime? createdAt}) =>
      PurchaseItem(
        id: id ?? this.id,
        purchaseInvoiceId: purchaseInvoiceId ?? this.purchaseInvoiceId,
        ingredientId: ingredientId ?? this.ingredientId,
        quantity: quantity ?? this.quantity,
        unitCost: unitCost ?? this.unitCost,
        lineTotal: lineTotal ?? this.lineTotal,
        createdAt: createdAt ?? this.createdAt,
      );
  PurchaseItem copyWithCompanion(PurchaseItemsCompanion data) {
    return PurchaseItem(
      id: data.id.present ? data.id.value : this.id,
      purchaseInvoiceId: data.purchaseInvoiceId.present
          ? data.purchaseInvoiceId.value
          : this.purchaseInvoiceId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitCost: data.unitCost.present ? data.unitCost.value : this.unitCost,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItem(')
          ..write('id: $id, ')
          ..write('purchaseInvoiceId: $purchaseInvoiceId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantity: $quantity, ')
          ..write('unitCost: $unitCost, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, purchaseInvoiceId, ingredientId, quantity,
      unitCost, lineTotal, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItem &&
          other.id == this.id &&
          other.purchaseInvoiceId == this.purchaseInvoiceId &&
          other.ingredientId == this.ingredientId &&
          other.quantity == this.quantity &&
          other.unitCost == this.unitCost &&
          other.lineTotal == this.lineTotal &&
          other.createdAt == this.createdAt);
}

class PurchaseItemsCompanion extends UpdateCompanion<PurchaseItem> {
  final Value<int> id;
  final Value<int> purchaseInvoiceId;
  final Value<int> ingredientId;
  final Value<double> quantity;
  final Value<double> unitCost;
  final Value<double> lineTotal;
  final Value<DateTime> createdAt;
  const PurchaseItemsCompanion({
    this.id = const Value.absent(),
    this.purchaseInvoiceId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitCost = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PurchaseItemsCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseInvoiceId,
    required int ingredientId,
    required double quantity,
    required double unitCost,
    required double lineTotal,
    this.createdAt = const Value.absent(),
  })  : purchaseInvoiceId = Value(purchaseInvoiceId),
        ingredientId = Value(ingredientId),
        quantity = Value(quantity),
        unitCost = Value(unitCost),
        lineTotal = Value(lineTotal);
  static Insertable<PurchaseItem> custom({
    Expression<int>? id,
    Expression<int>? purchaseInvoiceId,
    Expression<int>? ingredientId,
    Expression<double>? quantity,
    Expression<double>? unitCost,
    Expression<double>? lineTotal,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseInvoiceId != null) 'purchase_invoice_id': purchaseInvoiceId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (quantity != null) 'quantity': quantity,
      if (unitCost != null) 'unit_cost': unitCost,
      if (lineTotal != null) 'line_total': lineTotal,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PurchaseItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? purchaseInvoiceId,
      Value<int>? ingredientId,
      Value<double>? quantity,
      Value<double>? unitCost,
      Value<double>? lineTotal,
      Value<DateTime>? createdAt}) {
    return PurchaseItemsCompanion(
      id: id ?? this.id,
      purchaseInvoiceId: purchaseInvoiceId ?? this.purchaseInvoiceId,
      ingredientId: ingredientId ?? this.ingredientId,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
      lineTotal: lineTotal ?? this.lineTotal,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseInvoiceId.present) {
      map['purchase_invoice_id'] = Variable<int>(purchaseInvoiceId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitCost.present) {
      map['unit_cost'] = Variable<double>(unitCost.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseInvoiceId: $purchaseInvoiceId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantity: $quantity, ')
          ..write('unitCost: $unitCost, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TreasuryTransactionsTable extends TreasuryTransactions
    with TableInfo<$TreasuryTransactionsTable, TreasuryTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreasuryTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _shiftIdMeta =
      const VerificationMeta('shiftId');
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
      'shift_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES shifts (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _referenceTypeMeta =
      const VerificationMeta('referenceType');
  @override
  late final GeneratedColumn<String> referenceType = GeneratedColumn<String>(
      'reference_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceIdMeta =
      const VerificationMeta('referenceId');
  @override
  late final GeneratedColumn<int> referenceId = GeneratedColumn<int>(
      'reference_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _balanceAfterMeta =
      const VerificationMeta('balanceAfter');
  @override
  late final GeneratedColumn<double> balanceAfter = GeneratedColumn<double>(
      'balance_after', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        shiftId,
        userId,
        type,
        amount,
        referenceType,
        referenceId,
        description,
        balanceAfter,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'treasury_transactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<TreasuryTransaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shift_id')) {
      context.handle(_shiftIdMeta,
          shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('reference_type')) {
      context.handle(
          _referenceTypeMeta,
          referenceType.isAcceptableOrUnknown(
              data['reference_type']!, _referenceTypeMeta));
    }
    if (data.containsKey('reference_id')) {
      context.handle(
          _referenceIdMeta,
          referenceId.isAcceptableOrUnknown(
              data['reference_id']!, _referenceIdMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('balance_after')) {
      context.handle(
          _balanceAfterMeta,
          balanceAfter.isAcceptableOrUnknown(
              data['balance_after']!, _balanceAfterMeta));
    } else if (isInserting) {
      context.missing(_balanceAfterMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TreasuryTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TreasuryTransaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      shiftId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shift_id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      referenceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference_type']),
      referenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reference_id']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      balanceAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance_after'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TreasuryTransactionsTable createAlias(String alias) {
    return $TreasuryTransactionsTable(attachedDatabase, alias);
  }
}

class TreasuryTransaction extends DataClass
    implements Insertable<TreasuryTransaction> {
  final int id;
  final int? shiftId;
  final int userId;
  final String type;
  final double amount;
  final String? referenceType;
  final int? referenceId;
  final String? description;
  final double balanceAfter;
  final DateTime createdAt;
  const TreasuryTransaction(
      {required this.id,
      this.shiftId,
      required this.userId,
      required this.type,
      required this.amount,
      this.referenceType,
      this.referenceId,
      this.description,
      required this.balanceAfter,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<int>(shiftId);
    }
    map['user_id'] = Variable<int>(userId);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || referenceType != null) {
      map['reference_type'] = Variable<String>(referenceType);
    }
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<int>(referenceId);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['balance_after'] = Variable<double>(balanceAfter);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TreasuryTransactionsCompanion toCompanion(bool nullToAbsent) {
    return TreasuryTransactionsCompanion(
      id: Value(id),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      userId: Value(userId),
      type: Value(type),
      amount: Value(amount),
      referenceType: referenceType == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceType),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      balanceAfter: Value(balanceAfter),
      createdAt: Value(createdAt),
    );
  }

  factory TreasuryTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TreasuryTransaction(
      id: serializer.fromJson<int>(json['id']),
      shiftId: serializer.fromJson<int?>(json['shiftId']),
      userId: serializer.fromJson<int>(json['userId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      referenceType: serializer.fromJson<String?>(json['referenceType']),
      referenceId: serializer.fromJson<int?>(json['referenceId']),
      description: serializer.fromJson<String?>(json['description']),
      balanceAfter: serializer.fromJson<double>(json['balanceAfter']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shiftId': serializer.toJson<int?>(shiftId),
      'userId': serializer.toJson<int>(userId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'referenceType': serializer.toJson<String?>(referenceType),
      'referenceId': serializer.toJson<int?>(referenceId),
      'description': serializer.toJson<String?>(description),
      'balanceAfter': serializer.toJson<double>(balanceAfter),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TreasuryTransaction copyWith(
          {int? id,
          Value<int?> shiftId = const Value.absent(),
          int? userId,
          String? type,
          double? amount,
          Value<String?> referenceType = const Value.absent(),
          Value<int?> referenceId = const Value.absent(),
          Value<String?> description = const Value.absent(),
          double? balanceAfter,
          DateTime? createdAt}) =>
      TreasuryTransaction(
        id: id ?? this.id,
        shiftId: shiftId.present ? shiftId.value : this.shiftId,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        referenceType:
            referenceType.present ? referenceType.value : this.referenceType,
        referenceId: referenceId.present ? referenceId.value : this.referenceId,
        description: description.present ? description.value : this.description,
        balanceAfter: balanceAfter ?? this.balanceAfter,
        createdAt: createdAt ?? this.createdAt,
      );
  TreasuryTransaction copyWithCompanion(TreasuryTransactionsCompanion data) {
    return TreasuryTransaction(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      referenceType: data.referenceType.present
          ? data.referenceType.value
          : this.referenceType,
      referenceId:
          data.referenceId.present ? data.referenceId.value : this.referenceId,
      description:
          data.description.present ? data.description.value : this.description,
      balanceAfter: data.balanceAfter.present
          ? data.balanceAfter.value
          : this.balanceAfter,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TreasuryTransaction(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('referenceType: $referenceType, ')
          ..write('referenceId: $referenceId, ')
          ..write('description: $description, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shiftId, userId, type, amount,
      referenceType, referenceId, description, balanceAfter, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TreasuryTransaction &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.referenceType == this.referenceType &&
          other.referenceId == this.referenceId &&
          other.description == this.description &&
          other.balanceAfter == this.balanceAfter &&
          other.createdAt == this.createdAt);
}

class TreasuryTransactionsCompanion
    extends UpdateCompanion<TreasuryTransaction> {
  final Value<int> id;
  final Value<int?> shiftId;
  final Value<int> userId;
  final Value<String> type;
  final Value<double> amount;
  final Value<String?> referenceType;
  final Value<int?> referenceId;
  final Value<String?> description;
  final Value<double> balanceAfter;
  final Value<DateTime> createdAt;
  const TreasuryTransactionsCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.referenceType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.description = const Value.absent(),
    this.balanceAfter = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TreasuryTransactionsCompanion.insert({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    required int userId,
    required String type,
    required double amount,
    this.referenceType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.description = const Value.absent(),
    required double balanceAfter,
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        type = Value(type),
        amount = Value(amount),
        balanceAfter = Value(balanceAfter);
  static Insertable<TreasuryTransaction> custom({
    Expression<int>? id,
    Expression<int>? shiftId,
    Expression<int>? userId,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<String>? referenceType,
    Expression<int>? referenceId,
    Expression<String>? description,
    Expression<double>? balanceAfter,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (referenceType != null) 'reference_type': referenceType,
      if (referenceId != null) 'reference_id': referenceId,
      if (description != null) 'description': description,
      if (balanceAfter != null) 'balance_after': balanceAfter,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TreasuryTransactionsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? shiftId,
      Value<int>? userId,
      Value<String>? type,
      Value<double>? amount,
      Value<String?>? referenceType,
      Value<int?>? referenceId,
      Value<String?>? description,
      Value<double>? balanceAfter,
      Value<DateTime>? createdAt}) {
    return TreasuryTransactionsCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      description: description ?? this.description,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (referenceType.present) {
      map['reference_type'] = Variable<String>(referenceType.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<int>(referenceId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (balanceAfter.present) {
      map['balance_after'] = Variable<double>(balanceAfter.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreasuryTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('referenceType: $referenceType, ')
          ..write('referenceId: $referenceId, ')
          ..write('description: $description, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _shiftIdMeta =
      const VerificationMeta('shiftId');
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
      'shift_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, amount, date, category, note, shiftId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('shift_id')) {
      context.handle(_shiftIdMeta,
          shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      shiftId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shift_id']),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final double amount;
  final DateTime date;
  final String category;
  final String? note;
  final int? shiftId;
  const Expense(
      {required this.id,
      required this.amount,
      required this.date,
      required this.category,
      this.note,
      this.shiftId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<int>(shiftId);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      amount: Value(amount),
      date: Value(date),
      category: Value(category),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      note: serializer.fromJson<String?>(json['note']),
      shiftId: serializer.fromJson<int?>(json['shiftId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<String>(category),
      'note': serializer.toJson<String?>(note),
      'shiftId': serializer.toJson<int?>(shiftId),
    };
  }

  Expense copyWith(
          {int? id,
          double? amount,
          DateTime? date,
          String? category,
          Value<String?> note = const Value.absent(),
          Value<int?> shiftId = const Value.absent()}) =>
      Expense(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        category: category ?? this.category,
        note: note.present ? note.value : this.note,
        shiftId: shiftId.present ? shiftId.value : this.shiftId,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      note: data.note.present ? data.note.value : this.note,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('shiftId: $shiftId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, date, category, note, shiftId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.category == this.category &&
          other.note == this.note &&
          other.shiftId == this.shiftId);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> category;
  final Value<String?> note;
  final Value<int?> shiftId;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.note = const Value.absent(),
    this.shiftId = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required DateTime date,
    required String category,
    this.note = const Value.absent(),
    this.shiftId = const Value.absent(),
  })  : amount = Value(amount),
        date = Value(date),
        category = Value(category);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? category,
    Expression<String>? note,
    Expression<int>? shiftId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (note != null) 'note': note,
      if (shiftId != null) 'shift_id': shiftId,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<String>? category,
      Value<String?>? note,
      Value<int?>? shiftId}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
      shiftId: shiftId ?? this.shiftId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('shiftId: $shiftId')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, action, details, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLog extends DataClass implements Insertable<AuditLog> {
  final int id;
  final int userId;
  final String action;
  final String? details;
  final DateTime createdAt;
  const AuditLog(
      {required this.id,
      required this.userId,
      required this.action,
      this.details,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      action: Value(action),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      details: serializer.fromJson<String?>(json['details']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'action': serializer.toJson<String>(action),
      'details': serializer.toJson<String?>(details),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditLog copyWith(
          {int? id,
          int? userId,
          String? action,
          Value<String?> details = const Value.absent(),
          DateTime? createdAt}) =>
      AuditLog(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        action: action ?? this.action,
        details: details.present ? details.value : this.details,
        createdAt: createdAt ?? this.createdAt,
      );
  AuditLog copyWithCompanion(AuditLogsCompanion data) {
    return AuditLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      details: data.details.present ? data.details.value : this.details,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, action, details, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.details == this.details &&
          other.createdAt == this.createdAt);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> action;
  final Value<String?> details;
  final Value<DateTime> createdAt;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String action,
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        action = Value(action);
  static Insertable<AuditLog> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? action,
    Expression<String>? details,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (details != null) 'details': details,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AuditLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String>? action,
      Value<String?>? details,
      Value<DateTime>? createdAt}) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PendingOrdersTable extends PendingOrders
    with TableInfo<$PendingOrdersTable, PendingOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _tableIdMeta =
      const VerificationMeta('tableId');
  @override
  late final GeneratedColumn<int> tableId = GeneratedColumn<int>(
      'table_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tables (id)'));
  static const VerificationMeta _orderTypeMeta =
      const VerificationMeta('orderType');
  @override
  late final GeneratedColumn<String> orderType = GeneratedColumn<String>(
      'order_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _discountPercentageMeta =
      const VerificationMeta('discountPercentage');
  @override
  late final GeneratedColumn<double> discountPercentage =
      GeneratedColumn<double>('discount_percentage', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _taxPercentageMeta =
      const VerificationMeta('taxPercentage');
  @override
  late final GeneratedColumn<double> taxPercentage = GeneratedColumn<double>(
      'tax_percentage', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _cartItemsJsonMeta =
      const VerificationMeta('cartItemsJson');
  @override
  late final GeneratedColumn<String> cartItemsJson = GeneratedColumn<String>(
      'cart_items_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        tableId,
        orderType,
        notes,
        discountPercentage,
        taxPercentage,
        cartItemsJson,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_orders';
  @override
  VerificationContext validateIntegrity(Insertable<PendingOrder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('table_id')) {
      context.handle(_tableIdMeta,
          tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta));
    }
    if (data.containsKey('order_type')) {
      context.handle(_orderTypeMeta,
          orderType.isAcceptableOrUnknown(data['order_type']!, _orderTypeMeta));
    } else if (isInserting) {
      context.missing(_orderTypeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('discount_percentage')) {
      context.handle(
          _discountPercentageMeta,
          discountPercentage.isAcceptableOrUnknown(
              data['discount_percentage']!, _discountPercentageMeta));
    }
    if (data.containsKey('tax_percentage')) {
      context.handle(
          _taxPercentageMeta,
          taxPercentage.isAcceptableOrUnknown(
              data['tax_percentage']!, _taxPercentageMeta));
    }
    if (data.containsKey('cart_items_json')) {
      context.handle(
          _cartItemsJsonMeta,
          cartItemsJson.isAcceptableOrUnknown(
              data['cart_items_json']!, _cartItemsJsonMeta));
    } else if (isInserting) {
      context.missing(_cartItemsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingOrder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      tableId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}table_id']),
      orderType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_type'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      discountPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_percentage'])!,
      taxPercentage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_percentage'])!,
      cartItemsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cart_items_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PendingOrdersTable createAlias(String alias) {
    return $PendingOrdersTable(attachedDatabase, alias);
  }
}

class PendingOrder extends DataClass implements Insertable<PendingOrder> {
  final int id;
  final int userId;
  final int? tableId;
  final String orderType;
  final String? notes;
  final double discountPercentage;
  final double taxPercentage;
  final String cartItemsJson;
  final DateTime createdAt;
  const PendingOrder(
      {required this.id,
      required this.userId,
      this.tableId,
      required this.orderType,
      this.notes,
      required this.discountPercentage,
      required this.taxPercentage,
      required this.cartItemsJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    if (!nullToAbsent || tableId != null) {
      map['table_id'] = Variable<int>(tableId);
    }
    map['order_type'] = Variable<String>(orderType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['discount_percentage'] = Variable<double>(discountPercentage);
    map['tax_percentage'] = Variable<double>(taxPercentage);
    map['cart_items_json'] = Variable<String>(cartItemsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingOrdersCompanion toCompanion(bool nullToAbsent) {
    return PendingOrdersCompanion(
      id: Value(id),
      userId: Value(userId),
      tableId: tableId == null && nullToAbsent
          ? const Value.absent()
          : Value(tableId),
      orderType: Value(orderType),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      discountPercentage: Value(discountPercentage),
      taxPercentage: Value(taxPercentage),
      cartItemsJson: Value(cartItemsJson),
      createdAt: Value(createdAt),
    );
  }

  factory PendingOrder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingOrder(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      tableId: serializer.fromJson<int?>(json['tableId']),
      orderType: serializer.fromJson<String>(json['orderType']),
      notes: serializer.fromJson<String?>(json['notes']),
      discountPercentage:
          serializer.fromJson<double>(json['discountPercentage']),
      taxPercentage: serializer.fromJson<double>(json['taxPercentage']),
      cartItemsJson: serializer.fromJson<String>(json['cartItemsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'tableId': serializer.toJson<int?>(tableId),
      'orderType': serializer.toJson<String>(orderType),
      'notes': serializer.toJson<String?>(notes),
      'discountPercentage': serializer.toJson<double>(discountPercentage),
      'taxPercentage': serializer.toJson<double>(taxPercentage),
      'cartItemsJson': serializer.toJson<String>(cartItemsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingOrder copyWith(
          {int? id,
          int? userId,
          Value<int?> tableId = const Value.absent(),
          String? orderType,
          Value<String?> notes = const Value.absent(),
          double? discountPercentage,
          double? taxPercentage,
          String? cartItemsJson,
          DateTime? createdAt}) =>
      PendingOrder(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        tableId: tableId.present ? tableId.value : this.tableId,
        orderType: orderType ?? this.orderType,
        notes: notes.present ? notes.value : this.notes,
        discountPercentage: discountPercentage ?? this.discountPercentage,
        taxPercentage: taxPercentage ?? this.taxPercentage,
        cartItemsJson: cartItemsJson ?? this.cartItemsJson,
        createdAt: createdAt ?? this.createdAt,
      );
  PendingOrder copyWithCompanion(PendingOrdersCompanion data) {
    return PendingOrder(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      orderType: data.orderType.present ? data.orderType.value : this.orderType,
      notes: data.notes.present ? data.notes.value : this.notes,
      discountPercentage: data.discountPercentage.present
          ? data.discountPercentage.value
          : this.discountPercentage,
      taxPercentage: data.taxPercentage.present
          ? data.taxPercentage.value
          : this.taxPercentage,
      cartItemsJson: data.cartItemsJson.present
          ? data.cartItemsJson.value
          : this.cartItemsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingOrder(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tableId: $tableId, ')
          ..write('orderType: $orderType, ')
          ..write('notes: $notes, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('taxPercentage: $taxPercentage, ')
          ..write('cartItemsJson: $cartItemsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, tableId, orderType, notes,
      discountPercentage, taxPercentage, cartItemsJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingOrder &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.tableId == this.tableId &&
          other.orderType == this.orderType &&
          other.notes == this.notes &&
          other.discountPercentage == this.discountPercentage &&
          other.taxPercentage == this.taxPercentage &&
          other.cartItemsJson == this.cartItemsJson &&
          other.createdAt == this.createdAt);
}

class PendingOrdersCompanion extends UpdateCompanion<PendingOrder> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int?> tableId;
  final Value<String> orderType;
  final Value<String?> notes;
  final Value<double> discountPercentage;
  final Value<double> taxPercentage;
  final Value<String> cartItemsJson;
  final Value<DateTime> createdAt;
  const PendingOrdersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.tableId = const Value.absent(),
    this.orderType = const Value.absent(),
    this.notes = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.taxPercentage = const Value.absent(),
    this.cartItemsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PendingOrdersCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.tableId = const Value.absent(),
    required String orderType,
    this.notes = const Value.absent(),
    this.discountPercentage = const Value.absent(),
    this.taxPercentage = const Value.absent(),
    required String cartItemsJson,
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        orderType = Value(orderType),
        cartItemsJson = Value(cartItemsJson);
  static Insertable<PendingOrder> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? tableId,
    Expression<String>? orderType,
    Expression<String>? notes,
    Expression<double>? discountPercentage,
    Expression<double>? taxPercentage,
    Expression<String>? cartItemsJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (tableId != null) 'table_id': tableId,
      if (orderType != null) 'order_type': orderType,
      if (notes != null) 'notes': notes,
      if (discountPercentage != null) 'discount_percentage': discountPercentage,
      if (taxPercentage != null) 'tax_percentage': taxPercentage,
      if (cartItemsJson != null) 'cart_items_json': cartItemsJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingOrdersCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int?>? tableId,
      Value<String>? orderType,
      Value<String?>? notes,
      Value<double>? discountPercentage,
      Value<double>? taxPercentage,
      Value<String>? cartItemsJson,
      Value<DateTime>? createdAt}) {
    return PendingOrdersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tableId: tableId ?? this.tableId,
      orderType: orderType ?? this.orderType,
      notes: notes ?? this.notes,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      cartItemsJson: cartItemsJson ?? this.cartItemsJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (tableId.present) {
      map['table_id'] = Variable<int>(tableId.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(orderType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (discountPercentage.present) {
      map['discount_percentage'] = Variable<double>(discountPercentage.value);
    }
    if (taxPercentage.present) {
      map['tax_percentage'] = Variable<double>(taxPercentage.value);
    }
    if (cartItemsJson.present) {
      map['cart_items_json'] = Variable<String>(cartItemsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingOrdersCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('tableId: $tableId, ')
          ..write('orderType: $orderType, ')
          ..write('notes: $notes, ')
          ..write('discountPercentage: $discountPercentage, ')
          ..write('taxPercentage: $taxPercentage, ')
          ..write('cartItemsJson: $cartItemsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserPermissionsTable extends UserPermissions
    with TableInfo<$UserPermissionsTable, UserPermission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPermissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES users (id) ON DELETE CASCADE'));
  static const VerificationMeta _permissionMeta =
      const VerificationMeta('permission');
  @override
  late final GeneratedColumn<String> permission = GeneratedColumn<String>(
      'permission', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, userId, permission];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_permissions';
  @override
  VerificationContext validateIntegrity(Insertable<UserPermission> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('permission')) {
      context.handle(
          _permissionMeta,
          permission.isAcceptableOrUnknown(
              data['permission']!, _permissionMeta));
    } else if (isInserting) {
      context.missing(_permissionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPermission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPermission(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      permission: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}permission'])!,
    );
  }

  @override
  $UserPermissionsTable createAlias(String alias) {
    return $UserPermissionsTable(attachedDatabase, alias);
  }
}

class UserPermission extends DataClass implements Insertable<UserPermission> {
  final int id;
  final int userId;
  final String permission;
  const UserPermission(
      {required this.id, required this.userId, required this.permission});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['permission'] = Variable<String>(permission);
    return map;
  }

  UserPermissionsCompanion toCompanion(bool nullToAbsent) {
    return UserPermissionsCompanion(
      id: Value(id),
      userId: Value(userId),
      permission: Value(permission),
    );
  }

  factory UserPermission.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPermission(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      permission: serializer.fromJson<String>(json['permission']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'permission': serializer.toJson<String>(permission),
    };
  }

  UserPermission copyWith({int? id, int? userId, String? permission}) =>
      UserPermission(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        permission: permission ?? this.permission,
      );
  UserPermission copyWithCompanion(UserPermissionsCompanion data) {
    return UserPermission(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      permission:
          data.permission.present ? data.permission.value : this.permission,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPermission(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('permission: $permission')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, permission);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPermission &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.permission == this.permission);
}

class UserPermissionsCompanion extends UpdateCompanion<UserPermission> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> permission;
  const UserPermissionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.permission = const Value.absent(),
  });
  UserPermissionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String permission,
  })  : userId = Value(userId),
        permission = Value(permission);
  static Insertable<UserPermission> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? permission,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (permission != null) 'permission': permission,
    });
  }

  UserPermissionsCompanion copyWith(
      {Value<int>? id, Value<int>? userId, Value<String>? permission}) {
    return UserPermissionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      permission: permission ?? this.permission,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (permission.present) {
      map['permission'] = Variable<String>(permission.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPermissionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('permission: $permission')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $ShiftsTable shifts = $ShiftsTable(this);
  late final $TablesTable tables = $TablesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionItemsTable transactionItems =
      $TransactionItemsTable(this);
  late final $PurchaseInvoicesTable purchaseInvoices =
      $PurchaseInvoicesTable(this);
  late final $PurchaseItemsTable purchaseItems = $PurchaseItemsTable(this);
  late final $TreasuryTransactionsTable treasuryTransactions =
      $TreasuryTransactionsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  late final $PendingOrdersTable pendingOrders = $PendingOrdersTable(this);
  late final $UserPermissionsTable userPermissions =
      $UserPermissionsTable(this);
  late final Index idxMealsCategory = Index('idx_meals_category',
      'CREATE INDEX idx_meals_category ON meals (category)');
  late final Index idxMealsIsActive = Index('idx_meals_is_active',
      'CREATE INDEX idx_meals_is_active ON meals (is_active)');
  late final Index idxTransactionsCreatedAt = Index(
      'idx_transactions_created_at',
      'CREATE INDEX idx_transactions_created_at ON transactions (created_at)');
  late final Index idxTransactionsType = Index('idx_transactions_type',
      'CREATE INDEX idx_transactions_type ON transactions (type)');
  late final Index idxTransactionsShiftId = Index('idx_transactions_shift_id',
      'CREATE INDEX idx_transactions_shift_id ON transactions (shift_id)');
  late final Index idxTransactionItemsTransactionId = Index(
      'idx_transaction_items_transaction_id',
      'CREATE INDEX idx_transaction_items_transaction_id ON transaction_items (transaction_id)');
  late final Index idxPurchaseInvoicesStatus = Index(
      'idx_purchase_invoices_status',
      'CREATE INDEX idx_purchase_invoices_status ON purchase_invoices (status)');
  late final Index idxPurchaseInvoicesCreatedAt = Index(
      'idx_purchase_invoices_created_at',
      'CREATE INDEX idx_purchase_invoices_created_at ON purchase_invoices (created_at)');
  late final Index idxTreasuryTransactionsShiftId = Index(
      'idx_treasury_transactions_shift_id',
      'CREATE INDEX idx_treasury_transactions_shift_id ON treasury_transactions (shift_id)');
  late final Index idxTreasuryTransactionsCreatedAt = Index(
      'idx_treasury_transactions_created_at',
      'CREATE INDEX idx_treasury_transactions_created_at ON treasury_transactions (created_at)');
  late final Index idxUserPermissionsUserId = Index(
      'idx_user_permissions_user_id',
      'CREATE INDEX idx_user_permissions_user_id ON user_permissions (user_id)');
  late final UserDao userDao = UserDao(this as AppDatabase);
  late final IngredientDao ingredientDao = IngredientDao(this as AppDatabase);
  late final MealDao mealDao = MealDao(this as AppDatabase);
  late final RecipeDao recipeDao = RecipeDao(this as AppDatabase);
  late final TransactionDao transactionDao =
      TransactionDao(this as AppDatabase);
  late final ShiftDao shiftDao = ShiftDao(this as AppDatabase);
  late final PurchaseDao purchaseDao = PurchaseDao(this as AppDatabase);
  late final TreasuryDao treasuryDao = TreasuryDao(this as AppDatabase);
  late final ExpenseDao expenseDao = ExpenseDao(this as AppDatabase);
  late final AuditLogDao auditLogDao = AuditLogDao(this as AppDatabase);
  late final TableDao tableDao = TableDao(this as AppDatabase);
  late final PendingOrderDao pendingOrderDao =
      PendingOrderDao(this as AppDatabase);
  late final ReportsDao reportsDao = ReportsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        ingredients,
        meals,
        recipes,
        shifts,
        tables,
        transactions,
        transactionItems,
        purchaseInvoices,
        purchaseItems,
        treasuryTransactions,
        expenses,
        auditLogs,
        pendingOrders,
        userPermissions,
        idxMealsCategory,
        idxMealsIsActive,
        idxTransactionsCreatedAt,
        idxTransactionsType,
        idxTransactionsShiftId,
        idxTransactionItemsTransactionId,
        idxPurchaseInvoicesStatus,
        idxPurchaseInvoicesCreatedAt,
        idxTreasuryTransactionsShiftId,
        idxTreasuryTransactionsCreatedAt,
        idxUserPermissionsUserId
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('purchase_invoices',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('purchase_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('users',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('user_permissions', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String username,
  required String passwordHash,
  required String recoveryEmail,
  required String role,
  Value<bool> mustChangePassword,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String> passwordHash,
  Value<String> recoveryEmail,
  Value<String> role,
  Value<bool> mustChangePassword,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ShiftsTable, List<Shift>> _shiftsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shifts,
          aliasName: $_aliasNameGenerator(db.users.id, db.shifts.cashierId));

  $$ShiftsTableProcessedTableManager get shiftsRefs {
    final manager = $$ShiftsTableTableManager($_db, $_db.shifts)
        .filter((f) => f.cashierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_shiftsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.transactions,
          aliasName: $_aliasNameGenerator(db.users.id, db.transactions.userId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PurchaseInvoicesTable, List<PurchaseInvoice>>
      _purchaseInvoicesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseInvoices,
              aliasName: $_aliasNameGenerator(
                  db.users.id, db.purchaseInvoices.userId));

  $$PurchaseInvoicesTableProcessedTableManager get purchaseInvoicesRefs {
    final manager =
        $$PurchaseInvoicesTableTableManager($_db, $_db.purchaseInvoices)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_purchaseInvoicesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TreasuryTransactionsTable,
      List<TreasuryTransaction>> _treasuryTransactionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.treasuryTransactions,
          aliasName: $_aliasNameGenerator(
              db.users.id, db.treasuryTransactions.userId));

  $$TreasuryTransactionsTableProcessedTableManager
      get treasuryTransactionsRefs {
    final manager =
        $$TreasuryTransactionsTableTableManager($_db, $_db.treasuryTransactions)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_treasuryTransactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AuditLogsTable, List<AuditLog>>
      _auditLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.auditLogs,
          aliasName: $_aliasNameGenerator(db.users.id, db.auditLogs.userId));

  $$AuditLogsTableProcessedTableManager get auditLogsRefs {
    final manager = $$AuditLogsTableTableManager($_db, $_db.auditLogs)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_auditLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PendingOrdersTable, List<PendingOrder>>
      _pendingOrdersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.pendingOrders,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.pendingOrders.userId));

  $$PendingOrdersTableProcessedTableManager get pendingOrdersRefs {
    final manager = $$PendingOrdersTableTableManager($_db, $_db.pendingOrders)
        .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pendingOrdersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$UserPermissionsTable, List<UserPermission>>
      _userPermissionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.userPermissions,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.userPermissions.userId));

  $$UserPermissionsTableProcessedTableManager get userPermissionsRefs {
    final manager =
        $$UserPermissionsTableTableManager($_db, $_db.userPermissions)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_userPermissionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recoveryEmail => $composableBuilder(
      column: $table.recoveryEmail, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get mustChangePassword => $composableBuilder(
      column: $table.mustChangePassword,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> shiftsRefs(
      Expression<bool> Function($$ShiftsTableFilterComposer f) f) {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.cashierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> purchaseInvoicesRefs(
      Expression<bool> Function($$PurchaseInvoicesTableFilterComposer f) f) {
    final $$PurchaseInvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseInvoices,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseInvoicesTableFilterComposer(
              $db: $db,
              $table: $db.purchaseInvoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> treasuryTransactionsRefs(
      Expression<bool> Function($$TreasuryTransactionsTableFilterComposer f)
          f) {
    final $$TreasuryTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.treasuryTransactions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TreasuryTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.treasuryTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> auditLogsRefs(
      Expression<bool> Function($$AuditLogsTableFilterComposer f) f) {
    final $$AuditLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.auditLogs,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AuditLogsTableFilterComposer(
              $db: $db,
              $table: $db.auditLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> pendingOrdersRefs(
      Expression<bool> Function($$PendingOrdersTableFilterComposer f) f) {
    final $$PendingOrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pendingOrders,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PendingOrdersTableFilterComposer(
              $db: $db,
              $table: $db.pendingOrders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> userPermissionsRefs(
      Expression<bool> Function($$UserPermissionsTableFilterComposer f) f) {
    final $$UserPermissionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userPermissions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserPermissionsTableFilterComposer(
              $db: $db,
              $table: $db.userPermissions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recoveryEmail => $composableBuilder(
      column: $table.recoveryEmail,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get mustChangePassword => $composableBuilder(
      column: $table.mustChangePassword,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<String> get recoveryEmail => $composableBuilder(
      column: $table.recoveryEmail, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get mustChangePassword => $composableBuilder(
      column: $table.mustChangePassword, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> shiftsRefs<T extends Object>(
      Expression<T> Function($$ShiftsTableAnnotationComposer a) f) {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.cashierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> purchaseInvoicesRefs<T extends Object>(
      Expression<T> Function($$PurchaseInvoicesTableAnnotationComposer a) f) {
    final $$PurchaseInvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseInvoices,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseInvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseInvoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> treasuryTransactionsRefs<T extends Object>(
      Expression<T> Function($$TreasuryTransactionsTableAnnotationComposer a)
          f) {
    final $$TreasuryTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.treasuryTransactions,
            getReferencedColumn: (t) => t.userId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$TreasuryTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.treasuryTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> auditLogsRefs<T extends Object>(
      Expression<T> Function($$AuditLogsTableAnnotationComposer a) f) {
    final $$AuditLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.auditLogs,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AuditLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.auditLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> pendingOrdersRefs<T extends Object>(
      Expression<T> Function($$PendingOrdersTableAnnotationComposer a) f) {
    final $$PendingOrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pendingOrders,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PendingOrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.pendingOrders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> userPermissionsRefs<T extends Object>(
      Expression<T> Function($$UserPermissionsTableAnnotationComposer a) f) {
    final $$UserPermissionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userPermissions,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UserPermissionsTableAnnotationComposer(
              $db: $db,
              $table: $db.userPermissions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool shiftsRefs,
        bool transactionsRefs,
        bool purchaseInvoicesRefs,
        bool treasuryTransactionsRefs,
        bool auditLogsRefs,
        bool pendingOrdersRefs,
        bool userPermissionsRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<String> recoveryEmail = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<bool> mustChangePassword = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            passwordHash: passwordHash,
            recoveryEmail: recoveryEmail,
            role: role,
            mustChangePassword: mustChangePassword,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            required String passwordHash,
            required String recoveryEmail,
            required String role,
            Value<bool> mustChangePassword = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            passwordHash: passwordHash,
            recoveryEmail: recoveryEmail,
            role: role,
            mustChangePassword: mustChangePassword,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {shiftsRefs = false,
              transactionsRefs = false,
              purchaseInvoicesRefs = false,
              treasuryTransactionsRefs = false,
              auditLogsRefs = false,
              pendingOrdersRefs = false,
              userPermissionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (shiftsRefs) db.shifts,
                if (transactionsRefs) db.transactions,
                if (purchaseInvoicesRefs) db.purchaseInvoices,
                if (treasuryTransactionsRefs) db.treasuryTransactions,
                if (auditLogsRefs) db.auditLogs,
                if (pendingOrdersRefs) db.pendingOrders,
                if (userPermissionsRefs) db.userPermissions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shiftsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Shift>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._shiftsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).shiftsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.cashierId == item.id),
                        typedResults: items),
                  if (transactionsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Transaction>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (purchaseInvoicesRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            PurchaseInvoice>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._purchaseInvoicesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .purchaseInvoicesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (treasuryTransactionsRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            TreasuryTransaction>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._treasuryTransactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .treasuryTransactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (auditLogsRefs)
                    await $_getPrefetchedData<User, $UsersTable, AuditLog>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._auditLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).auditLogsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (pendingOrdersRefs)
                    await $_getPrefetchedData<User, $UsersTable, PendingOrder>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._pendingOrdersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .pendingOrdersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (userPermissionsRefs)
                    await $_getPrefetchedData<User, $UsersTable,
                            UserPermission>(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._userPermissionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .userPermissionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function(
        {bool shiftsRefs,
        bool transactionsRefs,
        bool purchaseInvoicesRefs,
        bool treasuryTransactionsRefs,
        bool auditLogsRefs,
        bool pendingOrdersRefs,
        bool userPermissionsRefs})>;
typedef $$IngredientsTableCreateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  required String name,
  required String unitOfMeasurement,
  Value<double> currentStock,
  required double costPrice,
  Value<double> minStockAlert,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$IngredientsTableUpdateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> unitOfMeasurement,
  Value<double> currentStock,
  Value<double> costPrice,
  Value<double> minStockAlert,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipesTable, List<Recipe>> _recipesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.recipes,
          aliasName:
              $_aliasNameGenerator(db.ingredients.id, db.recipes.ingredientId));

  $$RecipesTableProcessedTableManager get recipesRefs {
    final manager = $$RecipesTableTableManager($_db, $_db.recipes)
        .filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TransactionItemsTable, List<TransactionItem>>
      _transactionItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionItems,
              aliasName: $_aliasNameGenerator(
                  db.ingredients.id, db.transactionItems.ingredientId));

  $$TransactionItemsTableProcessedTableManager get transactionItemsRefs {
    final manager = $$TransactionItemsTableTableManager(
            $_db, $_db.transactionItems)
        .filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
      _purchaseItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseItems,
              aliasName: $_aliasNameGenerator(
                  db.ingredients.id, db.purchaseItems.ingredientId));

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager($_db, $_db.purchaseItems)
        .filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitOfMeasurement => $composableBuilder(
      column: $table.unitOfMeasurement,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentStock => $composableBuilder(
      column: $table.currentStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get minStockAlert => $composableBuilder(
      column: $table.minStockAlert, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> recipesRefs(
      Expression<bool> Function($$RecipesTableFilterComposer f) f) {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.ingredientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableFilterComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> transactionItemsRefs(
      Expression<bool> Function($$TransactionItemsTableFilterComposer f) f) {
    final $$TransactionItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.ingredientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableFilterComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> purchaseItemsRefs(
      Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.ingredientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitOfMeasurement => $composableBuilder(
      column: $table.unitOfMeasurement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentStock => $composableBuilder(
      column: $table.currentStock,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get minStockAlert => $composableBuilder(
      column: $table.minStockAlert,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
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

  GeneratedColumn<String> get unitOfMeasurement => $composableBuilder(
      column: $table.unitOfMeasurement, builder: (column) => column);

  GeneratedColumn<double> get currentStock => $composableBuilder(
      column: $table.currentStock, builder: (column) => column);

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<double> get minStockAlert => $composableBuilder(
      column: $table.minStockAlert, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> recipesRefs<T extends Object>(
      Expression<T> Function($$RecipesTableAnnotationComposer a) f) {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.ingredientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableAnnotationComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> transactionItemsRefs<T extends Object>(
      Expression<T> Function($$TransactionItemsTableAnnotationComposer a) f) {
    final $$TransactionItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.ingredientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
      Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.ingredientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$IngredientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IngredientsTable,
    Ingredient,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (Ingredient, $$IngredientsTableReferences),
    Ingredient,
    PrefetchHooks Function(
        {bool recipesRefs,
        bool transactionItemsRefs,
        bool purchaseItemsRefs})> {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> unitOfMeasurement = const Value.absent(),
            Value<double> currentStock = const Value.absent(),
            Value<double> costPrice = const Value.absent(),
            Value<double> minStockAlert = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              IngredientsCompanion(
            id: id,
            name: name,
            unitOfMeasurement: unitOfMeasurement,
            currentStock: currentStock,
            costPrice: costPrice,
            minStockAlert: minStockAlert,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String unitOfMeasurement,
            Value<double> currentStock = const Value.absent(),
            required double costPrice,
            Value<double> minStockAlert = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              IngredientsCompanion.insert(
            id: id,
            name: name,
            unitOfMeasurement: unitOfMeasurement,
            currentStock: currentStock,
            costPrice: costPrice,
            minStockAlert: minStockAlert,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$IngredientsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {recipesRefs = false,
              transactionItemsRefs = false,
              purchaseItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recipesRefs) db.recipes,
                if (transactionItemsRefs) db.transactionItems,
                if (purchaseItemsRefs) db.purchaseItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recipesRefs)
                    await $_getPrefetchedData<Ingredient, $IngredientsTable,
                            Recipe>(
                        currentTable: table,
                        referencedTable:
                            $$IngredientsTableReferences._recipesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$IngredientsTableReferences(db, table, p0)
                                .recipesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.ingredientId == item.id),
                        typedResults: items),
                  if (transactionItemsRefs)
                    await $_getPrefetchedData<Ingredient, $IngredientsTable,
                            TransactionItem>(
                        currentTable: table,
                        referencedTable: $$IngredientsTableReferences
                            ._transactionItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$IngredientsTableReferences(db, table, p0)
                                .transactionItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.ingredientId == item.id),
                        typedResults: items),
                  if (purchaseItemsRefs)
                    await $_getPrefetchedData<Ingredient, $IngredientsTable,
                            PurchaseItem>(
                        currentTable: table,
                        referencedTable: $$IngredientsTableReferences
                            ._purchaseItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$IngredientsTableReferences(db, table, p0)
                                .purchaseItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.ingredientId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$IngredientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IngredientsTable,
    Ingredient,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (Ingredient, $$IngredientsTableReferences),
    Ingredient,
    PrefetchHooks Function(
        {bool recipesRefs, bool transactionItemsRefs, bool purchaseItemsRefs})>;
typedef $$MealsTableCreateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  required String name,
  required double sellingPrice,
  required String category,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$MealsTableUpdateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> sellingPrice,
  Value<String> category,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$MealsTableReferences
    extends BaseReferences<_$AppDatabase, $MealsTable, Meal> {
  $$MealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipesTable, List<Recipe>> _recipesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.recipes,
          aliasName: $_aliasNameGenerator(db.meals.id, db.recipes.mealId));

  $$RecipesTableProcessedTableManager get recipesRefs {
    final manager = $$RecipesTableTableManager($_db, $_db.recipes)
        .filter((f) => f.mealId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TransactionItemsTable, List<TransactionItem>>
      _transactionItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionItems,
              aliasName: $_aliasNameGenerator(
                  db.meals.id, db.transactionItems.mealId));

  $$TransactionItemsTableProcessedTableManager get transactionItemsRefs {
    final manager =
        $$TransactionItemsTableTableManager($_db, $_db.transactionItems)
            .filter((f) => f.mealId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> recipesRefs(
      Expression<bool> Function($$RecipesTableFilterComposer f) f) {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.mealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableFilterComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> transactionItemsRefs(
      Expression<bool> Function($$TransactionItemsTableFilterComposer f) f) {
    final $$TransactionItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.mealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableFilterComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
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

  GeneratedColumn<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> recipesRefs<T extends Object>(
      Expression<T> Function($$RecipesTableAnnotationComposer a) f) {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.mealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableAnnotationComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> transactionItemsRefs<T extends Object>(
      Expression<T> Function($$TransactionItemsTableAnnotationComposer a) f) {
    final $$TransactionItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.mealId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MealsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MealsTable,
    Meal,
    $$MealsTableFilterComposer,
    $$MealsTableOrderingComposer,
    $$MealsTableAnnotationComposer,
    $$MealsTableCreateCompanionBuilder,
    $$MealsTableUpdateCompanionBuilder,
    (Meal, $$MealsTableReferences),
    Meal,
    PrefetchHooks Function({bool recipesRefs, bool transactionItemsRefs})> {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> sellingPrice = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MealsCompanion(
            id: id,
            name: name,
            sellingPrice: sellingPrice,
            category: category,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double sellingPrice,
            required String category,
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MealsCompanion.insert(
            id: id,
            name: name,
            sellingPrice: sellingPrice,
            category: category,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MealsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {recipesRefs = false, transactionItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recipesRefs) db.recipes,
                if (transactionItemsRefs) db.transactionItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recipesRefs)
                    await $_getPrefetchedData<Meal, $MealsTable, Recipe>(
                        currentTable: table,
                        referencedTable:
                            $$MealsTableReferences._recipesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MealsTableReferences(db, table, p0).recipesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.mealId == item.id),
                        typedResults: items),
                  if (transactionItemsRefs)
                    await $_getPrefetchedData<Meal, $MealsTable,
                            TransactionItem>(
                        currentTable: table,
                        referencedTable: $$MealsTableReferences
                            ._transactionItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MealsTableReferences(db, table, p0)
                                .transactionItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.mealId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MealsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MealsTable,
    Meal,
    $$MealsTableFilterComposer,
    $$MealsTableOrderingComposer,
    $$MealsTableAnnotationComposer,
    $$MealsTableCreateCompanionBuilder,
    $$MealsTableUpdateCompanionBuilder,
    (Meal, $$MealsTableReferences),
    Meal,
    PrefetchHooks Function({bool recipesRefs, bool transactionItemsRefs})>;
typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  required int mealId,
  required int ingredientId,
  required double quantityRequired,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  Value<int> mealId,
  Value<int> ingredientId,
  Value<double> quantityRequired,
});

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, Recipe> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MealsTable _mealIdTable(_$AppDatabase db) => db.meals
      .createAlias($_aliasNameGenerator(db.recipes.mealId, db.meals.id));

  $$MealsTableProcessedTableManager get mealId {
    final $_column = $_itemColumn<int>('meal_id')!;

    final manager = $$MealsTableTableManager($_db, $_db.meals)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
          $_aliasNameGenerator(db.recipes.ingredientId, db.ingredients.id));

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<int>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager($_db, $_db.ingredients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityRequired => $composableBuilder(
      column: $table.quantityRequired,
      builder: (column) => ColumnFilters(column));

  $$MealsTableFilterComposer get mealId {
    final $$MealsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableFilterComposer(
              $db: $db,
              $table: $db.meals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableFilterComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityRequired => $composableBuilder(
      column: $table.quantityRequired,
      builder: (column) => ColumnOrderings(column));

  $$MealsTableOrderingComposer get mealId {
    final $$MealsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableOrderingComposer(
              $db: $db,
              $table: $db.meals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableOrderingComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantityRequired => $composableBuilder(
      column: $table.quantityRequired, builder: (column) => column);

  $$MealsTableAnnotationComposer get mealId {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableAnnotationComposer(
              $db: $db,
              $table: $db.meals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableAnnotationComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipesTable,
    Recipe,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (Recipe, $$RecipesTableReferences),
    Recipe,
    PrefetchHooks Function({bool mealId, bool ingredientId})> {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> mealId = const Value.absent(),
            Value<int> ingredientId = const Value.absent(),
            Value<double> quantityRequired = const Value.absent(),
          }) =>
              RecipesCompanion(
            id: id,
            mealId: mealId,
            ingredientId: ingredientId,
            quantityRequired: quantityRequired,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int mealId,
            required int ingredientId,
            required double quantityRequired,
          }) =>
              RecipesCompanion.insert(
            id: id,
            mealId: mealId,
            ingredientId: ingredientId,
            quantityRequired: quantityRequired,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RecipesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({mealId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (mealId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mealId,
                    referencedTable: $$RecipesTableReferences._mealIdTable(db),
                    referencedColumn:
                        $$RecipesTableReferences._mealIdTable(db).id,
                  ) as T;
                }
                if (ingredientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ingredientId,
                    referencedTable:
                        $$RecipesTableReferences._ingredientIdTable(db),
                    referencedColumn:
                        $$RecipesTableReferences._ingredientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RecipesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipesTable,
    Recipe,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (Recipe, $$RecipesTableReferences),
    Recipe,
    PrefetchHooks Function({bool mealId, bool ingredientId})>;
typedef $$ShiftsTableCreateCompanionBuilder = ShiftsCompanion Function({
  Value<int> id,
  required int cashierId,
  Value<String> status,
  required double startingCash,
  Value<double?> expectedClosingCash,
  Value<double?> actualClosingCash,
  Value<double?> variance,
  Value<double> totalSales,
  Value<double> totalPurchases,
  Value<double> totalCashIn,
  Value<double> totalCashOut,
  Value<DateTime> openedAt,
  Value<DateTime?> closedAt,
  Value<String?> notes,
});
typedef $$ShiftsTableUpdateCompanionBuilder = ShiftsCompanion Function({
  Value<int> id,
  Value<int> cashierId,
  Value<String> status,
  Value<double> startingCash,
  Value<double?> expectedClosingCash,
  Value<double?> actualClosingCash,
  Value<double?> variance,
  Value<double> totalSales,
  Value<double> totalPurchases,
  Value<double> totalCashIn,
  Value<double> totalCashOut,
  Value<DateTime> openedAt,
  Value<DateTime?> closedAt,
  Value<String?> notes,
});

final class $$ShiftsTableReferences
    extends BaseReferences<_$AppDatabase, $ShiftsTable, Shift> {
  $$ShiftsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _cashierIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.shifts.cashierId, db.users.id));

  $$UsersTableProcessedTableManager get cashierId {
    final $_column = $_itemColumn<int>('cashier_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cashierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName:
                  $_aliasNameGenerator(db.shifts.id, db.transactions.shiftId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.shiftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PurchaseInvoicesTable, List<PurchaseInvoice>>
      _purchaseInvoicesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseInvoices,
              aliasName: $_aliasNameGenerator(
                  db.shifts.id, db.purchaseInvoices.shiftId));

  $$PurchaseInvoicesTableProcessedTableManager get purchaseInvoicesRefs {
    final manager =
        $$PurchaseInvoicesTableTableManager($_db, $_db.purchaseInvoices)
            .filter((f) => f.shiftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_purchaseInvoicesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TreasuryTransactionsTable,
      List<TreasuryTransaction>> _treasuryTransactionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.treasuryTransactions,
          aliasName: $_aliasNameGenerator(
              db.shifts.id, db.treasuryTransactions.shiftId));

  $$TreasuryTransactionsTableProcessedTableManager
      get treasuryTransactionsRefs {
    final manager =
        $$TreasuryTransactionsTableTableManager($_db, $_db.treasuryTransactions)
            .filter((f) => f.shiftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_treasuryTransactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get startingCash => $composableBuilder(
      column: $table.startingCash, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get expectedClosingCash => $composableBuilder(
      column: $table.expectedClosingCash,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get actualClosingCash => $composableBuilder(
      column: $table.actualClosingCash,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get variance => $composableBuilder(
      column: $table.variance, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalSales => $composableBuilder(
      column: $table.totalSales, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalPurchases => $composableBuilder(
      column: $table.totalPurchases,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalCashIn => $composableBuilder(
      column: $table.totalCashIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalCashOut => $composableBuilder(
      column: $table.totalCashOut, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get cashierId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cashierId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> purchaseInvoicesRefs(
      Expression<bool> Function($$PurchaseInvoicesTableFilterComposer f) f) {
    final $$PurchaseInvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseInvoices,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseInvoicesTableFilterComposer(
              $db: $db,
              $table: $db.purchaseInvoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> treasuryTransactionsRefs(
      Expression<bool> Function($$TreasuryTransactionsTableFilterComposer f)
          f) {
    final $$TreasuryTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.treasuryTransactions,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TreasuryTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.treasuryTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get startingCash => $composableBuilder(
      column: $table.startingCash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get expectedClosingCash => $composableBuilder(
      column: $table.expectedClosingCash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get actualClosingCash => $composableBuilder(
      column: $table.actualClosingCash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get variance => $composableBuilder(
      column: $table.variance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalSales => $composableBuilder(
      column: $table.totalSales, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalPurchases => $composableBuilder(
      column: $table.totalPurchases,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalCashIn => $composableBuilder(
      column: $table.totalCashIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalCashOut => $composableBuilder(
      column: $table.totalCashOut,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get cashierId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cashierId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get startingCash => $composableBuilder(
      column: $table.startingCash, builder: (column) => column);

  GeneratedColumn<double> get expectedClosingCash => $composableBuilder(
      column: $table.expectedClosingCash, builder: (column) => column);

  GeneratedColumn<double> get actualClosingCash => $composableBuilder(
      column: $table.actualClosingCash, builder: (column) => column);

  GeneratedColumn<double> get variance =>
      $composableBuilder(column: $table.variance, builder: (column) => column);

  GeneratedColumn<double> get totalSales => $composableBuilder(
      column: $table.totalSales, builder: (column) => column);

  GeneratedColumn<double> get totalPurchases => $composableBuilder(
      column: $table.totalPurchases, builder: (column) => column);

  GeneratedColumn<double> get totalCashIn => $composableBuilder(
      column: $table.totalCashIn, builder: (column) => column);

  GeneratedColumn<double> get totalCashOut => $composableBuilder(
      column: $table.totalCashOut, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$UsersTableAnnotationComposer get cashierId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cashierId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> purchaseInvoicesRefs<T extends Object>(
      Expression<T> Function($$PurchaseInvoicesTableAnnotationComposer a) f) {
    final $$PurchaseInvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseInvoices,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseInvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseInvoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> treasuryTransactionsRefs<T extends Object>(
      Expression<T> Function($$TreasuryTransactionsTableAnnotationComposer a)
          f) {
    final $$TreasuryTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.treasuryTransactions,
            getReferencedColumn: (t) => t.shiftId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$TreasuryTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.treasuryTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ShiftsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShiftsTable,
    Shift,
    $$ShiftsTableFilterComposer,
    $$ShiftsTableOrderingComposer,
    $$ShiftsTableAnnotationComposer,
    $$ShiftsTableCreateCompanionBuilder,
    $$ShiftsTableUpdateCompanionBuilder,
    (Shift, $$ShiftsTableReferences),
    Shift,
    PrefetchHooks Function(
        {bool cashierId,
        bool transactionsRefs,
        bool purchaseInvoicesRefs,
        bool treasuryTransactionsRefs})> {
  $$ShiftsTableTableManager(_$AppDatabase db, $ShiftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> cashierId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> startingCash = const Value.absent(),
            Value<double?> expectedClosingCash = const Value.absent(),
            Value<double?> actualClosingCash = const Value.absent(),
            Value<double?> variance = const Value.absent(),
            Value<double> totalSales = const Value.absent(),
            Value<double> totalPurchases = const Value.absent(),
            Value<double> totalCashIn = const Value.absent(),
            Value<double> totalCashOut = const Value.absent(),
            Value<DateTime> openedAt = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              ShiftsCompanion(
            id: id,
            cashierId: cashierId,
            status: status,
            startingCash: startingCash,
            expectedClosingCash: expectedClosingCash,
            actualClosingCash: actualClosingCash,
            variance: variance,
            totalSales: totalSales,
            totalPurchases: totalPurchases,
            totalCashIn: totalCashIn,
            totalCashOut: totalCashOut,
            openedAt: openedAt,
            closedAt: closedAt,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int cashierId,
            Value<String> status = const Value.absent(),
            required double startingCash,
            Value<double?> expectedClosingCash = const Value.absent(),
            Value<double?> actualClosingCash = const Value.absent(),
            Value<double?> variance = const Value.absent(),
            Value<double> totalSales = const Value.absent(),
            Value<double> totalPurchases = const Value.absent(),
            Value<double> totalCashIn = const Value.absent(),
            Value<double> totalCashOut = const Value.absent(),
            Value<DateTime> openedAt = const Value.absent(),
            Value<DateTime?> closedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              ShiftsCompanion.insert(
            id: id,
            cashierId: cashierId,
            status: status,
            startingCash: startingCash,
            expectedClosingCash: expectedClosingCash,
            actualClosingCash: actualClosingCash,
            variance: variance,
            totalSales: totalSales,
            totalPurchases: totalPurchases,
            totalCashIn: totalCashIn,
            totalCashOut: totalCashOut,
            openedAt: openedAt,
            closedAt: closedAt,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ShiftsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {cashierId = false,
              transactionsRefs = false,
              purchaseInvoicesRefs = false,
              treasuryTransactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsRefs) db.transactions,
                if (purchaseInvoicesRefs) db.purchaseInvoices,
                if (treasuryTransactionsRefs) db.treasuryTransactions
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (cashierId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cashierId,
                    referencedTable:
                        $$ShiftsTableReferences._cashierIdTable(db),
                    referencedColumn:
                        $$ShiftsTableReferences._cashierIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<Shift, $ShiftsTable, Transaction>(
                        currentTable: table,
                        referencedTable:
                            $$ShiftsTableReferences._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShiftsTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.shiftId == item.id),
                        typedResults: items),
                  if (purchaseInvoicesRefs)
                    await $_getPrefetchedData<Shift, $ShiftsTable,
                            PurchaseInvoice>(
                        currentTable: table,
                        referencedTable: $$ShiftsTableReferences
                            ._purchaseInvoicesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShiftsTableReferences(db, table, p0)
                                .purchaseInvoicesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.shiftId == item.id),
                        typedResults: items),
                  if (treasuryTransactionsRefs)
                    await $_getPrefetchedData<Shift, $ShiftsTable,
                            TreasuryTransaction>(
                        currentTable: table,
                        referencedTable: $$ShiftsTableReferences
                            ._treasuryTransactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShiftsTableReferences(db, table, p0)
                                .treasuryTransactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.shiftId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ShiftsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShiftsTable,
    Shift,
    $$ShiftsTableFilterComposer,
    $$ShiftsTableOrderingComposer,
    $$ShiftsTableAnnotationComposer,
    $$ShiftsTableCreateCompanionBuilder,
    $$ShiftsTableUpdateCompanionBuilder,
    (Shift, $$ShiftsTableReferences),
    Shift,
    PrefetchHooks Function(
        {bool cashierId,
        bool transactionsRefs,
        bool purchaseInvoicesRefs,
        bool treasuryTransactionsRefs})>;
typedef $$TablesTableCreateCompanionBuilder = TablesCompanion Function({
  Value<int> id,
  required String name,
  Value<String> status,
  Value<int> seatsCount,
});
typedef $$TablesTableUpdateCompanionBuilder = TablesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> status,
  Value<int> seatsCount,
});

final class $$TablesTableReferences
    extends BaseReferences<_$AppDatabase, $TablesTable, RestaurantTable> {
  $$TablesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName:
                  $_aliasNameGenerator(db.tables.id, db.transactions.tableId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.tableId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PendingOrdersTable, List<PendingOrder>>
      _pendingOrdersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.pendingOrders,
              aliasName:
                  $_aliasNameGenerator(db.tables.id, db.pendingOrders.tableId));

  $$PendingOrdersTableProcessedTableManager get pendingOrdersRefs {
    final manager = $$PendingOrdersTableTableManager($_db, $_db.pendingOrders)
        .filter((f) => f.tableId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pendingOrdersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TablesTableFilterComposer
    extends Composer<_$AppDatabase, $TablesTable> {
  $$TablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get seatsCount => $composableBuilder(
      column: $table.seatsCount, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.tableId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> pendingOrdersRefs(
      Expression<bool> Function($$PendingOrdersTableFilterComposer f) f) {
    final $$PendingOrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pendingOrders,
        getReferencedColumn: (t) => t.tableId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PendingOrdersTableFilterComposer(
              $db: $db,
              $table: $db.pendingOrders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TablesTableOrderingComposer
    extends Composer<_$AppDatabase, $TablesTable> {
  $$TablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get seatsCount => $composableBuilder(
      column: $table.seatsCount, builder: (column) => ColumnOrderings(column));
}

class $$TablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TablesTable> {
  $$TablesTableAnnotationComposer({
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

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get seatsCount => $composableBuilder(
      column: $table.seatsCount, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.tableId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> pendingOrdersRefs<T extends Object>(
      Expression<T> Function($$PendingOrdersTableAnnotationComposer a) f) {
    final $$PendingOrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pendingOrders,
        getReferencedColumn: (t) => t.tableId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PendingOrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.pendingOrders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TablesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TablesTable,
    RestaurantTable,
    $$TablesTableFilterComposer,
    $$TablesTableOrderingComposer,
    $$TablesTableAnnotationComposer,
    $$TablesTableCreateCompanionBuilder,
    $$TablesTableUpdateCompanionBuilder,
    (RestaurantTable, $$TablesTableReferences),
    RestaurantTable,
    PrefetchHooks Function({bool transactionsRefs, bool pendingOrdersRefs})> {
  $$TablesTableTableManager(_$AppDatabase db, $TablesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> seatsCount = const Value.absent(),
          }) =>
              TablesCompanion(
            id: id,
            name: name,
            status: status,
            seatsCount: seatsCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> status = const Value.absent(),
            Value<int> seatsCount = const Value.absent(),
          }) =>
              TablesCompanion.insert(
            id: id,
            name: name,
            status: status,
            seatsCount: seatsCount,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TablesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {transactionsRefs = false, pendingOrdersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsRefs) db.transactions,
                if (pendingOrdersRefs) db.pendingOrders
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<RestaurantTable, $TablesTable,
                            Transaction>(
                        currentTable: table,
                        referencedTable:
                            $$TablesTableReferences._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TablesTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tableId == item.id),
                        typedResults: items),
                  if (pendingOrdersRefs)
                    await $_getPrefetchedData<RestaurantTable, $TablesTable,
                            PendingOrder>(
                        currentTable: table,
                        referencedTable:
                            $$TablesTableReferences._pendingOrdersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TablesTableReferences(db, table, p0)
                                .pendingOrdersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tableId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TablesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TablesTable,
    RestaurantTable,
    $$TablesTableFilterComposer,
    $$TablesTableOrderingComposer,
    $$TablesTableAnnotationComposer,
    $$TablesTableCreateCompanionBuilder,
    $$TablesTableUpdateCompanionBuilder,
    (RestaurantTable, $$TablesTableReferences),
    RestaurantTable,
    PrefetchHooks Function({bool transactionsRefs, bool pendingOrdersRefs})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  required int userId,
  Value<int?> shiftId,
  required String type,
  required double totalAmount,
  Value<double> subtotalAmount,
  Value<double> discountAmount,
  Value<double> taxAmount,
  Value<String> orderType,
  Value<String> paymentMethod,
  Value<int?> tableId,
  Value<String?> notes,
  Value<DateTime> createdAt,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<int?> shiftId,
  Value<String> type,
  Value<double> totalAmount,
  Value<double> subtotalAmount,
  Value<double> discountAmount,
  Value<double> taxAmount,
  Value<String> orderType,
  Value<String> paymentMethod,
  Value<int?> tableId,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.transactions.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ShiftsTable _shiftIdTable(_$AppDatabase db) => db.shifts
      .createAlias($_aliasNameGenerator(db.transactions.shiftId, db.shifts.id));

  $$ShiftsTableProcessedTableManager? get shiftId {
    final $_column = $_itemColumn<int>('shift_id');
    if ($_column == null) return null;
    final manager = $$ShiftsTableTableManager($_db, $_db.shifts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TablesTable _tableIdTable(_$AppDatabase db) => db.tables
      .createAlias($_aliasNameGenerator(db.transactions.tableId, db.tables.id));

  $$TablesTableProcessedTableManager? get tableId {
    final $_column = $_itemColumn<int>('table_id');
    if ($_column == null) return null;
    final manager = $$TablesTableTableManager($_db, $_db.tables)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tableIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionItemsTable, List<TransactionItem>>
      _transactionItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionItems,
              aliasName: $_aliasNameGenerator(
                  db.transactions.id, db.transactionItems.transactionId));

  $$TransactionItemsTableProcessedTableManager get transactionItemsRefs {
    final manager = $$TransactionItemsTableTableManager(
            $_db, $_db.transactionItems)
        .filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotalAmount => $composableBuilder(
      column: $table.subtotalAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ShiftsTableFilterComposer get shiftId {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TablesTableFilterComposer get tableId {
    final $$TablesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tableId,
        referencedTable: $db.tables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TablesTableFilterComposer(
              $db: $db,
              $table: $db.tables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionItemsRefs(
      Expression<bool> Function($$TransactionItemsTableFilterComposer f) f) {
    final $$TransactionItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.transactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableFilterComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotalAmount => $composableBuilder(
      column: $table.subtotalAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ShiftsTableOrderingComposer get shiftId {
    final $$ShiftsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableOrderingComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TablesTableOrderingComposer get tableId {
    final $$TablesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tableId,
        referencedTable: $db.tables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TablesTableOrderingComposer(
              $db: $db,
              $table: $db.tables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<double> get subtotalAmount => $composableBuilder(
      column: $table.subtotalAmount, builder: (column) => column);

  GeneratedColumn<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<String> get orderType =>
      $composableBuilder(column: $table.orderType, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ShiftsTableAnnotationComposer get shiftId {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TablesTableAnnotationComposer get tableId {
    final $$TablesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tableId,
        referencedTable: $db.tables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TablesTableAnnotationComposer(
              $db: $db,
              $table: $db.tables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionItemsRefs<T extends Object>(
      Expression<T> Function($$TransactionItemsTableAnnotationComposer a) f) {
    final $$TransactionItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.transactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool userId, bool shiftId, bool tableId, bool transactionItemsRefs})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int?> shiftId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<double> subtotalAmount = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<String> orderType = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<int?> tableId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            userId: userId,
            shiftId: shiftId,
            type: type,
            totalAmount: totalAmount,
            subtotalAmount: subtotalAmount,
            discountAmount: discountAmount,
            taxAmount: taxAmount,
            orderType: orderType,
            paymentMethod: paymentMethod,
            tableId: tableId,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            Value<int?> shiftId = const Value.absent(),
            required String type,
            required double totalAmount,
            Value<double> subtotalAmount = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<String> orderType = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<int?> tableId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            userId: userId,
            shiftId: shiftId,
            type: type,
            totalAmount: totalAmount,
            subtotalAmount: subtotalAmount,
            discountAmount: discountAmount,
            taxAmount: taxAmount,
            orderType: orderType,
            paymentMethod: paymentMethod,
            tableId: tableId,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {userId = false,
              shiftId = false,
              tableId = false,
              transactionItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionItemsRefs) db.transactionItems
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$TransactionsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (shiftId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shiftId,
                    referencedTable:
                        $$TransactionsTableReferences._shiftIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._shiftIdTable(db).id,
                  ) as T;
                }
                if (tableId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tableId,
                    referencedTable:
                        $$TransactionsTableReferences._tableIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._tableIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionItemsRefs)
                    await $_getPrefetchedData<Transaction, $TransactionsTable,
                            TransactionItem>(
                        currentTable: table,
                        referencedTable: $$TransactionsTableReferences
                            ._transactionItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TransactionsTableReferences(db, table, p0)
                                .transactionItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.transactionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool userId, bool shiftId, bool tableId, bool transactionItemsRefs})>;
typedef $$TransactionItemsTableCreateCompanionBuilder
    = TransactionItemsCompanion Function({
  Value<int> id,
  required int transactionId,
  Value<int?> mealId,
  Value<int?> ingredientId,
  required double quantity,
  required double priceAtTime,
  required String itemType,
});
typedef $$TransactionItemsTableUpdateCompanionBuilder
    = TransactionItemsCompanion Function({
  Value<int> id,
  Value<int> transactionId,
  Value<int?> mealId,
  Value<int?> ingredientId,
  Value<double> quantity,
  Value<double> priceAtTime,
  Value<String> itemType,
});

final class $$TransactionItemsTableReferences extends BaseReferences<
    _$AppDatabase, $TransactionItemsTable, TransactionItem> {
  $$TransactionItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias($_aliasNameGenerator(
          db.transactionItems.transactionId, db.transactions.id));

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<int>('transaction_id')!;

    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MealsTable _mealIdTable(_$AppDatabase db) => db.meals.createAlias(
      $_aliasNameGenerator(db.transactionItems.mealId, db.meals.id));

  $$MealsTableProcessedTableManager? get mealId {
    final $_column = $_itemColumn<int>('meal_id');
    if ($_column == null) return null;
    final manager = $$MealsTableTableManager($_db, $_db.meals)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias($_aliasNameGenerator(
          db.transactionItems.ingredientId, db.ingredients.id));

  $$IngredientsTableProcessedTableManager? get ingredientId {
    final $_column = $_itemColumn<int>('ingredient_id');
    if ($_column == null) return null;
    final manager = $$IngredientsTableTableManager($_db, $_db.ingredients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get priceAtTime => $composableBuilder(
      column: $table.priceAtTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnFilters(column));

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MealsTableFilterComposer get mealId {
    final $$MealsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableFilterComposer(
              $db: $db,
              $table: $db.meals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableFilterComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get priceAtTime => $composableBuilder(
      column: $table.priceAtTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnOrderings(column));

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableOrderingComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MealsTableOrderingComposer get mealId {
    final $$MealsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableOrderingComposer(
              $db: $db,
              $table: $db.meals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableOrderingComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get priceAtTime => $composableBuilder(
      column: $table.priceAtTime, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MealsTableAnnotationComposer get mealId {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mealId,
        referencedTable: $db.meals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MealsTableAnnotationComposer(
              $db: $db,
              $table: $db.meals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableAnnotationComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionItemsTable,
    TransactionItem,
    $$TransactionItemsTableFilterComposer,
    $$TransactionItemsTableOrderingComposer,
    $$TransactionItemsTableAnnotationComposer,
    $$TransactionItemsTableCreateCompanionBuilder,
    $$TransactionItemsTableUpdateCompanionBuilder,
    (TransactionItem, $$TransactionItemsTableReferences),
    TransactionItem,
    PrefetchHooks Function(
        {bool transactionId, bool mealId, bool ingredientId})> {
  $$TransactionItemsTableTableManager(
      _$AppDatabase db, $TransactionItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> transactionId = const Value.absent(),
            Value<int?> mealId = const Value.absent(),
            Value<int?> ingredientId = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> priceAtTime = const Value.absent(),
            Value<String> itemType = const Value.absent(),
          }) =>
              TransactionItemsCompanion(
            id: id,
            transactionId: transactionId,
            mealId: mealId,
            ingredientId: ingredientId,
            quantity: quantity,
            priceAtTime: priceAtTime,
            itemType: itemType,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int transactionId,
            Value<int?> mealId = const Value.absent(),
            Value<int?> ingredientId = const Value.absent(),
            required double quantity,
            required double priceAtTime,
            required String itemType,
          }) =>
              TransactionItemsCompanion.insert(
            id: id,
            transactionId: transactionId,
            mealId: mealId,
            ingredientId: ingredientId,
            quantity: quantity,
            priceAtTime: priceAtTime,
            itemType: itemType,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {transactionId = false, mealId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (transactionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.transactionId,
                    referencedTable: $$TransactionItemsTableReferences
                        ._transactionIdTable(db),
                    referencedColumn: $$TransactionItemsTableReferences
                        ._transactionIdTable(db)
                        .id,
                  ) as T;
                }
                if (mealId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mealId,
                    referencedTable:
                        $$TransactionItemsTableReferences._mealIdTable(db),
                    referencedColumn:
                        $$TransactionItemsTableReferences._mealIdTable(db).id,
                  ) as T;
                }
                if (ingredientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ingredientId,
                    referencedTable: $$TransactionItemsTableReferences
                        ._ingredientIdTable(db),
                    referencedColumn: $$TransactionItemsTableReferences
                        ._ingredientIdTable(db)
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
        ));
}

typedef $$TransactionItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionItemsTable,
    TransactionItem,
    $$TransactionItemsTableFilterComposer,
    $$TransactionItemsTableOrderingComposer,
    $$TransactionItemsTableAnnotationComposer,
    $$TransactionItemsTableCreateCompanionBuilder,
    $$TransactionItemsTableUpdateCompanionBuilder,
    (TransactionItem, $$TransactionItemsTableReferences),
    TransactionItem,
    PrefetchHooks Function(
        {bool transactionId, bool mealId, bool ingredientId})>;
typedef $$PurchaseInvoicesTableCreateCompanionBuilder
    = PurchaseInvoicesCompanion Function({
  Value<int> id,
  required String invoiceNumber,
  Value<String?> supplierName,
  required int userId,
  Value<int?> shiftId,
  required double totalAmount,
  Value<String?> notes,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$PurchaseInvoicesTableUpdateCompanionBuilder
    = PurchaseInvoicesCompanion Function({
  Value<int> id,
  Value<String> invoiceNumber,
  Value<String?> supplierName,
  Value<int> userId,
  Value<int?> shiftId,
  Value<double> totalAmount,
  Value<String?> notes,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$PurchaseInvoicesTableReferences extends BaseReferences<
    _$AppDatabase, $PurchaseInvoicesTable, PurchaseInvoice> {
  $$PurchaseInvoicesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.purchaseInvoices.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ShiftsTable _shiftIdTable(_$AppDatabase db) => db.shifts.createAlias(
      $_aliasNameGenerator(db.purchaseInvoices.shiftId, db.shifts.id));

  $$ShiftsTableProcessedTableManager? get shiftId {
    final $_column = $_itemColumn<int>('shift_id');
    if ($_column == null) return null;
    final manager = $$ShiftsTableTableManager($_db, $_db.shifts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
      _purchaseItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseItems,
              aliasName: $_aliasNameGenerator(
                  db.purchaseInvoices.id, db.purchaseItems.purchaseInvoiceId));

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager($_db, $_db.purchaseItems)
        .filter(
            (f) => f.purchaseInvoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PurchaseInvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseInvoicesTable> {
  $$PurchaseInvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplierName => $composableBuilder(
      column: $table.supplierName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ShiftsTableFilterComposer get shiftId {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> purchaseItemsRefs(
      Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.purchaseInvoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PurchaseInvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseInvoicesTable> {
  $$PurchaseInvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplierName => $composableBuilder(
      column: $table.supplierName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ShiftsTableOrderingComposer get shiftId {
    final $$ShiftsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableOrderingComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseInvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseInvoicesTable> {
  $$PurchaseInvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => column);

  GeneratedColumn<String> get supplierName => $composableBuilder(
      column: $table.supplierName, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ShiftsTableAnnotationComposer get shiftId {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
      Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.purchaseInvoiceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PurchaseInvoicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchaseInvoicesTable,
    PurchaseInvoice,
    $$PurchaseInvoicesTableFilterComposer,
    $$PurchaseInvoicesTableOrderingComposer,
    $$PurchaseInvoicesTableAnnotationComposer,
    $$PurchaseInvoicesTableCreateCompanionBuilder,
    $$PurchaseInvoicesTableUpdateCompanionBuilder,
    (PurchaseInvoice, $$PurchaseInvoicesTableReferences),
    PurchaseInvoice,
    PrefetchHooks Function(
        {bool userId, bool shiftId, bool purchaseItemsRefs})> {
  $$PurchaseInvoicesTableTableManager(
      _$AppDatabase db, $PurchaseInvoicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseInvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseInvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseInvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> invoiceNumber = const Value.absent(),
            Value<String?> supplierName = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int?> shiftId = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PurchaseInvoicesCompanion(
            id: id,
            invoiceNumber: invoiceNumber,
            supplierName: supplierName,
            userId: userId,
            shiftId: shiftId,
            totalAmount: totalAmount,
            notes: notes,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String invoiceNumber,
            Value<String?> supplierName = const Value.absent(),
            required int userId,
            Value<int?> shiftId = const Value.absent(),
            required double totalAmount,
            Value<String?> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              PurchaseInvoicesCompanion.insert(
            id: id,
            invoiceNumber: invoiceNumber,
            supplierName: supplierName,
            userId: userId,
            shiftId: shiftId,
            totalAmount: totalAmount,
            notes: notes,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PurchaseInvoicesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {userId = false, shiftId = false, purchaseItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (purchaseItemsRefs) db.purchaseItems
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$PurchaseInvoicesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$PurchaseInvoicesTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (shiftId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shiftId,
                    referencedTable:
                        $$PurchaseInvoicesTableReferences._shiftIdTable(db),
                    referencedColumn:
                        $$PurchaseInvoicesTableReferences._shiftIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchaseItemsRefs)
                    await $_getPrefetchedData<PurchaseInvoice,
                            $PurchaseInvoicesTable, PurchaseItem>(
                        currentTable: table,
                        referencedTable: $$PurchaseInvoicesTableReferences
                            ._purchaseItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PurchaseInvoicesTableReferences(db, table, p0)
                                .purchaseItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.purchaseInvoiceId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PurchaseInvoicesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchaseInvoicesTable,
    PurchaseInvoice,
    $$PurchaseInvoicesTableFilterComposer,
    $$PurchaseInvoicesTableOrderingComposer,
    $$PurchaseInvoicesTableAnnotationComposer,
    $$PurchaseInvoicesTableCreateCompanionBuilder,
    $$PurchaseInvoicesTableUpdateCompanionBuilder,
    (PurchaseInvoice, $$PurchaseInvoicesTableReferences),
    PurchaseInvoice,
    PrefetchHooks Function(
        {bool userId, bool shiftId, bool purchaseItemsRefs})>;
typedef $$PurchaseItemsTableCreateCompanionBuilder = PurchaseItemsCompanion
    Function({
  Value<int> id,
  required int purchaseInvoiceId,
  required int ingredientId,
  required double quantity,
  required double unitCost,
  required double lineTotal,
  Value<DateTime> createdAt,
});
typedef $$PurchaseItemsTableUpdateCompanionBuilder = PurchaseItemsCompanion
    Function({
  Value<int> id,
  Value<int> purchaseInvoiceId,
  Value<int> ingredientId,
  Value<double> quantity,
  Value<double> unitCost,
  Value<double> lineTotal,
  Value<DateTime> createdAt,
});

final class $$PurchaseItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PurchaseItemsTable, PurchaseItem> {
  $$PurchaseItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PurchaseInvoicesTable _purchaseInvoiceIdTable(_$AppDatabase db) =>
      db.purchaseInvoices.createAlias($_aliasNameGenerator(
          db.purchaseItems.purchaseInvoiceId, db.purchaseInvoices.id));

  $$PurchaseInvoicesTableProcessedTableManager get purchaseInvoiceId {
    final $_column = $_itemColumn<int>('purchase_invoice_id')!;

    final manager =
        $$PurchaseInvoicesTableTableManager($_db, $_db.purchaseInvoices)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseInvoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias($_aliasNameGenerator(
          db.purchaseItems.ingredientId, db.ingredients.id));

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<int>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager($_db, $_db.ingredients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PurchaseItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitCost => $composableBuilder(
      column: $table.unitCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$PurchaseInvoicesTableFilterComposer get purchaseInvoiceId {
    final $$PurchaseInvoicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseInvoiceId,
        referencedTable: $db.purchaseInvoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseInvoicesTableFilterComposer(
              $db: $db,
              $table: $db.purchaseInvoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableFilterComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitCost => $composableBuilder(
      column: $table.unitCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$PurchaseInvoicesTableOrderingComposer get purchaseInvoiceId {
    final $$PurchaseInvoicesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseInvoiceId,
        referencedTable: $db.purchaseInvoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseInvoicesTableOrderingComposer(
              $db: $db,
              $table: $db.purchaseInvoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableOrderingComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitCost =>
      $composableBuilder(column: $table.unitCost, builder: (column) => column);

  GeneratedColumn<double> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PurchaseInvoicesTableAnnotationComposer get purchaseInvoiceId {
    final $$PurchaseInvoicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseInvoiceId,
        referencedTable: $db.purchaseInvoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseInvoicesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseInvoices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableAnnotationComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchaseItemsTable,
    PurchaseItem,
    $$PurchaseItemsTableFilterComposer,
    $$PurchaseItemsTableOrderingComposer,
    $$PurchaseItemsTableAnnotationComposer,
    $$PurchaseItemsTableCreateCompanionBuilder,
    $$PurchaseItemsTableUpdateCompanionBuilder,
    (PurchaseItem, $$PurchaseItemsTableReferences),
    PurchaseItem,
    PrefetchHooks Function({bool purchaseInvoiceId, bool ingredientId})> {
  $$PurchaseItemsTableTableManager(_$AppDatabase db, $PurchaseItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> purchaseInvoiceId = const Value.absent(),
            Value<int> ingredientId = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> unitCost = const Value.absent(),
            Value<double> lineTotal = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PurchaseItemsCompanion(
            id: id,
            purchaseInvoiceId: purchaseInvoiceId,
            ingredientId: ingredientId,
            quantity: quantity,
            unitCost: unitCost,
            lineTotal: lineTotal,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int purchaseInvoiceId,
            required int ingredientId,
            required double quantity,
            required double unitCost,
            required double lineTotal,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PurchaseItemsCompanion.insert(
            id: id,
            purchaseInvoiceId: purchaseInvoiceId,
            ingredientId: ingredientId,
            quantity: quantity,
            unitCost: unitCost,
            lineTotal: lineTotal,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PurchaseItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {purchaseInvoiceId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (purchaseInvoiceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.purchaseInvoiceId,
                    referencedTable: $$PurchaseItemsTableReferences
                        ._purchaseInvoiceIdTable(db),
                    referencedColumn: $$PurchaseItemsTableReferences
                        ._purchaseInvoiceIdTable(db)
                        .id,
                  ) as T;
                }
                if (ingredientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ingredientId,
                    referencedTable:
                        $$PurchaseItemsTableReferences._ingredientIdTable(db),
                    referencedColumn: $$PurchaseItemsTableReferences
                        ._ingredientIdTable(db)
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
        ));
}

typedef $$PurchaseItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchaseItemsTable,
    PurchaseItem,
    $$PurchaseItemsTableFilterComposer,
    $$PurchaseItemsTableOrderingComposer,
    $$PurchaseItemsTableAnnotationComposer,
    $$PurchaseItemsTableCreateCompanionBuilder,
    $$PurchaseItemsTableUpdateCompanionBuilder,
    (PurchaseItem, $$PurchaseItemsTableReferences),
    PurchaseItem,
    PrefetchHooks Function({bool purchaseInvoiceId, bool ingredientId})>;
typedef $$TreasuryTransactionsTableCreateCompanionBuilder
    = TreasuryTransactionsCompanion Function({
  Value<int> id,
  Value<int?> shiftId,
  required int userId,
  required String type,
  required double amount,
  Value<String?> referenceType,
  Value<int?> referenceId,
  Value<String?> description,
  required double balanceAfter,
  Value<DateTime> createdAt,
});
typedef $$TreasuryTransactionsTableUpdateCompanionBuilder
    = TreasuryTransactionsCompanion Function({
  Value<int> id,
  Value<int?> shiftId,
  Value<int> userId,
  Value<String> type,
  Value<double> amount,
  Value<String?> referenceType,
  Value<int?> referenceId,
  Value<String?> description,
  Value<double> balanceAfter,
  Value<DateTime> createdAt,
});

final class $$TreasuryTransactionsTableReferences extends BaseReferences<
    _$AppDatabase, $TreasuryTransactionsTable, TreasuryTransaction> {
  $$TreasuryTransactionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ShiftsTable _shiftIdTable(_$AppDatabase db) => db.shifts.createAlias(
      $_aliasNameGenerator(db.treasuryTransactions.shiftId, db.shifts.id));

  $$ShiftsTableProcessedTableManager? get shiftId {
    final $_column = $_itemColumn<int>('shift_id');
    if ($_column == null) return null;
    final manager = $$ShiftsTableTableManager($_db, $_db.shifts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.treasuryTransactions.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TreasuryTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TreasuryTransactionsTable> {
  $$TreasuryTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceType => $composableBuilder(
      column: $table.referenceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balanceAfter => $composableBuilder(
      column: $table.balanceAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ShiftsTableFilterComposer get shiftId {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TreasuryTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TreasuryTransactionsTable> {
  $$TreasuryTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceType => $composableBuilder(
      column: $table.referenceType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balanceAfter => $composableBuilder(
      column: $table.balanceAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ShiftsTableOrderingComposer get shiftId {
    final $$ShiftsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableOrderingComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TreasuryTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TreasuryTransactionsTable> {
  $$TreasuryTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get referenceType => $composableBuilder(
      column: $table.referenceType, builder: (column) => column);

  GeneratedColumn<int> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get balanceAfter => $composableBuilder(
      column: $table.balanceAfter, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ShiftsTableAnnotationComposer get shiftId {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TreasuryTransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TreasuryTransactionsTable,
    TreasuryTransaction,
    $$TreasuryTransactionsTableFilterComposer,
    $$TreasuryTransactionsTableOrderingComposer,
    $$TreasuryTransactionsTableAnnotationComposer,
    $$TreasuryTransactionsTableCreateCompanionBuilder,
    $$TreasuryTransactionsTableUpdateCompanionBuilder,
    (TreasuryTransaction, $$TreasuryTransactionsTableReferences),
    TreasuryTransaction,
    PrefetchHooks Function({bool shiftId, bool userId})> {
  $$TreasuryTransactionsTableTableManager(
      _$AppDatabase db, $TreasuryTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreasuryTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreasuryTransactionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreasuryTransactionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> shiftId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> referenceType = const Value.absent(),
            Value<int?> referenceId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> balanceAfter = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TreasuryTransactionsCompanion(
            id: id,
            shiftId: shiftId,
            userId: userId,
            type: type,
            amount: amount,
            referenceType: referenceType,
            referenceId: referenceId,
            description: description,
            balanceAfter: balanceAfter,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> shiftId = const Value.absent(),
            required int userId,
            required String type,
            required double amount,
            Value<String?> referenceType = const Value.absent(),
            Value<int?> referenceId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            required double balanceAfter,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TreasuryTransactionsCompanion.insert(
            id: id,
            shiftId: shiftId,
            userId: userId,
            type: type,
            amount: amount,
            referenceType: referenceType,
            referenceId: referenceId,
            description: description,
            balanceAfter: balanceAfter,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TreasuryTransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({shiftId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (shiftId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shiftId,
                    referencedTable:
                        $$TreasuryTransactionsTableReferences._shiftIdTable(db),
                    referencedColumn: $$TreasuryTransactionsTableReferences
                        ._shiftIdTable(db)
                        .id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$TreasuryTransactionsTableReferences._userIdTable(db),
                    referencedColumn: $$TreasuryTransactionsTableReferences
                        ._userIdTable(db)
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
        ));
}

typedef $$TreasuryTransactionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $TreasuryTransactionsTable,
        TreasuryTransaction,
        $$TreasuryTransactionsTableFilterComposer,
        $$TreasuryTransactionsTableOrderingComposer,
        $$TreasuryTransactionsTableAnnotationComposer,
        $$TreasuryTransactionsTableCreateCompanionBuilder,
        $$TreasuryTransactionsTableUpdateCompanionBuilder,
        (TreasuryTransaction, $$TreasuryTransactionsTableReferences),
        TreasuryTransaction,
        PrefetchHooks Function({bool shiftId, bool userId})>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required double amount,
  required DateTime date,
  required String category,
  Value<String?> note,
  Value<int?> shiftId,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<double> amount,
  Value<DateTime> date,
  Value<String> category,
  Value<String?> note,
  Value<int?> shiftId,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get shiftId => $composableBuilder(
      column: $table.shiftId, builder: (column) => ColumnFilters(column));
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get shiftId => $composableBuilder(
      column: $table.shiftId, builder: (column) => ColumnOrderings(column));
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int?> shiftId = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            amount: amount,
            date: date,
            category: category,
            note: note,
            shiftId: shiftId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double amount,
            required DateTime date,
            required String category,
            Value<String?> note = const Value.absent(),
            Value<int?> shiftId = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            amount: amount,
            date: date,
            category: category,
            note: note,
            shiftId: shiftId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()>;
typedef $$AuditLogsTableCreateCompanionBuilder = AuditLogsCompanion Function({
  Value<int> id,
  required int userId,
  required String action,
  Value<String?> details,
  Value<DateTime> createdAt,
});
typedef $$AuditLogsTableUpdateCompanionBuilder = AuditLogsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<String> action,
  Value<String?> details,
  Value<DateTime> createdAt,
});

final class $$AuditLogsTableReferences
    extends BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog> {
  $$AuditLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.auditLogs.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLog,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLog, $$AuditLogsTableReferences),
    AuditLog,
    PrefetchHooks Function({bool userId})> {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String?> details = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AuditLogsCompanion(
            id: id,
            userId: userId,
            action: action,
            details: details,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required String action,
            Value<String?> details = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AuditLogsCompanion.insert(
            id: id,
            userId: userId,
            action: action,
            details: details,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AuditLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$AuditLogsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$AuditLogsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AuditLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLog,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLog, $$AuditLogsTableReferences),
    AuditLog,
    PrefetchHooks Function({bool userId})>;
typedef $$PendingOrdersTableCreateCompanionBuilder = PendingOrdersCompanion
    Function({
  Value<int> id,
  required int userId,
  Value<int?> tableId,
  required String orderType,
  Value<String?> notes,
  Value<double> discountPercentage,
  Value<double> taxPercentage,
  required String cartItemsJson,
  Value<DateTime> createdAt,
});
typedef $$PendingOrdersTableUpdateCompanionBuilder = PendingOrdersCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<int?> tableId,
  Value<String> orderType,
  Value<String?> notes,
  Value<double> discountPercentage,
  Value<double> taxPercentage,
  Value<String> cartItemsJson,
  Value<DateTime> createdAt,
});

final class $$PendingOrdersTableReferences
    extends BaseReferences<_$AppDatabase, $PendingOrdersTable, PendingOrder> {
  $$PendingOrdersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.pendingOrders.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TablesTable _tableIdTable(_$AppDatabase db) => db.tables.createAlias(
      $_aliasNameGenerator(db.pendingOrders.tableId, db.tables.id));

  $$TablesTableProcessedTableManager? get tableId {
    final $_column = $_itemColumn<int>('table_id');
    if ($_column == null) return null;
    final manager = $$TablesTableTableManager($_db, $_db.tables)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tableIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PendingOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $PendingOrdersTable> {
  $$PendingOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discountPercentage => $composableBuilder(
      column: $table.discountPercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxPercentage => $composableBuilder(
      column: $table.taxPercentage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cartItemsJson => $composableBuilder(
      column: $table.cartItemsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TablesTableFilterComposer get tableId {
    final $$TablesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tableId,
        referencedTable: $db.tables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TablesTableFilterComposer(
              $db: $db,
              $table: $db.tables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PendingOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingOrdersTable> {
  $$PendingOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discountPercentage => $composableBuilder(
      column: $table.discountPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxPercentage => $composableBuilder(
      column: $table.taxPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cartItemsJson => $composableBuilder(
      column: $table.cartItemsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TablesTableOrderingComposer get tableId {
    final $$TablesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tableId,
        referencedTable: $db.tables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TablesTableOrderingComposer(
              $db: $db,
              $table: $db.tables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PendingOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingOrdersTable> {
  $$PendingOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderType =>
      $composableBuilder(column: $table.orderType, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get discountPercentage => $composableBuilder(
      column: $table.discountPercentage, builder: (column) => column);

  GeneratedColumn<double> get taxPercentage => $composableBuilder(
      column: $table.taxPercentage, builder: (column) => column);

  GeneratedColumn<String> get cartItemsJson => $composableBuilder(
      column: $table.cartItemsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TablesTableAnnotationComposer get tableId {
    final $$TablesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tableId,
        referencedTable: $db.tables,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TablesTableAnnotationComposer(
              $db: $db,
              $table: $db.tables,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PendingOrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PendingOrdersTable,
    PendingOrder,
    $$PendingOrdersTableFilterComposer,
    $$PendingOrdersTableOrderingComposer,
    $$PendingOrdersTableAnnotationComposer,
    $$PendingOrdersTableCreateCompanionBuilder,
    $$PendingOrdersTableUpdateCompanionBuilder,
    (PendingOrder, $$PendingOrdersTableReferences),
    PendingOrder,
    PrefetchHooks Function({bool userId, bool tableId})> {
  $$PendingOrdersTableTableManager(_$AppDatabase db, $PendingOrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int?> tableId = const Value.absent(),
            Value<String> orderType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<double> discountPercentage = const Value.absent(),
            Value<double> taxPercentage = const Value.absent(),
            Value<String> cartItemsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PendingOrdersCompanion(
            id: id,
            userId: userId,
            tableId: tableId,
            orderType: orderType,
            notes: notes,
            discountPercentage: discountPercentage,
            taxPercentage: taxPercentage,
            cartItemsJson: cartItemsJson,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            Value<int?> tableId = const Value.absent(),
            required String orderType,
            Value<String?> notes = const Value.absent(),
            Value<double> discountPercentage = const Value.absent(),
            Value<double> taxPercentage = const Value.absent(),
            required String cartItemsJson,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PendingOrdersCompanion.insert(
            id: id,
            userId: userId,
            tableId: tableId,
            orderType: orderType,
            notes: notes,
            discountPercentage: discountPercentage,
            taxPercentage: taxPercentage,
            cartItemsJson: cartItemsJson,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PendingOrdersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false, tableId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$PendingOrdersTableReferences._userIdTable(db),
                    referencedColumn:
                        $$PendingOrdersTableReferences._userIdTable(db).id,
                  ) as T;
                }
                if (tableId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tableId,
                    referencedTable:
                        $$PendingOrdersTableReferences._tableIdTable(db),
                    referencedColumn:
                        $$PendingOrdersTableReferences._tableIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PendingOrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PendingOrdersTable,
    PendingOrder,
    $$PendingOrdersTableFilterComposer,
    $$PendingOrdersTableOrderingComposer,
    $$PendingOrdersTableAnnotationComposer,
    $$PendingOrdersTableCreateCompanionBuilder,
    $$PendingOrdersTableUpdateCompanionBuilder,
    (PendingOrder, $$PendingOrdersTableReferences),
    PendingOrder,
    PrefetchHooks Function({bool userId, bool tableId})>;
typedef $$UserPermissionsTableCreateCompanionBuilder = UserPermissionsCompanion
    Function({
  Value<int> id,
  required int userId,
  required String permission,
});
typedef $$UserPermissionsTableUpdateCompanionBuilder = UserPermissionsCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<String> permission,
});

final class $$UserPermissionsTableReferences extends BaseReferences<
    _$AppDatabase, $UserPermissionsTable, UserPermission> {
  $$UserPermissionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.userPermissions.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UserPermissionsTableFilterComposer
    extends Composer<_$AppDatabase, $UserPermissionsTable> {
  $$UserPermissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserPermissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPermissionsTable> {
  $$UserPermissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserPermissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPermissionsTable> {
  $$UserPermissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserPermissionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserPermissionsTable,
    UserPermission,
    $$UserPermissionsTableFilterComposer,
    $$UserPermissionsTableOrderingComposer,
    $$UserPermissionsTableAnnotationComposer,
    $$UserPermissionsTableCreateCompanionBuilder,
    $$UserPermissionsTableUpdateCompanionBuilder,
    (UserPermission, $$UserPermissionsTableReferences),
    UserPermission,
    PrefetchHooks Function({bool userId})> {
  $$UserPermissionsTableTableManager(
      _$AppDatabase db, $UserPermissionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPermissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPermissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPermissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> permission = const Value.absent(),
          }) =>
              UserPermissionsCompanion(
            id: id,
            userId: userId,
            permission: permission,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required String permission,
          }) =>
              UserPermissionsCompanion.insert(
            id: id,
            userId: userId,
            permission: permission,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UserPermissionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$UserPermissionsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$UserPermissionsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UserPermissionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserPermissionsTable,
    UserPermission,
    $$UserPermissionsTableFilterComposer,
    $$UserPermissionsTableOrderingComposer,
    $$UserPermissionsTableAnnotationComposer,
    $$UserPermissionsTableCreateCompanionBuilder,
    $$UserPermissionsTableUpdateCompanionBuilder,
    (UserPermission, $$UserPermissionsTableReferences),
    UserPermission,
    PrefetchHooks Function({bool userId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db, _db.shifts);
  $$TablesTableTableManager get tables =>
      $$TablesTableTableManager(_db, _db.tables);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionItemsTableTableManager get transactionItems =>
      $$TransactionItemsTableTableManager(_db, _db.transactionItems);
  $$PurchaseInvoicesTableTableManager get purchaseInvoices =>
      $$PurchaseInvoicesTableTableManager(_db, _db.purchaseInvoices);
  $$PurchaseItemsTableTableManager get purchaseItems =>
      $$PurchaseItemsTableTableManager(_db, _db.purchaseItems);
  $$TreasuryTransactionsTableTableManager get treasuryTransactions =>
      $$TreasuryTransactionsTableTableManager(_db, _db.treasuryTransactions);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
  $$PendingOrdersTableTableManager get pendingOrders =>
      $$PendingOrdersTableTableManager(_db, _db.pendingOrders);
  $$UserPermissionsTableTableManager get userPermissions =>
      $$UserPermissionsTableTableManager(_db, _db.userPermissions);
}
