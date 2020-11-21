import 'package:beam/features/domain/entities/steps/ongoing_daily_step_count.dart';

abstract class StepCounterLocalDataSource {
  Future<OngoingDailyStepCount> getOngoingDailyStepCount();

  Future<void> updateOngoingDailyStepCount(OngoingDailyStepCount stepCount);
}