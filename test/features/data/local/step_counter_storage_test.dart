@Skip(
    "sqflite cannot run on the machine. RUN THIS COMMAND WHEN CONNECTED TO EMULATOR `flutter run test/features/data/local/step_counter_storage_test.dart`. If you run it on your device, it'll wipe your beam database.")

import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/local/step_counter_storage.dart';
import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  setUp(() async {
    configureDependencies(injectable.Environment.test);
  });

  tearDown(() async {
    getIt.reset();
  });

  tearDownAll(() async {
    deleteDatabase(
        join(await getDatabasesPath(), StepCounterStorage.DATABASE_NAME));
  });

  test('update daily step count', () async {
    final day = DateTime.parse("2010-07-20 15:18:00");
    final stepCounterStorage = getIt<StepCounterStorage>();

    await stepCounterStorage.updateDailyStepCount(
        DailyStepCount(steps: 1000, dayOfMeasurement: day));

    final dailyStepCounts = await stepCounterStorage.getDailyStepCounts(day);
    expect(dailyStepCounts.length, 1);
    expect(dailyStepCounts.first.steps, 1000);
  });

  test('update daily step count time zone', () async {
    final day = DateTime.parse("2020-03-27T01:00:00+0500");
    final stepCounterStorage = getIt<StepCounterStorage>();

    await stepCounterStorage.updateDailyStepCount(
        DailyStepCount(steps: 1000, dayOfMeasurement: day));

    final dailyStepCounts = await stepCounterStorage.getDailyStepCounts(day);
    expect(dailyStepCounts.length, 1);
    expect(dailyStepCounts.first.steps, 1000);
  });

  test('update last measurement', () async {
    final day = DateTime.parse("2020-03-27T01:00:00+0500");
    final stepCounterStorage = getIt<StepCounterStorage>();

    await stepCounterStorage
        .updateLastMeasurementTimestamp(day.millisecondsSinceEpoch);

    final lastMeasurementTimestamp =
        await stepCounterStorage.getLastMeasurementTimestamp();
    expect(lastMeasurementTimestamp, day.millisecondsSinceEpoch);
  });

  test('update last measurement, keeps only last value', () async {
    const DAYS_NUM = 20;
    final firstDay = DateTime.parse("2010-07-20 15:18:00");
    final days =
        List.generate(DAYS_NUM, (index) => firstDay.add(Duration(days: index)));
    final stepCounterStorage = getIt<StepCounterStorage>();

    for (var day in days) {
      await stepCounterStorage
          .updateLastMeasurementTimestamp(day.millisecondsSinceEpoch);
    }

    final lastMeasurementTimestamp =
        await stepCounterStorage.getLastMeasurementTimestamp();
    expect(
        lastMeasurementTimestamp, days[days.length - 1].millisecondsSinceEpoch);
  });

  test(
      'update daily step count multiple times per day. There is only one unique step entry per day',
      () async {
    const DAYS_NUM = 20;
    const STEP_LOGS_PER_DAY = 50;
    final firstDay = DateTime.parse("2010-07-20 15:18:00");
    final days =
        List.generate(DAYS_NUM, (index) => firstDay.add(Duration(days: index)));
    final stepCounterStorage = getIt<StepCounterStorage>();

    for (var day in days) {
      List.generate(
              STEP_LOGS_PER_DAY,
              (index) =>
                  DailyStepCount(steps: index * 200, dayOfMeasurement: day))
          .forEach((dailyStepCount) async {
        await stepCounterStorage.updateDailyStepCount(dailyStepCount);
      });

      final dailyStepCountList =
          await stepCounterStorage.getDailyStepCounts(day);
      expect(dailyStepCountList.length, 1);
      final lastStepCountOfTheDay = (STEP_LOGS_PER_DAY - 1) * 200;
      expect(dailyStepCountList.first.steps, lastStepCountOfTheDay);
    }
  });

  test('getDailyStepCountRange', () async {
    final dayOne = DateTime.parse("2011-07-20 00:18:00");
    final dayTwo = DateTime.parse("2011-07-21 02:18:00");
    final dayThree = DateTime.parse("2011-07-22 09:18:00");
    final stepCounterStorage = getIt<StepCounterStorage>();

    await stepCounterStorage.updateDailyStepCount(
        DailyStepCount(steps: 1000, dayOfMeasurement: dayOne));
    await stepCounterStorage.updateDailyStepCount(
        DailyStepCount(steps: 3000, dayOfMeasurement: dayTwo));
    await stepCounterStorage.updateDailyStepCount(
        DailyStepCount(steps: 7000, dayOfMeasurement: dayThree));

    final dailyStepCounts =
        await stepCounterStorage.getDailyStepCountRange(dayOne, dayThree);
    final dateFormat = DateFormat('yyyy-MM-dd');
    expect(dailyStepCounts,[
      DailyStepCount(
          dayOfMeasurement: dateFormat.parse("2011-07-20"), steps: 1000),
      DailyStepCount(
          dayOfMeasurement: dateFormat.parse("2011-07-21"), steps: 3000),
      DailyStepCount(
          dayOfMeasurement: dateFormat.parse("2011-07-22"), steps: 7000)
    ]);
  });
}
