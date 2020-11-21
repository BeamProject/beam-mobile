
import 'package:beam/features/domain/entities/steps/ongoing_daily_step_count.dart';
import 'package:beam/features/domain/repositories/step_counter_service.dart';
import 'package:injectable/injectable.dart';
import 'package:pedometer/pedometer.dart';

@lazySingleton
class PedometerService implements StepCounterService {
  Stream<StepCountEvent> _stepCountEventStream;

  @override
  Stream<StepCountEvent> observeStepCountEvents() {
    if (_stepCountEventStream != null) {
      return _stepCountEventStream;
    }
    _stepCountEventStream = Pedometer.stepCountStream.map((stepCount) =>
        StepCountEvent(
            dayOfMeasurement: stepCount.timeStamp, steps: stepCount.steps));

    return _stepCountEventStream;
  }
}
