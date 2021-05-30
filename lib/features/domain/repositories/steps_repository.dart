import 'package:beam/features/domain/entities/steps/daily_step_count.dart';

abstract class StepsRepository {
  Future<DailyStepCount?> getDailyStepCount(DateTime day);

  Future<void> updateDailyStepCount(DailyStepCount stepCount);

  Future<void> updateLastStepCountMeasurement(DateTime dateTime);

  // Returns last measurement date in utc format.
  Future<DateTime?> getLastStepCountMeasurement();

  Future<List<DailyStepCount>> getDailyStepCountRange(DateTime from, DateTime to);
}