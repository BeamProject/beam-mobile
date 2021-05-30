import 'package:beam/features/data/datasources/steps/step_counter_local_data_source.dart';
import 'package:beam/features/data/local/model/daily_step_count_data.dart';
import 'package:beam/features/data/local/model/last_measurement_data.dart';
import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton
class StepCounterStorage implements StepCounterLocalDataSource {
  static const DATABASE_NAME = "beam_database.db";
  static const STEPS_TABLE_NAME = "steps";
  static const LAST_STEPS_MEASUREMENT_TABLE_NAME = "last_measurement";

  static Database? _database;

  Future<Database> get database async {
    var database = _database;
    if (database == null) {
      database = await _initDatabase();
      _database = database;
    }
    return database;
  }

  Future<Database> _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Remove the comments below.
    // log("CLEARING THE DATABASE...");
    // deleteDatabase(join(await getDatabasesPath(), DATABASE_NAME));
    return openDatabase(join(await getDatabasesPath(), DATABASE_NAME),
        onCreate: (db, version) async {
      await db.execute('''
            CREATE TABLE $STEPS_TABLE_NAME(
              ${DailyStepCountData.COLUMN_ID} INTEGER PRIMARY KEY, 
              ${DailyStepCountData.COLUMN_STEPS} INTEGER,
              ${DailyStepCountData.COLUMN_DAY_OF_MEASUREMENT} TEXT UNIQUE)
              ''');
      return db.execute('''
            CREATE TABLE $LAST_STEPS_MEASUREMENT_TABLE_NAME(
              id INTEGER PRIMARY KEY CHECK (id = 0),
              ${LastMeasurementData.COLUMN_TIMESTAMP_MS} INTEGER)
              ''');
    }, version: 1);
  }

  @override
  Future<List<DailyStepCount>> getDailyStepCounts(DateTime day) async {
    return _getDailyStepCountData(day)
        .then((value) => convertToDailyStepCount(value));
  }

  @override
  Future<List<DailyStepCount>> getDailyStepCountRange(
      DateTime from, DateTime to) {
    return _getDailyStepCountDataRange(from, to)
        .then((value) => convertToDailyStepCount(value));
  }

  @override
  Future<void> updateDailyStepCount(DailyStepCount dailyStepCount) async {
    final dailyStepCountData = DailyStepCountData(dailyStepCount);
    final db = await database;
    await db.insert(STEPS_TABLE_NAME, dailyStepCountData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateLastMeasurementTimestamp(int timestampMsSinceEpoch) async {
    final db = await database;
    await db.insert(LAST_STEPS_MEASUREMENT_TABLE_NAME,
        LastMeasurementData(timestampMsSinceEpoch).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<int?> getLastMeasurementTimestamp() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(LAST_STEPS_MEASUREMENT_TABLE_NAME);
    if (maps.isEmpty) {
      return null;
    }
    return LastMeasurementData.fromMap(maps[0]).millisecondsSinceEpochInUtc;
  }

  List<DailyStepCount> convertToDailyStepCount(
      List<DailyStepCountData> dailyStepCountDataList) {
    return dailyStepCountDataList
        .map((dailyStepCountData) => dailyStepCountData.toDailyStepCount())
        .toList();
  }

  Future<List<DailyStepCountData>> _getDailyStepCountData(
      DateTime dayOfMeasurement) async {
    return _getDailyStepCountDataRange(dayOfMeasurement, dayOfMeasurement);
  }

  Future<List<DailyStepCountData>> _getDailyStepCountDataRange(
      DateTime from, DateTime to) async {
    return _getDailyStepCountDataWithWhereClause(
        "${DailyStepCountData.COLUMN_DAY_OF_MEASUREMENT} BETWEEN ? AND ?", [
      DailyStepCountData.dateFormat.format(from),
      DailyStepCountData.dateFormat.format(to)
    ]);
  }

  Future<List<DailyStepCountData>> _getDailyStepCountDataWithWhereClause(
      String where, List<dynamic> whereArgs) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(STEPS_TABLE_NAME, where: where, whereArgs: whereArgs);
    return maps
        .map((stepCountMap) => DailyStepCountData.fromMap(stepCountMap))
        .toList();
  }
}
