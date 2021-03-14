import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:beam/features/data/datasources/settings_local_data_source.dart';
import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/repositories/step_counter_service.dart';
import 'package:beam/features/domain/usecases/update_last_step_count_measurement.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'callback_dispatcher.dart';

// TODO: Revisit if this can be non-singleton
/*
To support iOS, store the value of the step counter service in shared prefs
Whenever this object is constructed (or when first observer is registered), check for the
value of the shared prefs and call startService() if it's set to true.

startService() should check if the shared prefs value is true (which means that the service should be running).
If the value is false, it should:
- set the value to true.
- update the last time of step count measurement to now(), so that we don't
  accidentally count the steps that were measured when the service was stopped.
If the prefs value was true when startService was called, the service shouldn't update the last time of measurement.
It should only invoke the channel method to make sure that the flutter plugin correctly starts the service.

stopService() should clear the shared prefs value.

The ios FlutterPlugin should register methodchannel and eventchannel for step_counter_plugin
and step_counter_service_status_plugin (same as Android). When it receives startService
method call, it can just start the background flutter engine and run callbackDispatcher there.
Basically rewrite the Android's private fun initializeEngine(callbackHandle: Long?) { .. }
to Swift.
It should also listen to the if (call.method == "step_tracker_initialized") { .. }
call from the dispatcher and notify that the service is initialized.

*/
@lazySingleton
class PedometerService implements StepCounterService {
  static const MethodChannel _channel =
      MethodChannel('plugins.beam/step_counter_plugin');
  static const EventChannel _serviceStatuschannel =
      EventChannel('plugins.beam/step_counter_service_status_plugin');

  final SettingsLocalDataSource _settingsLocalDataSource;
  final UpdateLastStepCountMeasurement _updateLastStepCountMeasurement;
  bool _isFirstObserver = true;
  SendPort _stepTrackerSendPort;
  Stream<bool> _channelStream;

  PedometerService(
      this._settingsLocalDataSource, this._updateLastStepCountMeasurement);

  @override
  Stream<DailyStepCount> observeDailyStepCount() {
    if (_isFirstObserver) {
      _isFirstObserver = false;
      _maybeStartService();
    }
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

    final isStepTrackerServiceEnabled =
        await _settingsLocalDataSource.isStepCounterServiceEnabled();
    if (!isStepTrackerServiceEnabled) {
      await _settingsLocalDataSource.setStepCounterServiceEnabled(true);
      await _updateLastStepCountMeasurement(DateTime.now());
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
    await _settingsLocalDataSource.setStepCounterServiceEnabled(false);
    print("Invoking stopService");
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

  Future<void> _maybeStartService() async {
    final isStepTrackerServiceEnabled =
        await _settingsLocalDataSource.isStepCounterServiceEnabled();
    if (isStepTrackerServiceEnabled) {
      startService();
    }
  }
}
