import 'package:beam/features/domain/repositories/step_counter_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class StepCounterServiceInteractor {
  final StepCounterService _stepCounterService;

  StepCounterServiceInteractor(this._stepCounterService);

  Future<void> startStepCounter() {
    return _stepCounterService.startService();
  }

  Future<void> stopStepCounter() async {
    await _stepCounterService.stopService();
  }

  Stream<bool> observeStepCounterStatus() {
    return _stepCounterService.observeServiceStatus();
  }
}
