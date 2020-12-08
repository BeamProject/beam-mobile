import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/repositories/step_counter_service.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'callback_dispatcher.dart';

@lazySingleton
class PedometerService implements StepCounterService {
  static const MethodChannel _channel =
      MethodChannel('plugins.beam/step_counter_plugin');

  Stream<DailyStepCount> _dailyStepCountStream;
  StreamController<bool> _stepTrackerStatusStreamController =
      BehaviorSubject<bool>();
  SendPort _stepTrackerSendPort;
  Stream<bool> get _stepTrackingStatusStream async* {
    yield await isInitialized();
    yield* _stepTrackerStatusStreamController.stream;
  }

  PedometerService() {  
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onServiceStatusChanged') {
        _stepTrackerStatusStreamController.sink.add(call.arguments);
      }
    });
  }

  @override
  Stream<DailyStepCount> observeDailyStepCount() {
    if (_dailyStepCountStream != null) {
      return _dailyStepCountStream;
    }
    final receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;
    _dailyStepCountStream = receivePort.asBroadcastStream(onCancel: (_) {
      log("_dailyStepCountStream: onCancel called");
      final stepTrackerSendPort = _stepTrackerSendPort;
      if (stepTrackerSendPort != null) {
        stepTrackerSendPort.send(sendPort);
      } else {
        log("_dailyStepCountStream: stepTrackerSendPort is null");
      }
    }).map((event) => DailyStepCount(steps: event[0], dayOfMeasurement: DateTime.parse(event[1])));

    StreamSubscription<bool> stepTrackingStatusSubscription;
    stepTrackingStatusSubscription =
        _stepTrackingStatusStream.listen((isInitialized) {
      if (isInitialized) {
        _stepTrackerSendPort = IsolateNameServer.lookupPortByName("step_tracker_send_port");
        _stepTrackerSendPort.send(sendPort);
        stepTrackingStatusSubscription.cancel();
      }
    });
    return _dailyStepCountStream;
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
    // _stepTrackerStatusStreamController.sink.add(true);
  }

  @override
  Future<bool> isInitialized() {
    return _channel.invokeMethod("StepCounterService.isInitialized");
  }

  @override
  Future<void> stopService() async {
    await _channel.invokeMethod("StepCounterService.stopService");
    // _stepTrackerStatusStreamController.sink.add(false);
  }

  @override
  Stream<bool> observeServiceStatus() {
    return _stepTrackingStatusStream;
  }
}
