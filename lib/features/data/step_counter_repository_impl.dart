import 'dart:async';
import 'dart:developer';

import 'package:beam/features/data/datasources/steps/step_counter_local_data_source.dart';
import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/repositories/steps_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class StepCounterRepositoryImpl implements StepsRepository {
  final StepCounterLocalDataSource _stepCounterLocalDataSource;

  StepCounterRepositoryImpl(this._stepCounterLocalDataSource);

  @override
  Future<void> updateDailyStepCount(DailyStepCount stepCount) async {
    log("updating daily step count ${stepCount.steps}, ${stepCount.dayOfMeasurement.toString()}");
    await _stepCounterLocalDataSource.updateDailyStepCount(stepCount);
    return _stepCounterLocalDataSource.updateLastMeasurementTimestamp(
        stepCount.dayOfMeasurement.millisecondsSinceEpoch);
  }

  @override
  Future<DailyStepCount> getDailyStepCount(DateTime day) async {
    final dailyStepCounts =
        await _stepCounterLocalDataSource.getDailyStepCounts(day);
    assert(dailyStepCounts.length <= 1,
        "There should only ever be one dailyStepCount event per day");
    if (dailyStepCounts.length == 1) {
      return dailyStepCounts[0];
    }
    return null;
  }

  @override
  Future<List<DailyStepCount>> getDailyStepCountRange(
      DateTime from, DateTime to) {
    return _stepCounterLocalDataSource.getDailyStepCountRange(from, to);
  }
}
