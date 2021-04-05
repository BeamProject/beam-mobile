import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/datasources/testing/datasources_module.dart';
import 'package:beam/features/data/pedometer/callback_dispatcher.dart';
import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/usecases/get_daily_step_count.dart';
import 'package:beam/features/domain/usecases/update_daily_step_count.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

class MockMethodChannel {
  final _methodChannel;
  int invocationCount = 0;

  MockMethodChannel(this._methodChannel);

  void mockChannelMethodToReturnValues(
      String methodName, List<dynamic> values) {
    _methodChannel.setMockMethodCallHandler((call) async {
      if (call.method == methodName) {
        return values[invocationCount++];
      }
      throw Exception("Unexpected method called on the mocked channel");
    });
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  UpdateDailyStepCount updateDailyStepCount;
  GetDailyStepCount getDailyStepCount;
  MockStepCounterLocalDataSource mockStepCounterLocalDataSource;

  const MethodChannel backgroundChannel =
      MethodChannel('plugins.beam/step_counter_plugin_background');

  setUp(() {
    configureDependencies(injectable.Environment.test);
    updateDailyStepCount = getIt<UpdateDailyStepCount>();
    getDailyStepCount = getIt<GetDailyStepCount>();
    mockStepCounterLocalDataSource = getIt<MockStepCounterLocalDataSource>();
  });

  tearDown(() {
    backgroundChannel.setMockMethodCallHandler((_) async {});
    getIt.reset();
  });

  test('updateDailyStepCountBetweenDates', () async {
    final from = DateTime(2020, 03, 02, 10, 30);
    final to = DateTime(2020, 03, 02, 19, 30);
    MockMethodChannel(backgroundChannel)
        .mockChannelMethodToReturnValues("query_step_count_data", [
      {"steps": 300}
    ]);

    when(mockStepCounterLocalDataSource.getDailyStepCounts(from))
        .thenAnswer((_) => Future.value(
            [DailyStepCount(dayOfMeasurement: from, steps: 1000)]));

    await updateDailyStepCountBetweenTimes(from, to,
        backgroundChannel, getDailyStepCount, updateDailyStepCount);

    verify(mockStepCounterLocalDataSource.updateDailyStepCount(
        DailyStepCount(dayOfMeasurement: to, steps: 1300)));
  });

  test('updateStepCountBetweenDates', () async {
    var dates = [
      DateTime(2021, 03, 29, 14, 20),
      DateTime(2021, 03, 29, 23, 59, 59),
      DateTime(2021, 03, 30, 00, 00),
      DateTime(2021, 03, 30, 23, 59, 59),
      DateTime(2021, 03, 31, 00, 00),
      DateTime(2021, 03, 31, 23, 59, 59),
      DateTime(2021, 04, 01, 00, 00),
      DateTime(2021, 04, 01, 15, 00, 00),
    ];
    final historicalSteps = [
      {"steps": 1000},
      {"steps": 5000},
      {"steps": 3000},
      {"steps": 10000},
    ];
    MockMethodChannel(backgroundChannel).mockChannelMethodToReturnValues(
        "query_step_count_data", historicalSteps);
    for (final date in dates) {
      when(mockStepCounterLocalDataSource.getDailyStepCounts(date))
          .thenAnswer((_) => Future.value(
              [DailyStepCount(dayOfMeasurement: date, steps: 1000)]));
    }

    await updateStepCountBetweenDates(dates.first, dates.last,
        backgroundChannel, getDailyStepCount, updateDailyStepCount);

    verify(mockStepCounterLocalDataSource.updateDailyStepCount(DailyStepCount(
        dayOfMeasurement: DateTime(2021, 03, 29, 23, 59, 59),
        steps: 2000))).called(1);
    verify(mockStepCounterLocalDataSource.updateDailyStepCount(DailyStepCount(
        dayOfMeasurement: DateTime(2021, 03, 30, 23, 59, 59),
        steps: 6000))).called(1);
    verify(mockStepCounterLocalDataSource.updateDailyStepCount(DailyStepCount(
        dayOfMeasurement: DateTime(2021, 03, 31, 23, 59, 59),
        steps: 4000))).called(1);
    verify(mockStepCounterLocalDataSource.updateDailyStepCount(DailyStepCount(
        dayOfMeasurement: DateTime(2021, 04, 01, 15, 00),
        steps: 11000))).called(1);
  });
}
