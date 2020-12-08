import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/pedometer/step_tracker.dart';
import 'package:beam/features/domain/usecases/update_daily_step_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

void callbackDispatcher() {
  const MethodChannel _backgroundChannel =
      MethodChannel('plugins.beam/step_counter_plugin_background');

  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies(Environment.prod);
  final stepTracker = getIt<StepTracker>();
  final updateDailyStepCount = getIt<UpdateDailyStepCount>();

  // TODO: This callback registration can race with the actual calls sent by the service.
  // Fix this.
  _backgroundChannel.setMethodCallHandler((call) async {
    if (call.method == 'serviceStarted') {
      await stepTracker.startCountingSteps();
     _backgroundChannel.invokeMethod("step_tracker_initialized");
    } else if (call.method == 'serviceStopped') {
      stepTracker.stopCountingSteps();
    }
  });

  final List<SendPort> stepTrackerObserverPorts = [];
  stepTracker.totalDailyStepCountStream.listen((stepCount) {
    log("Daily step count ${stepCount.steps}, day: ${stepCount.dayOfMeasurement}");
    updateDailyStepCount(stepCount);
    stepTrackerObserverPorts.forEach((sendPort) {
      sendPort.send([stepCount.steps, stepCount.dayOfMeasurement.toString()]);
    });
  });

  final stepTrackerReceivePort = ReceivePort();
  IsolateNameServer.registerPortWithName(stepTrackerReceivePort.sendPort, "step_tracker_send_port");
  stepTrackerReceivePort.listen((message) {
    if (message is SendPort) {
      final observerPort = message;
      if (stepTrackerObserverPorts.contains(observerPort)) {
        stepTrackerObserverPorts.remove(message);
      } else {
        stepTrackerObserverPorts.add(message);
      }
    } else {
      log("callbackDispatcher: received $message is not a SendPort");
    }
  });
}
