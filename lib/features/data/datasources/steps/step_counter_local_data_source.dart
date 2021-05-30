import 'package:beam/features/domain/entities/steps/daily_step_count.dart';

abstract class StepCounterLocalDataSource {
  Future<List<DailyStepCount>> getDailyStepCounts(DateTime day);

  Future<List<DailyStepCount>> getDailyStepCountRange(DateTime from, DateTime to);

  Future<void> updateDailyStepCount(DailyStepCount stepCount);

  Future<void> updateLastMeasurementTimestamp(int timestampMsSinceEpoch);

  Future<int?> getLastMeasurementTimestamp();
}