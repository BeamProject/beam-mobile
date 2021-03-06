import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/pedometer/step_tracker.dart';
import 'package:beam/features/domain/usecases/update_daily_step_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/*
iOS version:

In step count storage add a new table to store the time of the last measurement of steps.
Extend updateDailyStepCount(..) to also update the value of last time measurement.

Whenever callbackdispatcher receives the 'serviceStarted' methodcall it should:
- query the number of steps since last measurement until now via a native queryPedometerData(from:to:withHandler:) call.
  - if last measurement is not from the same day it can just query the data from the start of the day
  - in order not to lose historical data if beam is not opened for a few days, we can either gather data for every day since
    the last measurement first time when it's opened or we can run a daily background task around 01:00 am which gathers data from the 
    whole day and updates it in the database.
- call updateDailyStepCount(..) with the steps retrieved.


Otherwise, the step counting logic should just work as is when the app is in foreground.
The StepTracker continuously updates the step count and thus the last measurement.

*/

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
  stepTracker.totalDailyStepCountStream.listen((stepCount) async {
    await updateDailyStepCount(stepCount);
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
