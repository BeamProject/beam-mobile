import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/repositories/step_counter_service.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'callback_dispatcher.dart';

// TODO: Revisit if this can be non-singleton
@lazySingleton
class PedometerService implements StepCounterService {
  static const MethodChannel _channel =
      MethodChannel('plugins.beam/step_counter_plugin');
  static const EventChannel _serviceStatuschannel =
      EventChannel('plugins.beam/step_counter_service_status_plugin');

  SendPort _stepTrackerSendPort;
  Stream<bool> _channelStream;

  @override
  Stream<DailyStepCount> observeDailyStepCount() {
    log("observeDailyStepCount");
    final receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;
    StreamSubscription<bool> stepTrackingServiceStatusSubscription;
    bool isSendPortRegistered = false;
    stepTrackingServiceStatusSubscription =
        observeServiceStatus().listen((isInitialized) async {
      log("stepTrackingStatusSubscription ${isInitialized}");
      if (isInitialized && !isSendPortRegistered) {
        _stepTrackerSendPort =
            IsolateNameServer.lookupPortByName("step_tracker_send_port");
        _stepTrackerSendPort.send(sendPort);
        isSendPortRegistered = true;
        stepTrackingServiceStatusSubscription.cancel();
      }
    });

    Stream<DailyStepCount> dailyStepCountStream = receivePort.asBroadcastStream(
        onCancel: (subscription) async {
      log("dailyStepCountStream: onCancel");
      final stepTrackerSendPort = _stepTrackerSendPort;
      if (stepTrackerSendPort != null) {
        if (isSendPortRegistered) {
          // Sending the same sendPort for the second time cancels the connection
          // with the step tracker.
          stepTrackerSendPort.send(sendPort);
        }
      } else {
        log("dailyStepCountStream: stepTrackerSendPort is null");
      }
      stepTrackingServiceStatusSubscription.cancel();
      subscription.cancel();
    }).map((event) => DailyStepCount(
        steps: event[0], dayOfMeasurement: DateTime.parse(event[1])));

    return dailyStepCountStream;
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
  }

  @override
  Future<bool> isInitialized() {
    return _channel.invokeMethod("StepCounterService.isInitialized");
  }

  @override
  Future<void> stopService() async {
    await _channel.invokeMethod("StepCounterService.stopService");
  }

  @override
  Stream<bool> observeServiceStatus() async* {
    // We need to yield this first, because the channel stream does not
    // return the last streamed value. With this we achieve a behavior
    // of a BehaviorSubject.
    yield await isInitialized();
    // We have to cache the stream returned by receiveBroadcastStream because otherwise
    // we'd always close the stream last returned by that method, thus limiting the max
    // number of observers to one.
    if (_channelStream == null) {
      _channelStream = _serviceStatuschannel
          .receiveBroadcastStream()
          .map((event) => event as bool);
    }
    yield* _channelStream;
  }
}
