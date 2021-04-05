import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/datasources/settings_local_data_source.dart';
import 'package:beam/features/data/pedometer/step_tracker.dart';
import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/usecases/get_daily_step_count.dart';
import 'package:beam/features/domain/usecases/get_last_step_count_measurement.dart';
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

Future<void> updateDailyStepCountBetweenTimes(
    DateTime fromLocal,
    DateTime toLocal,
    MethodChannel backgroundChannel,
    GetDailyStepCount getDailyStepCount,
    UpdateDailyStepCount updateDailyStepCount) async {
  assert(fromLocal.isSameDate(toLocal));
  final stepCountData = await backgroundChannel
      .invokeMethod("query_step_count_data", <String, dynamic>{
    // Passing utc time because toIso8601String returns a format without a
    // timezone offset for local timezone and swift cannot parse it.
    // toIso8601String for UTC dates returns a correct format and the ios
    // counterpart should convert utc back to local when querying for pedometer
    // data.
    "from": fromLocal.toUtc().toIso8601String(),
    "to": toLocal.toUtc().toIso8601String()
  });
  print(
      "step count from: ${fromLocal.toIso8601String()} to ${toLocal.toIso8601String()}: ${stepCountData["steps"]}");
  var newSteps = stepCountData["steps"];
  if (newSteps < 0) {
    newSteps = 0;
  }
  final existingSteps = (await getDailyStepCount(fromLocal))?.steps ?? 0;
  final newStepCount = DailyStepCount(
      dayOfMeasurement: toLocal, steps: existingSteps + newSteps);
  return updateDailyStepCount(newStepCount);
}

Future<void> updateStepCountBetweenDates(
    DateTime fromLocal,
    DateTime toLocal,
    MethodChannel backgroundChannel,
    GetDailyStepCount getDailyStepCount,
    UpdateDailyStepCount updateDailyStepCount) async {
  var lastStepCountMeasurement = fromLocal;
  while (lastStepCountMeasurement.isBefore(toLocal) &&
      !toLocal.isSameDate(lastStepCountMeasurement)) {
    final nextDay = lastStepCountMeasurement.add(Duration(days: 1));
    final nextMidnight = DateTime(nextDay.year, nextDay.month, nextDay.day);
    await updateDailyStepCountBetweenTimes(
        lastStepCountMeasurement,
        nextMidnight.subtract(Duration(seconds: 1)),
        backgroundChannel,
        getDailyStepCount,
        updateDailyStepCount);
    lastStepCountMeasurement = nextMidnight;
  }
  if (toLocal.isSameDate(lastStepCountMeasurement)) {
    await updateDailyStepCountBetweenTimes(lastStepCountMeasurement, toLocal,
        backgroundChannel, getDailyStepCount, updateDailyStepCount);
  }
}

void callbackDispatcher() {
  const MethodChannel backgroundChannel =
      MethodChannel('plugins.beam/step_counter_plugin_background');

  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies(Environment.prod);
  final stepTracker = getIt<StepTracker>();
  final updateDailyStepCount = getIt<UpdateDailyStepCount>();
  final getDailyStepCount = getIt<GetDailyStepCount>();
  final getLastStepCountMeasurement = getIt<GetLastStepCountMeasurement>();
  final settingsLocalDataSource = getIt<SettingsLocalDataSource>();

  // TODO: This callback registration can race with the actual calls sent by the service.
  // Fix this.
  backgroundChannel.setMethodCallHandler((call) async {
    if (call.method == 'isServiceEnabled') {
      return settingsLocalDataSource.isStepCounterServiceEnabled();
    }
    if (call.method == 'serviceStarted') {
      if (Platform.isIOS) {
        var lastStepCountMeasurement =
            (await getLastStepCountMeasurement()).toLocal();
        final now = DateTime.now();
        await updateStepCountBetweenDates(lastStepCountMeasurement, now,
            backgroundChannel, getDailyStepCount, updateDailyStepCount);
      }
      await stepTracker.startCountingSteps();
      backgroundChannel.invokeMethod("step_tracker_initialized");
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
  IsolateNameServer.registerPortWithName(
      stepTrackerReceivePort.sendPort, "step_tracker_send_port");
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

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  bool isOneDayBefore(DateTime other) {
    final otherMinusOneDay = other.subtract(Duration(days: 1));
    return this.year == otherMinusOneDay.year &&
        this.month == otherMinusOneDay.month &&
        this.day == otherMinusOneDay.day;
  }
}
