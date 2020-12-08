import 'dart:async';

import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/repositories/steps_repository.dart';
import 'package:beam/features/domain/repositories/step_counter_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class ObserveStepCount {
  final StepCounterService _stepCounterService;
  final StepsRepository _stepsRepository;

  ObserveStepCount(this._stepCounterService, this._stepsRepository);

  Stream<DailyStepCount> call() async* {
    yield await _stepsRepository.getDailyStepCount(DateTime.now());
    yield* _stepCounterService.observeDailyStepCount();
  }
}
