import 'dart:async';
import 'dart:developer';

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

  StepTracker(this._stepCounterService, this._stepCounterRepository);

  Future<void> observeStepEvents() async {
    if (_stepCountEventStreamSubscription != null) {
      return;
    }

    // TODO: Extract the observeStepCountEvents from the StepCounterService to a separate
    // class. StepTracker doesn't need access to the API for stopping/starting the service.
    _stepCountEventStreamSubscription = _stepCounterService
        .observeStepCountEvents()
        .listen((stepCountEvent) async {
      // TODO: Remove this log when no longer necessary
      log("On step count event");
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
    });
  }

  void stopObservingStepEvents() {
    // TODO: When stopping the tracker, reset the ongoingDailyStepCount upon restart.
    // To preserve the todal daily steps update the DailyStepCount as well.
    // When tracking, always update the DailyStepCount with a new measuerement from the ongoingDailyStepCount.
    // Rename the stepCountAtStartOfTheDay to stepCountAtFirstMeasurement.
    // Also stop the foreground service when this method is called. Add a new method on the StepCounterService iface.
    if (_stepCountEventStreamSubscription != null) {
      _stepCountEventStreamSubscription.cancel();
      _stepCountEventStreamSubscription = null;
    }
  }
}
