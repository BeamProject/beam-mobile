import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/datasources/testing/datasources_module.dart';
import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/usecases/update_daily_step_count.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

void main() {
  MockStepCounterLocalDataSource mockStepCounterLocalDataSource;

  setUp(() {
    configureDependencies(injectable.Environment.test);
    mockStepCounterLocalDataSource = getIt<MockStepCounterLocalDataSource>();
  });

  tearDown(() {
    getIt.reset();
  });

  test('updateDailyStepCount', () async {
    final day = DateTime.parse("2020-03-27T01:00:00+0500");
    final updateDailyStepCount = getIt<UpdateDailyStepCount>();
    final dailyStepCount = DailyStepCount(dayOfMeasurement: day, steps: 5000);

    await updateDailyStepCount(dailyStepCount);

    verify(mockStepCounterLocalDataSource.updateDailyStepCount(dailyStepCount));
  });

  test('updateDailyStepCount updates last measurement', () async {
    final day = DateTime.parse("2020-03-27T01:00:00+0500");
    final updateDailyStepCount = getIt<UpdateDailyStepCount>();
    final dailyStepCount = DailyStepCount(dayOfMeasurement: day, steps: 5000);

    await updateDailyStepCount(dailyStepCount);

    verify(mockStepCounterLocalDataSource.updateLastMeasurementTimestamp(
        dailyStepCount.dayOfMeasurement.millisecondsSinceEpoch));
  });
}
