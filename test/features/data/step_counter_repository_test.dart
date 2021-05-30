import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/datasources/testing/datasources_module.mocks.dart';
import 'package:beam/features/data/step_counter_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

void main() {
  late MockStepCounterLocalDataSource mockStepCounterLocalDataSource;

  setUp(() {
    configureDependencies(injectable.Environment.test);
    mockStepCounterLocalDataSource = getIt<MockStepCounterLocalDataSource>();
  });

  tearDown(() {
    getIt.reset();
  });

  test('updateLastStepCountMeasurement', () {
    final stepCounterRepositoryImpl = getIt<StepCounterRepositoryImpl>();
    DateTime date = DateTime(2015, 05, 13);

    stepCounterRepositoryImpl.updateLastStepCountMeasurement(date);

    verify(mockStepCounterLocalDataSource
        .updateLastMeasurementTimestamp(date.millisecondsSinceEpoch));
  });

  test('getLastStepCountMeasurement', () {
    final stepCounterRepositoryImpl = getIt<StepCounterRepositoryImpl>();
    DateTime date = DateTime(2015, 05, 13, 13, 25);

    stepCounterRepositoryImpl.updateLastStepCountMeasurement(date);

    when(mockStepCounterLocalDataSource.getLastMeasurementTimestamp())
        .thenAnswer((_) => Future.value(date.millisecondsSinceEpoch));
    expect(stepCounterRepositoryImpl.getLastStepCountMeasurement(),
        completion(date));
  });
}
