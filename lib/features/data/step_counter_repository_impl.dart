import 'dart:async';

import 'package:beam/features/data/datasources/steps/step_counter_local_data_source.dart';
import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/entities/steps/ongoing_daily_step_count.dart';
import 'package:beam/features/domain/repositories/step_counter_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class StepCounterRepositoryImpl implements StepCounterRepository {
  final StepCounterLocalDataSource _stepCounterLocalDataSource;

  final _ongoingDailyStepCountStreamController =
      BehaviorSubject<OngoingDailyStepCount>();
  bool _isOngoingDailyStepCountInitialized = false;

  StepCounterRepositoryImpl(this._stepCounterLocalDataSource);

  @override
  Stream<OngoingDailyStepCount> observeOngoingDailyStepCount() {
    if (!_isOngoingDailyStepCountInitialized) {
      _isOngoingDailyStepCountInitialized = true;
      _ongoingDailyStepCountStreamController.sink.addStream(Stream.fromFuture(
          _stepCounterLocalDataSource.getOngoingDailyStepCount()));
    }
    return _ongoingDailyStepCountStreamController.stream;
  }

  @override
  Future<void> updateDailyStepCount(DailyStepCount stepCount) {
    // TODO: implement updateDailyStepCount
    throw UnimplementedError();
  }

  @override
  Future<void> updateOngoingDailyStepCount(
      OngoingDailyStepCount ongoingDailyStepCount) async {
    await _stepCounterLocalDataSource
        .updateOngoingDailyStepCount(ongoingDailyStepCount);
    _ongoingDailyStepCountStreamController.sink.add(ongoingDailyStepCount);
  }
}
