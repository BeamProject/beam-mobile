
import 'package:beam/features/data/datasources/steps/step_counter_local_data_source.dart';
import 'package:beam/features/data/local/model/daily_step_count_data.dart';
import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton
class StepCounterStorage implements StepCounterLocalDataSource {
  static const DATABASE_NAME = "beam_database.db";
  static const STEPS_TABLE_NAME = "steps";

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    // FIXME: remove the line below.
    // log("CLEARING THE DATABASE...");
    // deleteDatabase(join(await getDatabasesPath(), DATABASE_NAME));
    return openDatabase(join(await getDatabasesPath(), DATABASE_NAME),
        onCreate: (db, version) {
      return db.execute('''
            CREATE TABLE $STEPS_TABLE_NAME(
              ${DailyStepCountData.COLUMN_ID} integer primary key autoincrement, 
              ${DailyStepCountData.COLUMN_STEPS} integer,
              ${DailyStepCountData.COLUMN_DAY_OF_MEASUREMENT} text)
              ''');
    }, version: 1);
  }

  @override
  Future<List<DailyStepCount>> getDailyStepCounts(DateTime day) async {
    final dailyStepCountDataList = await _getDailyStepCountData(day);
    return dailyStepCountDataList
        .map((dailyStepCountData) => dailyStepCountData.toDailyStepCount()).toList();
  }

  @override
  Future<void> updateDailyStepCount(DailyStepCount dailyStepCount) async {
    final dailyStepCountData = DailyStepCountData(dailyStepCount);
    final db = await database;
    final existingDailyStepCountDataList =
        await _getDailyStepCountData(dailyStepCount.dayOfMeasurement);
    if (existingDailyStepCountDataList.length == 1) {
      return db.update(STEPS_TABLE_NAME, dailyStepCountData.toMap(),
          where: "${DailyStepCountData.COLUMN_ID} = ?",
          whereArgs: [existingDailyStepCountDataList[0].id]);
    } else if (existingDailyStepCountDataList.length == 0) {
      return db.insert(STEPS_TABLE_NAME, dailyStepCountData.toMap());
    }
    throw Exception(
        "There's more than one DailyStepCountData in the database. Cannot update based on a date");
  }

  Future<List<DailyStepCountData>> _getDailyStepCountData(
      DateTime dayOfMeasurement) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        STEPS_TABLE_NAME,
        where: "${DailyStepCountData.COLUMN_DAY_OF_MEASUREMENT} = ?",
        whereArgs: [DailyStepCountData.dateFormat.format(dayOfMeasurement)]);
    return maps
        .map((stepCountMap) => DailyStepCountData.fromMap(stepCountMap)).toList();
  }
}
