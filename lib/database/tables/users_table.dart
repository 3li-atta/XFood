import 'package:drift/drift.dart';

/// Users table — stores POS operator accounts.
///
/// - [username] is unique and used for login.
/// - [passwordHash] stores bcrypt-hashed password (NEVER plain text).
/// - [recoveryEmail] is used ONLY for password recovery, not for login.
/// - [role] is either 'admin' or 'cashier'.
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique().withLength(min: 3, max: 50)();
  TextColumn get passwordHash => text()();
  TextColumn get recoveryEmail => text().withLength(min: 5, max: 100)();
  TextColumn get role => text().withLength(min: 4, max: 10)();
  BoolColumn get mustChangePassword => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
