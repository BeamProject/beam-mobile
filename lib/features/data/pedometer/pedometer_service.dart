import 'package:beam/features/data/datasources/steps/model/step_count_event.dart';
import 'package:beam/features/data/datasources/steps/step_counter_service.dart';
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
