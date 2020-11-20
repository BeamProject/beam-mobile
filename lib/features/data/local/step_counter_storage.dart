import 'package:beam/features/data/datasources/steps/step_counter_local_data_source.dart';
import 'package:beam/features/data/local/model/step_count_data.dart';
import 'package:beam/features/domain/entities/steps/step_count.dart';
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
              ${StepCountData.COLUMN_ID} integer primary key autoincrement, 
              ${StepCountData.COLUMN_STEP_COUNT_AT_START_OF_THE_DAY} integer,
              ${StepCountData.COLUMN_STEP_COUNT_AT_LAST_MEASUREMENT} integer,
              ${StepCountData.COLUMN_DAY_OF_MEASUREMENT} text)
              ''');
    }, version: 1);
  }

  @override
  Future<StepCount> getLatestStepCount() async {
    StepCountData stepCountData = await _getLatestStepCountData();
    return stepCountData != null
        ? StepCount(
            dayOfMeasurement: DateTime.parse(stepCountData.dayOfMeasurement),
            stepCountAtStartOfTheDay: stepCountData.stepCountAtStartOfTheDay,
            stepCountAtLastMeasurement: stepCountData.stepCountAtLastMeasurement)
        : null;
  }

  Future<StepCountData> _getLatestStepCountData() async {
    final db = await database;
    final List<Map<String, dynamic>> stepCountMaps = await db.query(
        STEPS_TABLE_NAME,
        orderBy: "${StepCountData.COLUMN_DAY_OF_MEASUREMENT} DESC",
        limit: 1);
    return stepCountMaps.isNotEmpty
        ? StepCountData.fromMap(stepCountMaps[0])
        : null;
  }

  @override
  Future<void> updateStepCount(StepCount stepCount) async {
    StepCountData stepCountData = StepCountData(
        dayOfMeasurement: stepCount.dayOfMeasurement,
        stepCountAtStartOfTheDay: stepCount.stepCountAtStartOfTheDay,
        stepCountAtLastMeasurement: stepCount.stepCountAtLastMeasurement);
    StepCountData latestStepCountData = await _getLatestStepCountData();
    final db = await database;
    if (latestStepCountData != null &&
        // FIXME: This logic doesn't belong here. Create an id field in the
        //  StepCount class and compare ids.
        latestStepCountData.dayOfMeasurement ==
            stepCountData.dayOfMeasurement) {
      return db.update(STEPS_TABLE_NAME, stepCountData.toMap(),
          where: "id = ?", whereArgs: [stepCountData.id]);
    }
    return db.insert(STEPS_TABLE_NAME, stepCountData.toMap());
  }
}
