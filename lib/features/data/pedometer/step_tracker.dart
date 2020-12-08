import 'dart:async';
import 'dart:developer';

import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/usecases/get_daily_step_count.dart';
import 'package:injectable/injectable.dart';
import 'package:pedometer/pedometer.dart';
import 'package:rxdart/rxdart.dart';

import 'ongoing_daily_step_count.dart';

@lazySingleton
class StepTracker {
  final GetDailyStepCount _getDailyStepCount;
  final BehaviorSubject<DailyStepCount> _totalDailyStepCountStreamController =
      BehaviorSubject();
  Stream<DailyStepCount> get totalDailyStepCountStream =>
      _totalDailyStepCountStreamController.stream;

  StreamSubscription<StepCount> _stepCountEventStreamSubscription;
  DailyStepCount _initialStepCount;
  OngoingDailyStepCount _ongoingDailyStepCount;

  StepTracker(this._getDailyStepCount);

  Future<void> startCountingSteps() async {
    if (_stepCountEventStreamSubscription != null) {
      return;
    }

    DateTime today = DateTime.now();
    _initialStepCount = (await _getDailyStepCount(today)) ??
        DailyStepCount(steps: 0, dayOfMeasurement: today);
    _stepCountEventStreamSubscription =
        Pedometer.stepCountStream.listen((stepCount) async {
      OngoingDailyStepCount newOnGoingDailyStepCount;
      DateTime today = DateTime.now();

      if (_ongoingDailyStepCount == null) {
        newOnGoingDailyStepCount =
            OngoingDailyStepCount.createNewFromStepCountEvent(stepCount);
      } else {
        newOnGoingDailyStepCount =
            _ongoingDailyStepCount.createWithNewStepCountEvent(stepCount);
      }

      if (_initialStepCount.dayOfMeasurement.isDayBefore(today)) {
        _initialStepCount = DailyStepCount(steps: 0, dayOfMeasurement: today);
      }

      _totalDailyStepCountStreamController.value = DailyStepCount(
          steps: _initialStepCount.steps + newOnGoingDailyStepCount.totalSteps,
          dayOfMeasurement: today);

      _ongoingDailyStepCount = newOnGoingDailyStepCount;
    });
  }

  void stopCountingSteps() {
    if (_stepCountEventStreamSubscription != null) {
      _stepCountEventStreamSubscription.cancel();
      _stepCountEventStreamSubscription = null;
    }
    _ongoingDailyStepCount = null;
  }
}
