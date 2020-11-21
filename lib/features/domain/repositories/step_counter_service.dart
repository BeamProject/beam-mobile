import 'package:beam/features/domain/entities/steps/ongoing_daily_step_count.dart';

abstract class StepCounterService {
  Stream<StepCountEvent> observeStepCountEvents();
}