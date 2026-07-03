import 'package:drift/drift.dart';

/// Expenses table — logs operating expenses (المصروفات التشغيلية).
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get category => text().withLength(min: 2, max: 50)(); // 'رواتب'، 'إيجار'، 'فواتير'، 'صيانة'، 'نثريات'
  TextColumn get note => text().nullable()();
  IntColumn get shiftId => integer().nullable()(); // link to current active shift
}
