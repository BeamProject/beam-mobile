
import 'package:beam/features/data/pedometer/pedometer_service.dart';
import 'package:beam/features/domain/repositories/step_counter_service.dart';
import 'package:injectable/injectable.dart';

@module
abstract class PedometerModule {
  @Injectable(env: [Environment.prod])
  StepCounterService stepCounterService(PedometerService pedometerService) =>
      pedometerService;
}
