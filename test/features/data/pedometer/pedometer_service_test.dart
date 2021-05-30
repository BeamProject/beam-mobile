import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/pedometer/pedometer_service.dart';
import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;

void increaseMapCounter(Map<String, int> map, String key) {
  final currentValue = map[key] ?? 0;
  map[key] = currentValue + 1;
}

void mockChannelMethodToReturnValue(
    MethodChannel channel, String methodName, dynamic value) {
  channel.setMockMethodCallHandler((call) async {
    if (call.method == methodName) {
      return value;
    }
    throw Exception("Unexpected method called on the mocked channel");
  });
}

void sendValueToEventChannel(String channelName, dynamic value) {
  ServicesBinding.instance?.defaultBinaryMessenger.handlePlatformMessage(
      channelName,
      const StandardMethodCodec().encodeSuccessEnvelope(value),
      (ByteData? data) {});
}

void mockEventChannelToStreamValues<T>(
    MethodChannel backingMethodChannel, List<T> values) {
  backingMethodChannel.setMockMethodCallHandler((_) async {
    for (final value in values) {
      sendValueToEventChannel(backingMethodChannel.name, value);
    }
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('plugins.beam/step_counter_plugin');
  const MethodChannel serviceStatusChannel =
      MethodChannel('plugins.beam/step_counter_service_status_plugin');
  const String isInitializedChannelMethod = "StepCounterService.isInitialized";
  const String stopServiceChannelMethod = "StepCounterService.stopService";
  Map<String, int> channelMethodCallCounter = {};

  setUp(() {
    channelMethodCallCounter = {};
    channel.setMockMethodCallHandler((call) async {
      increaseMapCounter(channelMethodCallCounter, call.method);
    });
    serviceStatusChannel.setMockMethodCallHandler((call) async {});
    configureDependencies(injectable.Environment.test);
  });

  tearDown(() {
    IsolateNameServer.removePortNameMapping("step_tracker_send_port");
    serviceStatusChannel.setMockMethodCallHandler((_) async {});
    getIt.reset();
  });

  test('isInitialized', () {
    final pedometerService = getIt<PedometerService>();
    mockChannelMethodToReturnValue(channel, isInitializedChannelMethod, true);

    expect(pedometerService.isInitialized(), completion(equals(true)));
  });

  test('stopService', () async {
    final pedometerService = getIt<PedometerService>();

    await pedometerService.stopService();

    expect(channelMethodCallCounter[stopServiceChannelMethod], 1);
  });

  test('observeServiceStatus', () async {
    final pedometerService = getIt<PedometerService>();
    mockChannelMethodToReturnValue(channel, isInitializedChannelMethod, false);
    mockEventChannelToStreamValues(serviceStatusChannel, [true, false, true]);

    Stream<bool> serviceStatusStream = pedometerService.observeServiceStatus();

    await expectLater(
        serviceStatusStream, emitsInOrder([false, true, false, true]));
  });

  test('observeDailyStepCount, service not initialized noop', () async {
    final pedometerService = getIt<PedometerService>();
    mockChannelMethodToReturnValue(channel, isInitializedChannelMethod, false);
    sendValueToEventChannel(serviceStatusChannel.name, false);
    mockEventChannelToStreamValues(serviceStatusChannel, [false]);

    Stream<DailyStepCount> dailyStepCountStream =
        pedometerService.observeDailyStepCount();

    final isStreamEmptyFuture = dailyStepCountStream.isEmpty
        .timeout(Duration(seconds: 1), onTimeout: () => true);
    expect(isStreamEmptyFuture, completion(true));
  });

  test('observeDailyStepCount, service initialized, no events sent, noop',
      () async {
    final pedometerService = getIt<PedometerService>();
    mockChannelMethodToReturnValue(channel, isInitializedChannelMethod, true);
    IsolateNameServer.registerPortWithName(
        ReceivePort().sendPort, "step_tracker_send_port");

    Stream<DailyStepCount> dailyStepCountStream =
        pedometerService.observeDailyStepCount();

    final isStreamEmptyFuture = dailyStepCountStream.isEmpty
        .timeout(Duration(seconds: 1), onTimeout: () => true);
    expect(isStreamEmptyFuture, completion(true));
  });

  test('observeDailyStepCount', () async {
    final pedometerService = getIt<PedometerService>();
    final isServiceInitializedCompleter = Completer<bool>();
    mockChannelMethodToReturnValue(channel, isInitializedChannelMethod,
        isServiceInitializedCompleter.future);
    final stepCountEvents = [
      [1000, DateTime.utc(2020, 11, 9).toString()],
      [5000, DateTime.utc(2020, 11, 9).toString()],
      [2000, DateTime.utc(2020, 11, 10).toString()],
    ];

    Stream<DailyStepCount> dailyStepCountStream =
        pedometerService.observeDailyStepCount();

    final stepTrackerReceivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(
        stepTrackerReceivePort.sendPort, "step_tracker_send_port");
    stepTrackerReceivePort.listen((message) {
      if (message is SendPort) {
        stepCountEvents.forEach((element) => message.send(element));
      }
    });

    isServiceInitializedCompleter.complete(true);
    await expectLater(
        dailyStepCountStream,
        emitsInOrder([
          DailyStepCount(
              steps: 1000, dayOfMeasurement: DateTime.utc(2020, 11, 9)),
          DailyStepCount(
              steps: 5000, dayOfMeasurement: DateTime.utc(2020, 11, 9)),
          DailyStepCount(
              steps: 2000, dayOfMeasurement: DateTime.utc(2020, 11, 10))
        ]));
  });

  test('observeDailyStepCount, multiple calls', () async {
    final pedometerService = getIt<PedometerService>();
    mockChannelMethodToReturnValue(channel, isInitializedChannelMethod, true);
    final stepTrackerReceivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(
        stepTrackerReceivePort.sendPort, "step_tracker_send_port");
    var sendPortEventCounter = 0;
    var stepTrackerReceivePortMessageReceived = Completer();
    stepTrackerReceivePort.listen((message) {
      if (message is SendPort) {
        sendPortEventCounter++;
        stepTrackerReceivePortMessageReceived.complete();
      }
    });

    pedometerService.observeDailyStepCount();
    await stepTrackerReceivePortMessageReceived.future;
    stepTrackerReceivePortMessageReceived = Completer();
    pedometerService.observeDailyStepCount();
    await stepTrackerReceivePortMessageReceived.future;
    expect(sendPortEventCounter, 2);
  });

  test(
      'observeDailyStepCount, subscription cancelled, subsciber sends its sendPort to unregister',
      () async {
    final pedometerService = getIt<PedometerService>();
    mockChannelMethodToReturnValue(channel, isInitializedChannelMethod, true);
    final stepTrackerReceivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(
        stepTrackerReceivePort.sendPort, "step_tracker_send_port");
    var sendPortEventCounter = 0;
    var stepTrackerReceivePortMessageReceived = Completer();
    stepTrackerReceivePort.listen((message) {
      if (message is SendPort) {
        sendPortEventCounter++;
        stepTrackerReceivePortMessageReceived.complete();
      }
    });

    Stream<DailyStepCount> dailyStepCountStream =
        pedometerService.observeDailyStepCount();
    await stepTrackerReceivePortMessageReceived.future;
    expect(sendPortEventCounter, 1);

    stepTrackerReceivePortMessageReceived = Completer();
    dailyStepCountStream.listen((_) {}).cancel();
    await stepTrackerReceivePortMessageReceived.future;
    expect(sendPortEventCounter, 2);
  }, timeout: Timeout(Duration(seconds: 2)));

  test('observeDailyStepCount, multiple subscribers, only one cancels',
      () async {
    final pedometerService = getIt<PedometerService>();
    mockChannelMethodToReturnValue(channel, isInitializedChannelMethod, true);
    final stepTrackerReceivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(
        stepTrackerReceivePort.sendPort, "step_tracker_send_port");
    var sendPortEventCounter = 0;
    var stepTrackerReceivePortMessageReceived = Completer();
    stepTrackerReceivePort.listen((message) {
      if (message is SendPort) {
        sendPortEventCounter++;
        stepTrackerReceivePortMessageReceived.complete();
      }
    });

    Stream<DailyStepCount> dailyStepCountStream =
        pedometerService.observeDailyStepCount();
    await stepTrackerReceivePortMessageReceived.future;
    expect(sendPortEventCounter, 1);

    stepTrackerReceivePortMessageReceived = Completer();
    dailyStepCountStream.listen((_) {});
    dailyStepCountStream.listen((_) {}).cancel();
    // This is a best-effort attempt to prove that the sendport message
    // is never sent. We just verify that the future times out after few seconds.
    final waitForSendPortFuture = stepTrackerReceivePortMessageReceived.future
        .timeout(Duration(seconds: 2));
    expect(waitForSendPortFuture, throwsA((e) => e is TimeoutException));
    expect(sendPortEventCounter, 1);
  });
}
