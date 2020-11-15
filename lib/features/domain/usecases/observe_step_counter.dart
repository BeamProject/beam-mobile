import 'dart:async';

import 'package:beam/features/domain/entities/steps/step_count.dart';
import 'package:beam/features/domain/repositories/step_counter_repository.dart';

class ObserveStepCounter {
  final StepCounterRepository _stepCounterRepository;


  ObserveStepCounter(this._stepCounterRepository);

  Stream<StepCount> call() {
    return _stepCounterRepository.observeStepCount();
  }
}
