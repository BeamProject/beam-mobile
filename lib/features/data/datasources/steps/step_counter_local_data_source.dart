import 'package:beam/features/domain/entities/steps/step_count.dart';

abstract class StepCounterLocalDataSource {
  Future<StepCount> getLatestStepCount();

  Future<void> updateStepCount(StepCount stepCount);
}