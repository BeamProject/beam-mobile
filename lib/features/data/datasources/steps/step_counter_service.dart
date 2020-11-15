import 'package:beam/features/data/datasources/steps/model/step_count_event.dart';

abstract class StepCounterService {
  Stream<StepCountEvent> observeStepCountEvents();
}