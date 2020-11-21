import 'package:beam/features/data/datasources/steps/step_counter_local_data_source.dart';
import 'package:beam/features/data/local/model/step_count_data.dart';
import 'package:beam/features/domain/entities/steps/ongoing_daily_step_count.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@injectable
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
    // deleteDatabase(join(await getDatabasesPath(), DATABASE_NAME));
    return openDatabase(join(await getDatabasesPath(), DATABASE_NAME),
        onCreate: (db, version) {
      return db.execute('''
            CREATE TABLE $STEPS_TABLE_NAME(
              ${OngoingDailyStepCountData.COLUMN_ID} integer primary key autoincrement, 
              ${OngoingDailyStepCountData.COLUMN_STEP_COUNT_AT_START_OF_THE_DAY} integer,
              ${OngoingDailyStepCountData.COLUMN_STEP_COUNT_AT_LAST_MEASUREMENT} integer,
              ${OngoingDailyStepCountData.COLUMN_DAY_OF_MEASUREMENT} text)
              ''');
    }, version: 1);
  }

  @override
  Future<OngoingDailyStepCount> getOngoingDailyStepCount() async {
    OngoingDailyStepCountData stepCountData = await _getLatestStepCountData();
    return stepCountData != null
        ? OngoingDailyStepCount(
            dayOfMeasurement: DateTime.parse(stepCountData.dayOfMeasurement),
            stepCountAtStartOfTheDay: stepCountData.stepCountAtStartOfTheDay,
            stepCountAtLastMeasurement:
                stepCountData.stepCountAtLastMeasurement)
        : null;
  }

  Future<OngoingDailyStepCountData> _getLatestStepCountData() async {
    final db = await database;
    final List<Map<String, dynamic>> stepCountMaps = await db.query(
        STEPS_TABLE_NAME,
        orderBy: "${OngoingDailyStepCountData.COLUMN_DAY_OF_MEASUREMENT} DESC",
        limit: 1);
    return stepCountMaps.isNotEmpty
        ? OngoingDailyStepCountData.fromMap(stepCountMaps[0])
        : null;
  }

  @override
  Future<void> updateOngoingDailyStepCount(
      OngoingDailyStepCount stepCount) async {
    OngoingDailyStepCountData stepCountData = OngoingDailyStepCountData(
        dayOfMeasurement: stepCount.dayOfMeasurement,
        stepCountAtStartOfTheDay: stepCount.stepCountAtStartOfTheDay,
        stepCountAtLastMeasurement: stepCount.stepCountAtLastMeasurement);
    OngoingDailyStepCountData latestStepCountData =
        await _getLatestStepCountData();
    final db = await database;
    if (latestStepCountData != null) {
      // We only ever need to keep one record in the table for ongoingDailyStepCount.
      // There is only ever one ongoing daily step count and it resets every day.
      return db.update(STEPS_TABLE_NAME, stepCountData.toMap(),
          where: "id = ?", whereArgs: [stepCountData.id]);
    }
    return db.insert(STEPS_TABLE_NAME, stepCountData.toMap());
  }
}
