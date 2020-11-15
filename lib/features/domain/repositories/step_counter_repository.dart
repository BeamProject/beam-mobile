import 'package:beam/features/domain/entities/steps/step_count.dart';

abstract class StepCounterRepository {
  Stream<StepCount> observeStepCount();
}