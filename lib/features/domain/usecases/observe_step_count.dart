import 'dart:async';

import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/repositories/step_counter_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ObserveStepCount {
  final StepCounterRepository _stepCounterRepository;

  ObserveStepCount(this._stepCounterRepository);

  Stream<DailyStepCount> call() {
    return _stepCounterRepository.observeOngoingDailyStepCount().map(
        (ongoingDailyStepCount) => DailyStepCount(
            ongoingDailyStepCount.totalSteps,
            ongoingDailyStepCount.dayOfMeasurement));
  }
}
