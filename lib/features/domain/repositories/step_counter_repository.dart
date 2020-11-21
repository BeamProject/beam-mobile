import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/entities/steps/ongoing_daily_step_count.dart';

abstract class StepCounterRepository {
  Future<void> updateOngoingDailyStepCount(OngoingDailyStepCount ongoingDailyStepCount);

  Stream<OngoingDailyStepCount> observeOngoingDailyStepCount();

  Future<void> updateDailyStepCount(DailyStepCount stepCount);
}