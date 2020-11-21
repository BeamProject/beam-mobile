import 'dart:async';

import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/repositories/step_counter_repository.dart';
import 'package:beam/features/domain/repositories/step_counter_service.dart';
import 'package:injectable/injectable.dart';

import 'ongoing_daily_step_count.dart';

@lazySingleton
class StepTracker {
  final StepCounterService _stepCounterService;
  final StepCounterRepository _stepCounterRepository;
  StreamSubscription<StepCountEvent> _stepCountEventStreamSubscription;
  Stream<StepCountEvent> _stepCountEventStream;

  StepTracker(this._stepCounterService, this._stepCounterRepository);

  Stream<StepCountEvent> startStepTracking() {
    if (_stepCountEventStreamSubscription != null) {
      return _stepCountEventStream;
    }

    _stepCountEventStream = _stepCounterService.observeStepCountEvents();

    _stepCountEventStreamSubscription =
        _stepCountEventStream.listen((stepCountEvent) async {
      OngoingDailyStepCount ongoingDailyStepCount =
          await _stepCounterRepository.observeOngoingDailyStepCount().first;
      OngoingDailyStepCount newOnGoingDailyStepCount;

      if (ongoingDailyStepCount == null) {
        newOnGoingDailyStepCount =
            OngoingDailyStepCount.createNewFromStepCountEvent(stepCountEvent);
      } else {
        newOnGoingDailyStepCount =
            ongoingDailyStepCount.createWithNewStepCountEvent(stepCountEvent);
        if (newOnGoingDailyStepCount
            .isDayOfMeasurementAfter(ongoingDailyStepCount)) {
          await _stepCounterRepository.updateDailyStepCount(DailyStepCount(
              ongoingDailyStepCount.totalSteps,
              ongoingDailyStepCount.dayOfMeasurement));
        }
      }

      await _stepCounterRepository
          .updateOngoingDailyStepCount(newOnGoingDailyStepCount);
    })
          ..onError((error) {
            _stepCountEventStreamSubscription.cancel();
            _stepCountEventStreamSubscription = null;
          });

    return _stepCountEventStream;
  }

  void stopStepTracking() {
    if (_stepCountEventStreamSubscription != null) {
      _stepCountEventStreamSubscription.cancel();
      _stepCountEventStreamSubscription = null;
    }
  }
}
