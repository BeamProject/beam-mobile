import 'dart:async';
import 'dart:ui';

import 'package:beam/features/domain/entities/steps/ongoing_daily_step_count.dart';
import 'package:beam/features/domain/repositories/step_counter_service.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:pedometer/pedometer.dart';
import 'package:rxdart/rxdart.dart';

import 'callback_dispatcher.dart';

@lazySingleton
class PedometerService implements StepCounterService {
  static const MethodChannel _channel =
      MethodChannel('plugins.beam/step_counter_plugin');

  Stream<StepCountEvent> _stepCountEventStream;
  StreamController<bool> _stepTrackerStatusStreamController =
      BehaviorSubject<bool>();
  Stream<bool> get _stepTrackingStatusStream async* {
    yield await isInitialized();
    yield* _stepTrackerStatusStreamController.stream;
  }

  @override
  Stream<StepCountEvent> observeStepCountEvents() {
    if (_stepCountEventStream != null) {
      return _stepCountEventStream;
    }
    _stepCountEventStream = Pedometer.stepCountStream.map((stepCount) =>
        StepCountEvent(
            dayOfMeasurement: stepCount.timeStamp, steps: stepCount.steps));

    return _stepCountEventStream;
  }

  @override
  Future<void> startService() async {
    if (await isInitialized()) {
      return;
    }

    final CallbackHandle callback =
        PluginUtilities.getCallbackHandle(callbackDispatcher);
    await _channel.invokeMethod("StepCounterService.initializeService",
        <dynamic>[callback.toRawHandle()]);
    _stepTrackerStatusStreamController.sink.add(true);
  }

  @override
  Future<bool> isInitialized() {
    return _channel.invokeMethod("StepCounterService.isInitialized");
  }

  @override
  Future<void> stopService() async {
    await _channel.invokeMethod("StepCounterService.stopService");
    _stepTrackerStatusStreamController.sink.add(false);
  }

  @override
  Stream<bool> observeServiceStatus() {
    return _stepTrackingStatusStream;
  }
}
