import 'package:beam/features/domain/entities/steps/ongoing_daily_step_count.dart';

abstract class StepCounterService {
  Future<void> startService();

  Future<void> stopService();

  Future<bool> isInitialized();

  Stream<bool> observeServiceStatus();

  Stream<StepCountEvent> observeStepCountEvents();
}
