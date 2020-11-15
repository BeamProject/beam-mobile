import 'dart:async';

import 'package:beam/features/data/datasources/steps/step_counter_local_data_source.dart';
import 'package:beam/features/data/datasources/steps/step_counter_service.dart';
import 'package:beam/features/domain/entities/steps/step_count.dart';
import 'package:beam/features/domain/repositories/step_counter_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class StepCounterRepositoryImpl implements StepCounterRepository {
  static const _persistStepCountTimeout = const Duration(seconds: 10);

  final StepCounterService _stepCounterService;
  final StepCounterLocalDataSource _stepCounterLocalDataSource;

  StepCount _latestStepCount;
  Stream<StepCount> _stepCountStream;
  Timer _persistStepCountTimer;

  StepCounterRepositoryImpl(
      this._stepCounterService, this._stepCounterLocalDataSource);

  @override
  Stream<StepCount> observeStepCount() {
    if (_stepCountStream != null) {
      return _stepCountStream;
    }

    _stepCountStream = _stepCounterService
        .observeStepCountEvents()
        .asyncMap((stepCountEvent) async {
      StepCount latestStepCount = await _getLatestStepCount();
      StepCount newStepCount;
      if (latestStepCount == null) {
        newStepCount = StepCount(
            dayOfMeasurement: stepCountEvent.dayOfMeasurement,
            steps: stepCountEvent.steps);
      } else {
        newStepCount = latestStepCount.createWithNewMeasurement(
            stepCountEvent.dayOfMeasurement, stepCountEvent.steps);
      }
      _updateLatestStepCount(newStepCount);
      return newStepCount;
    });

    return _stepCountStream;
  }

  Future<StepCount> _getLatestStepCount() async {
    if (_latestStepCount == null) {
      _updateLatestStepCount(
          await _stepCounterLocalDataSource.getLatestStepCount());
    }
    return _latestStepCount;
  }

  void _updateLatestStepCount(stepCount) {
    _latestStepCount = stepCount;

    _persistStepCountWithDelay();
  }

  void _persistStepCountWithDelay() {
    if (_persistStepCountTimer != null && _persistStepCountTimer.isActive) {
      _persistStepCountTimer.cancel();
    }
    _persistStepCountTimer = Timer(_persistStepCountTimeout, () {
      _stepCounterLocalDataSource.updateStepCount(_latestStepCount);
    });
  }
}
