import 'package:beam/features/domain/entities/steps/daily_step_count.dart';

abstract class StepsRepository {
  Future<DailyStepCount> getDailyStepCount(DateTime day);

  Future<void> updateDailyStepCount(DailyStepCount stepCount);
}